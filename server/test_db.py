# python 3.9
import os
import pandas as pd
import time
from datetime import date, timedelta
from models import *

# 요약 모델 load
summarizer = Summarizer_with_KoBart()

# 읽어올 엑셀 파일 지정
filename = f'./{date.today() - timedelta(1)}.xlsx'

# 엑셀 파일 읽어 오기
df = pd.read_excel(filename, engine='openpyxl')

col = ['분야', '타이틀', '발행일자', '링크', '본문']



summarized = []
for i, text in enumerate(df['본문']):
    text_len = len(text)
    if(text_len) > 3000:
        text = text[:int(text_len/2)]
        
    print(f"{i+1}번째 요약")
    start = time.time()
    result = summarizer.generate(text, input_size=1024)
    summarized.append(result)
    now = time.time()-start
    print('요약시간:', now)
    
df['요약문'] = summarized

print(df)