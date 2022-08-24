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
for i, text in enumerate(df['본문']):
    text_len = len(text)
    if(text_len) > 3000:
        text = text[:int(text_len/1.5)]
        
    print(f"{i+1}번째 요약")
    start = time.time()
    result = summarizer.generate(text, input_size=1024)
    summarized.append(result)
    now = time.time()-start
    print(f'요약시간: {round(now, 2)}\n')
    
df['요약문'] = summarized



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