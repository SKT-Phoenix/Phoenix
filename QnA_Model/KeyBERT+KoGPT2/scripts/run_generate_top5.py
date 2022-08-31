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
        윤석열 대통령 자택이 있는 서울 서초동 아크로비스타 건물의 헬리포트(헬기 착륙장)에 '대통령 전용헬기'가 이·착륙할 수 없는 것으로 확인됐다.

따라서 서울에 기록적인 폭우가 쏟아지던 지난 8일 밤, '자택 전화지휘'를 한 윤 대통령이 '한밤중 헬기 이동 방안도 검토했으나 주민 불편을 우려해 포기했다'는 일부 언론보도는 현실적으로 불가능한 내용이었던 것으로 보인다. 

소방청이 이동주 더불어민주당 의원(비례대표)에 제출한 '2022년도 고층건물 옥상 헬기장 현황(서초구)' 자료에 따르면, 현행 건축법령상 아크로비스타 건축물은 "길이와 너비 각각 22미터 이상의 헬리포트가 설치돼 있지 않아 (헬기의) 이·착륙이 어렵다"고 밝혔다. 

다만 아크로비스타의 헬리포트의 경우 "구조공간(직경 10m 이상)이 확보돼 호이스트(로프)로 인명구조가 가능한 곳"이라고 설명했으며 "상기건물(아크로비스타)은 서울 항공대가 보유한 헬기가 착륙할 수 있는 공간으로는 충분하지 않음"이라고 적시했다.

윤 대통령 자택에서 헬기 이용이 불가능하다는 지적은 취임 초부터 이전 대통령 경호실 근무자로부터 나왔는데, 소방청 공식자료로 확인된 것은 이번이 처음이다. 

소방청 "아크로비스타, 헬기 이·착륙 어렵다".
소방청 자료에 따르면, 서울항공대가 보유한 헬기 AS-365(2대)의 전장은 13.72m이며, 닥터헬기 기종인 AW-189(1대)의 전장은 17.57m다. 그러나 대통령 전용헬기 S-92의 경우 두 기종에 비해 더 무겁고 날개 지름이 크다. 

닥터헬기인 AW-189의 동체 길이는 17.57m이며, 로터(날개)지름은 14.6m, 임무중량은 8600kg이다. 반면 대통령 전용헬기인 S-92의 동체 길이는 17.32m, 로터 지름은 17.71m, 임무중량은 1만 1000kg 이상 가능하다(출처 : 각 헬기 제조사인 아구스타웨스틀랜드사, 시콜스키사). 대통령 전용헬기가 닥터헬기보다 동체길이는 0.25m 짧지만, 로터 지름은 3.11m 길다. 

또한 소방청이 제출한 다른 자료를 보면, 서초동 아크로비스타 A동과 C동은 헬리포트의 너비도 충분하지 않았다. 때문에 헬기 착륙이 불가능하고, 현재 이 헬리포트는 구조공간으로만 활용하고 있었다. 

2003년에 개정된 현행 '건축물의 피난, 방화구조 등의 기준에 관한 규칙' 제13조에는 헬리포트의 길이와 너비는 각각 22m 이상으로 해야 한다. 하지만 건축물 옥상바닥 길이와 너비가 각각 22m 이하인 경우에는 길이와 너비를 각각 15m까지 감축할 수 있게 돼 있으며, 2003년 이전에 헬리포트의 최소 너비를 10m까지 허용해 줬다. 

서울시와 소방청 자료를 보면, 실제 아크로비스타 A동과 C동의 헬리포트의 길이와 너비는 각각 10.5m였다. 현행 기준에는 미달이다. 아크로비스타의 경우 2000년 2월 23일 건축허가를 받은 건축물이기 때문에, 최소 너비인 10m 이상의 헬리포트만으로도 운영이 가능했다. 

심지어 아크로비스타 건물에는 헬기포트가 A동과 C동에만 설치돼 있고, 윤석열 대통령이 거주하는 B동에는 헬리포트 자체가 없다. 

이런 내용을 종합하면, 윤석열 대통령의 자택인 서초동 아크로비스타 건물에는 소방(닥터)헬기뿐만 아니라 대통령 전용헬기의 이·착륙 자체가 애초 불가능하다.

안보공백 전혀 없다더니
이동주 의원은 22일 "대통령 거처에서 헬기의 이착륙이 불가능하다는 것은 국가안보의 심각한 구멍"이라며, "대통령실과 윤 대통령은 집무실을 청와대에서 용산으로 옮기면서 이 사실을 제대로 알고 있었는지 의문"이라고 지적했다. 이어 "현실이 이런데도 대통령실이 안보 공백이 없다고 말하는데, 이는 명백한 거짓말"이라고 주장했다.

한편, 윤석열 대통령은 지난 8일 밤 서울지역 폭우로 인한 피해가 커지자 곧바로 광화문 중앙재난안전대책본부(중대본)로 이동하려 했지만, 자택 주변 도로가 막혀 무산된 것으로 알려졌다. 결국 서초동 아크로비스타 대통령 자택이 '재난본부 상황실'이 됐고, '재택 전화지휘'가 이뤄졌다.

이를 두고 비판 여론이 들끓자, 한덕수 국무총리는 지난 11일 CBS라디오 <김현정의 뉴스쇼>에 출연 "요즘 그런 위기상황이란 것은 (총책임자가) 꼭 현장에 있어야 한다는 건 아닌 것 같다"면서 "위급상황에 대처하기 위해 대통령 자택에 지하벙커 수준의 체계를 갖추고 있다"라고 해명해 논란이 가중되기도 했다. 

경호처 "사저에 국기지도통신차량 유사시스템 구축... 헬기 필요시 인근 평지 이용"

경호처 관계자는 23일 오전 <오마이뉴스> 보도와 관련해 "지난 8일 윤석열 대통령은 사저에서 국무총리와 행안부장관 등으로부터 실시간 보고를 받으며 피해상황에 대처했다"면서 "지하벙커 수준의 시스템을 갖춘 국가지도통신차량이 대기하고 있었으며 사저에도 유사한 시스템이 구축돼 있었다"고 반박했다.

이어 그는 "이날(8일) 윤 대통령의 이동이 필요할 경우에 대비해 차량도 인근에 배치된 상태였다"면서 "전용헬기 운용에 대해서도 검토했으나 기상조건 및 주민불편 등을 고려했을 때 적절하지 않은 것으로 판단했다"고 강조했다.

또한 이 관계자는 "만일 전용헬기를 운용하더라도 아크로비스타 건축물에서 이·착륙하는 것은 원천적으로 불가능한 일이다"라며 "헬리포트의 면적이 협소할 뿐만 아니라 이·착륙시 헬기 하중을 건축물이 감당할 수 없기 때문이고, 헬기 운용이 필요할 경우 사저 인근의 평지를 이용하는 게 기본원칙"이라고 설명했다.
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

    for i in range(5):

        examples = [
            QAExample(
                doc
                ,
                max_sum_sim(doc_embedding, candidate_embeddings, candidates, top_n=5, nr_candidates=10)[i],
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
