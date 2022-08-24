from flask import Flask, render_template, request, redirect, url_for, jsonify
from datetime import date, timedelta
from models import *

import pymysql
import time

import ssl

app = Flask(__name__)
# app.config['JSON_AS_ASCII'] = False

summa_model = Summarizer_with_KoBart()
print("=" * 50)
print("[INFO]: summarizer 초기화 성공") 

# News = News()



# DB connection
# conn = pymysql.connect(host='localhost', user='root', password='root',
#                        db='news', charset='utf8mb4')
# curs = conn.cursor(pymysql.cursors.DictCursor)

# ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ


@app.route('/', methods=['GET', 'POST'])
def news():
    # 크롬 확장프로그램 버전
    if request.method == 'POST':
        text = request.form['content']
        deep = True if request.form['deep'] == 'true' else False
        target_lang = request.form['target_lang']
        
        print("요약 start")
        start = time.time()
        text_res = summa_model.generate(text) # 번역
        print("요약 소요시간:", time.time() - start)
            
        # JSON 객체 생성
        result = {
            'text': text_res,
            'deep': deep,
            'target_lang': target_lang
            
        }
    
        return jsonify(result)
    
    # app 버전
    elif request.method == 'GET':
        # SQL문 실행, %s : 문자열이든 숫자이든 %s 사용
        conn = pymysql.connect(host='localhost', user='root', password='root',
                       db='news', charset='utf8mb4')
        curs = conn.cursor(pymysql.cursors.DictCursor)
        sql = "select * from `news`.summarized where 발행일자=%s"
        curs.execute(sql, ((date.today() - timedelta(1)).strftime("%Y-%m-%d")))
        
        result = curs.fetchall()
        
        conn.close()
        
        # result = {
        #     'text': "안녕",
        #     'deep': "ㅋㅋ",
        #     'target_lang': "ㄷㄷ"
        # }

        # JSON 객체 생성
        return jsonify(result)
    
        
    
    
    
@app.route('/rank', methods=['GET', 'POST'])
def rank():
    # user point update
    if request.method == 'POST':
        pass
    
    
    # user point return
    elif request.method == 'GET':
        pass
    
if __name__ == '__main__':
    
    # ssl_context = ssl.SSLContext(ssl.PROTOCOL_TLS)
    # ssl_context.load_cert_chain(certfile='private.crt', keyfile='private.key', password='root')
    
    app.debug = True
    app.run(host='0.0.0.0', port=8000)
        
        


# ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ


