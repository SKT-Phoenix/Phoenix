import pymysql
import pandas as pd
import time
from datetime import date, timedelta
from models import *
from crawler import *

# 요약 모델 load
summarizer = Summarizer_with_KoBart()

# 읽어올 엑셀 파일 지정 (어제자 뉴스)
filename = f'./static/{date.today() - timedelta(1)}.xlsx'

# 엑셀 파일 읽어 오기
df = pd.read_excel(filename, engine='openpyxl')

major = pd.read_excel("static/용어.xlsx")


# 요약 모델 적용
summarized = [] # 요약문
main_text = []   # 주요 단어
text_explain = [] # 단어 설명

del_index = []
category = {'정치': 0, '경제': 0, '사회': 0, '세계': 0, 'IT/과학': 0}

i = 0
for cate, text in zip(df['분야'], df['본문']):
    # 본문길이가 500자 이하인 뉴스는 pass
    if len(text) < 500:
        del_index.append(i)
        i += 1
        continue
    
    # 3번째이상 뉴스는 pass
    category[cate] += 1
    if category[cate] >= 3:
        del_index.append(i)
        i += 1
        continue
    
    # 본문길이가 3000자 이상이면 본문길이 3/4로 축소
    text_len = len(text)
    if(text_len) > 3000:
        text = text[:int(text_len/1.5)]
        
    # 요약문 생성
    print(f"\n{cate}{category[cate]}번째뉴스 요약")
    start = time.time()
    result = summarizer.generate(text, input_size=1024)
    summarized.append(result)
    now = time.time()-start
    print(f'요약시간: {round(now, 2)}')
    print(result)
    # 주요단어 생성
    text_temp = [] # 주요 단어 담을 임시 리스트
    explain_temp = [] # 설명 담을 임시 str문
    
    print('주요 단어 검색')
    for idx, j in enumerate(major.iloc[:, 1]):
        if j in result:
            print(j, end=' ')
            news_dic = crawling_dic(j) # 설명 검색
            text_temp.append(j)
            explain_temp.append(news_dic)
        
            
    main_text.append('§'.join(text_temp))
    text_explain.append('§'.join(explain_temp))
    
    i += 1
    
df.drop(del_index, axis=0, inplace = True)
df['요약문'] = summarized
df['주요단어'] = main_text
df['단어설명'] = text_explain

df.reset_index(drop=True, inplace=True)


# excel파일 변경
yesterday = (datetime.today() - timedelta(1)).strftime("%Y-%m-%d")
xlsx_file_name = 'static\{0}.xlsx'.format(yesterday)
df.to_excel(xlsx_file_name, index=False)

# DB connection
conn = pymysql.connect(host='localhost', user='root', password='root',
                       db='news', charset='utf8mb4')

# Connection 으로부터 Dictoionary Cursor 생성
curs = conn.cursor(pymysql.cursors.DictCursor)

sql = "delete from `news`.summarized"
curs.execute(sql)

# insert summarized into db
for i in range(len(df)):
    sql = "insert into `news`.summarized (발행일자, 분야, 타이틀, 링크, 요약문, 주요단어, 단어설명) values (%s, %s, %s, %s, %s, %s, %s)"
    curs.execute(sql, (df.iloc[i][0], df.iloc[i][1], df.iloc[i][2], df.iloc[i][3], df.iloc[i][5], df.iloc[i][6], df.iloc[i][7]))

conn.commit()
conn.close()



print("\n "+"=" * 50)
print("∥               [INFO] DB setting 완료            ∥") 
print(" "+"=" * 50)