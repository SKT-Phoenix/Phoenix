from argparse import ArgumentParser

import torch
from tokenizers import SentencePieceBPETokenizer
from torch.utils.data import DataLoader
from tqdm import tqdm
from transformers import GPT2LMHeadModel

from korquad_qg.config import QGConfig
from korquad_qg.dataset import MAX_QUESTION_SPACE, MIN_QUESTION_SPACE, QAExample, QGDecodingDataset

import numpy as np
import itertools

from konlpy.tag import Okt
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from sentence_transformers import SentenceTransformer

parser = ArgumentParser()
parser.add_argument("-m", "--model-path", type=str, required=True)
parser.add_argument("-s", "--num-samples", type=int)
parser.add_argument("-b", "--num-beams", type=int, default=5)


def max_sum_sim(doc_embedding, candidate_embeddings, words, top_n, nr_candidates):
    # 문서와 각 키워드들 간의 유사도
    distances = cosine_similarity(doc_embedding, candidate_embeddings)

    # 각 키워드들 간의 유사도
    distances_candidates = cosine_similarity(candidate_embeddings, 
                                            candidate_embeddings)

    # 코사인 유사도에 기반하여 키워드들 중 상위 top_n개의 단어를 pick.
    words_idx = list(distances.argsort()[0][-nr_candidates:])
    words_vals = [words[index] for index in words_idx]
    distances_candidates = distances_candidates[np.ix_(words_idx, words_idx)]

    # 각 키워드들 중에서 가장 덜 유사한 키워드들간의 조합을 계산
    min_sim = np.inf
    candidate = None
    for combination in itertools.combinations(range(len(words_idx)), top_n):
        sim = sum([distances_candidates[i][j] for i in combination for j in combination if i != j])
        if sim < min_sim:
            candidate = combination
            min_sim = sim

    return [words_vals[idx] for idx in candidate]



def main():
    config = QGConfig()
    args = parser.parse_args()

    model = GPT2LMHeadModel.from_pretrained("taeminlee/kogpt2")
    model.load_state_dict(torch.load(args.model_path, map_location="cpu"))
    device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
    model = model.to(device)

    tokenizer = SentencePieceBPETokenizer.from_file(
        vocab_filename="tokenizer/vocab.json", merges_filename="tokenizer/merges.txt", add_prefix_space=False
    )


    doc = """
      서울=연합뉴스) 고현실 기자 = 서울시가 택시 기본요금을 800원 이상 올리는 안을 검토하고 있다. 올해 연말부터 심야 할증 시간을 앞당기고, 할증 요금을 최대 40% 올리는 방안도 추진한다.

26일 서울시에 따르면 시는 현재 3천800원인 일반택시 기본요금(2㎞ 기준)을 20% 이상 올리는 안을 포함한 택시요금 조정안을 마련 중이다.

서울 일반택시 기본요금은 1998년 1천300원, 2001년 1천600원에서 2005년 1천900원, 2009년 2천400원, 2013년 3천원, 2019년 3천800원으로 올랐다. 요금이 오를 때마다 평균 인상률은 24.0%로, 이를 현행 요금에 적용하면 이번에 오를 요금은 4천600원에서 4천800원 사이가 될 가능성이 크다.

시는 또 기본요금 인상에 앞서 시급한 심야 택시대란을 해소하기 위해 올해 연말부터 심야 할증 요금 확대에 나설 방침이다.

현재 검토 중인 방안 가운데는 밤 12시부터 다음 날 오전 4시까지인 심야할증 시간을 밤 10시로 앞당기는 안이 유력하다.

여기에 택시 수요가 몰리는 밤 11시부터 오전 2시에는 기존 할증요율인 20%보다 갑절 높은 40%를 적용하는 안이 검토되고 있다. 이렇게 되면 해당 시간대 기본요금은 현행 4천600원에서 5천300원까지 올라간다.

다만 심야할증 요금이 우선 오르는 만큼 시민 부담을 최소화하기 위해 기본요금 조정은 시간을 두고 내년부터 본격적으로 추진할 것으로 예상된다.

시는 조만간 택시요금 조정안을 확정해 발표할 예정이다. 다음 달 5일에는 '심야 승차난 해소를 위한 택시요금정책 개선' 공청회를 열어 관련 업계와 전문가, 시민들의 의견을 수렴한다.

조정안은 이어 시의회 의견 청취와 물가대책위원회를 거치게 되는데, 이 과정에서 변동될 가능성도 있다.
        """


    okt = Okt()

    tokenized_doc = okt.pos(doc)
    tokenized_nouns = ' '.join([word[0] for word in tokenized_doc if word[1] == 'Noun'])

    n_gram_range = (1, 1)

    count = CountVectorizer(ngram_range=n_gram_range).fit([tokenized_nouns])
    candidates = count.get_feature_names_out()

    model_s = SentenceTransformer('sentence-transformers/xlm-r-100langs-bert-base-nli-stsb-mean-tokens')
    doc_embedding = model_s.encode([doc])
    candidate_embeddings = model_s.encode(candidates)

    examples = [
        QAExample(
            doc
            ,
            max_sum_sim(doc_embedding, candidate_embeddings, candidates, top_n=5, nr_candidates=10)[0],
        ),
    ]
    dataset = QGDecodingDataset(examples, tokenizer, config.max_sequence_length)
    dataloader = DataLoader(dataset, batch_size=1)

    model = model.to(device)
    model.eval()

    generated_results = []

    for i, batch in tqdm(enumerate(dataloader), desc="generate", total=len(dataloader)):
        input_ids, attention_mask = (v.to(device) for v in batch)
        origin_seq_len = input_ids.size(-1)

        decoded_sequences = model.generate(
            input_ids=input_ids,
            attention_mask=attention_mask,
            max_length=origin_seq_len + MAX_QUESTION_SPACE,
            min_length=origin_seq_len + MIN_QUESTION_SPACE,
            pad_token_id=0,
            bos_token_id=1,
            eos_token_id=2,
            do_sample=True,
            num_beams=5,
            repetition_penalty=1.3,
            no_repeat_ngram_size=3,
            num_return_sequences=3,
        )

        for decoded_tokens in decoded_sequences.tolist():
            decoded_question_text = tokenizer.decode(decoded_tokens[origin_seq_len:])
            decoded_question_text = decoded_question_text.split("</s>")[0].replace("<s>", "")
            generated_results.append(
                (examples[i].context, examples[i].answer, examples[i].question, decoded_question_text)
            )

    with open("article_qg.tsv", "a") as f:
        for context, answer, question, generated_question in generated_results:
            f.write(f"문맥\t{context}\n")
            f.write(f"답변\t{answer}\n")
            f.write(f"생성된 질문\t{generated_question}\n")
            if question is not None:
                f.write(f"실제 질문\t{question}\n")
            f.write("\n")

            print(f"문맥\t{context}\n")
            print(f"답변\t{answer}\n")
            print(f"생성된 질문\t{generated_question}\n")
            if question is not None:
                print(f"실제 질문\t{question}")
            print()


if __name__ == "__main__":
    main()
