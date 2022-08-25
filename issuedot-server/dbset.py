import pymysql
import pandas as pd
import time
from datetime import date, timedelta
from models import *

# 요약 모델 load
summarizer = Summarizer_with_KoBart()

# 읽어올 엑셀 파일 지정
filename = f'./static/{date.today() - timedelta(1)}.xlsx'

# 엑셀 파일 읽어 오기
df = pd.read_excel(filename, engine='openpyxl')



# 요약 모델 적용
summarized = []
del_index = []
category = {'정치': 0, '경제': 0, '사회': 0, '세계': 0, 'IT/과학': 0}
i = 0
for cate, text in zip(df['분야'], df['본문']):
    # 본문길이가 500자 이하인 뉴스는 pass
    if len(text) < 900:
        del_index.append(i)
        i += 1
        continue
    
    # 3번째 뉴스는 pass
    category[cate] += 1
    if category[cate] >= 3:
        del_index.append(i)
        i += 1
        continue
    
    
    # 본문길이가 3000자 이상이면 본문길이 3/4로 축소
    text_len = len(text)
    if(text_len) > 3000:
        text = text[:int(text_len/1.5)]
        
    print(f"{cate}{category[cate]}번째뉴스 요약")
    start = time.time()
    result = summarizer.generate(text, input_size=1024)
    summarized.append(result)
    now = time.time()-start
    print(f'요약시간: {round(now, 2)}\n')
    i += 1
    
df.drop(del_index, axis=0, inplace = True)
df['요약문'] = summarized
df.reset_index(drop=True, inplace=True)



# DB connection
conn = pymysql.connect(host='localhost', user='root', password='root',
                       db='news', charset='utf8mb4')

# Connection 으로부터 Dictoionary Cursor 생성
curs = conn.cursor(pymysql.cursors.DictCursor)

# insert summarized into db
for i in range(len(df)):
    sql = "insert into `news`.summarized (발행일자, 분야, 타이틀, 링크, 본문, 요약문) values (%s, %s, %s, %s, %s, %s)"
    curs.execute(sql, (df.iloc[i][0], df.iloc[i][1], df.iloc[i][2], df.iloc[i][3], df.iloc[i][4], df.iloc[i][5]))



# 데이타 commit
conn.commit()

# Connection 닫기
conn.close()