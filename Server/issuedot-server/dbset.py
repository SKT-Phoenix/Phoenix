from datetime import datetime, timedelta
from models import *
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from webdriver_manager.chrome import ChromeDriverManager
from selenium import webdriver
# from news_select import *

import os
import pymysql
import pandas as pd
import time



# java 환경변수 설정
os.environ['JAVA_HOME'] = r'C:\Program Files\Java\jdk-18.0.2.1\bin\server'

# 요약 모델 load
summarizer = Summarizer_with_KoBart()

# qna 모델 load
model = SentenceTransformer('sentence-transformers/xlm-r-100langs-bert-base-nli-stsb-mean-tokens')


# 읽어올 엑셀 파일 지정 (어제자 뉴스)
yesterday = (datetime.today() - timedelta(1)).strftime("%Y%m%d")
filename = f'static/selected/selected_{yesterday}.csv'

# 엑셀 파일 읽어 오기
df = pd.read_csv(filename)
major = pd.read_excel("static/용어.xlsx")


# 요약 모델 적용
summarized = [] # 요약문
main_text = []   # 주요 단어
text_explain = [] # 단어 설명

# 퀴즈 모델 적용
question = [] # 문제
answer = []   # 정답

del_index = []
category = {'정치': 0, '경제': 0, '사회': 0, '세계': 0, 'IT/과학': 0}

def crawling_dic(str_dic):

    service = Service(executable_path=ChromeDriverManager().install())
    browser = webdriver.Chrome(service=service)

    news_url = 'https://dic.daum.net/search.do?q={0}&dic=kor'.format(str_dic)

    browser.get(news_url)
    time.sleep(0.5)
    
    try:
        table = browser.find_element(By.XPATH,'//div[@class="cleanword_type kokk_type"]')
        dic = table.find_element(By.XPATH,'.//span[@class="txt_search"]').text
        
    except:
        try:
            table = browser.find_element(By.XPATH,'//ul[@class="list_mean"]')
            dic = table.find_element(By.XPATH,'.//span[@class="txt_mean"]').text
        except:
            table = browser.find_element(By.XPATH,'//ul[@class="list_search"]')
            dic = table.find_element(By.XPATH,'.//span[@class="txt_search"]').text
    
    return dic

def max_sum_sim(doc_embedding, candidate_embeddings, words, top_n, nr_candidates):
    # 문서와 각 키워드들 간의 유사도
    distances = cosine_similarity(doc_embedding, candidate_embeddings)

    # 각 키워드들 간의 유사도
    distances_candidates = cosine_similarity(candidate_embeddings, 
                                            candidate_embeddings)

    # 코사인 유사도에 기반하여 키워드들 중 상위 top_n개의 단어를 pick.
    words_idx = list(distances.argsort()[0][-nr_candidates:])
    words_vals = [candidates[index] for index in words_idx]
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

i = 0
for cate, text in zip(df['분야'], df['본문']):
    # 본문길이가 500자 이하인 뉴스는 pass
    print("\nbefore text길이 :", len(text))
    # if len(text) < 500:
    #     del_index.append(i)
    #     i += 1
    #     continue
    
    # 3번째이상 뉴스는 pass
    # category[cate] += 1
    # if category[cate] >= 3:
    #     del_index.append(i)
    #     i += 1
    #     continue
    
    # 본문길이가 2500자 이상이면 본문길이 3/4로 축소
    text_len = len(text)
    if(text_len) > 2500:
        text = text[:int(text_len/1.5)]
    
    # 요약문 생성
    start = time.time()
    result = summarizer.generate(text, input_size=1024)
    summarized.append(result)
    now = time.time()-start
    print(f'요약시간: {round(now, 2)}')
    print(result)
    
    # 주요단어 생성
    text_temp = [] # 주요 단어 담을 임시 리스트
    explain_temp = [] # 설명 담을 임시 str문
    
    print('☆주요 단어 검색☆')
    for idx, j in enumerate(major.iloc[:, 1]):
        if j in result:
            print(j, end=' ')
            news_dic = crawling_dic(j) # 설명 검색
            text_temp.append(j)
            explain_temp.append(news_dic)
        
            
    main_text.append('§'.join(text_temp))
    text_explain.append('§'.join(explain_temp))
    
    
    
    
    # quiz 생성
    okt = Okt()

    tokenized_doc = okt.pos(text)
    tokenized_nouns = ' '.join([word[0] for word in tokenized_doc if word[1] == 'Noun'])
    n_gram_range = (1, 1)

    count = CountVectorizer(ngram_range=n_gram_range).fit([tokenized_nouns])
    candidates = count.get_feature_names_out()
    doc_embedding = model.encode([text])
    candidate_embeddings = model.encode(candidates)
    
    keyword = max_sum_sim(doc_embedding, candidate_embeddings, candidates, top_n=5, nr_candidates=10)
    print(keyword)
    
    
    input_answer = '[MASK]'
    # input_answer = max(keyword, key=len)
    # input_answer = keyword[0]
    generated = generate(best_model, input_answer, text)
    quiz = generated.split(" <sep> ")
    
    question.append(quiz[1])
    answer.append(quiz[0])
    
    
    
    i += 1
    
df.drop(del_index, axis=0, inplace = True)
df['요약문'] = summarized
df['주요단어'] = main_text
df['단어설명'] = text_explain
df['문제'] = question
df['정답'] = answer


df.reset_index(drop=True, inplace=True)


# excel파일 변경
xlsx_file_name = 'static/updated/completed_{0}.xlsx'.format(yesterday)
df.to_excel(xlsx_file_name, index=False)

# DB connection
conn = pymysql.connect(host='localhost', user='root', password='root',
                       db='news', charset='utf8mb4')

# Connection 으로부터 Dictoionary Cursor 생성
curs = conn.cursor(pymysql.cursors.DictCursor)

sql = "delete from `news`.summarized"
curs.execute(sql)

sql = "delete from `news`.qna"
curs.execute(sql)

# insert summarized, quiz into db
for i in range(len(df)):
    sql = "insert into `news`.summarized (발행일자, 분야, 타이틀, 링크, 요약문, 주요단어, 단어설명) values (%s, %s, %s, %s, %s, %s, %s)"
    curs.execute(sql, (df.iloc[i][0], df.iloc[i][1], df.iloc[i][2], df.iloc[i][3], df.iloc[i][5], df.iloc[i][6], df.iloc[i][7]))
    
    sql = "insert into `news`.qna (발행일자, 분야, 질문, 정답) values (%s, %s, %s, %s)"
    curs.execute(sql, (df.iloc[i][0], df.iloc[i][1], df.iloc[i][8], df.iloc[i][9]))

conn.commit()
conn.close()



print("\n "+"=" * 50)
print("∥               [INFO] DB setting 완료            ∥") 
print(" "+"=" * 50)