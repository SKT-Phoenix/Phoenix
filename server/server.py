from flask import Flask, render_template, request, redirect, url_for, jsonify
from crawler import *
from models import *

import pymysql
import time

app = Flask(__name__)

summa_model = Summarizer_with_KoBart()
print("=" * 50)
print("[INFO]: summarizer 초기화 성공") 

# News = News()



# DB connection
conn = pymysql.connect(host='localhost', user='root', password='root',
                       db='news', charset='utf8')


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
        
        
        
        # JSON 객체 생성
        result = {
            'text': text_res,
            'deep': deep,
            'target_lang': target_lang
            
        }
        return jsonify(result)
    
    
if __name__ == '__main__':
    app.debug = True
    app.run(host='0.0.0.0', port=8000)
        
        
















# ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ


