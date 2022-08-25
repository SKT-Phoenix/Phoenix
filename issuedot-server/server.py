from flask import Flask, request, jsonify
# from flask_sslify import SSLify
from datetime import date, timedelta
from models import *


import pymysql
import time

app = Flask(__name__)
# app.config['JSON_AS_ASCII'] = False

print(" "+"=" * 50)
print("∥              [INFO] server 초기화 성공          ∥") 
print(" "+"=" * 50)


# ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ


@app.route('/', methods=['GET', 'POST'])
def news():
    
    # app 버전
    if request.method == 'GET':
        
        conn = pymysql.connect(host='localhost', user='root', password='root',
                       db='news', charset='utf8mb4')
        curs = conn.cursor(pymysql.cursors.DictCursor)
        sql = "select * from `news`.summarized where 발행일자=%s"
        curs.execute(sql, ((date.today() - timedelta(1)).strftime("%Y-%m-%d")))
        
        result = curs.fetchall()
        
        conn.close()
        
       

        # JSON 객체 생성
        return jsonify(result)
    
        
    
    
    
@app.route('/rank', methods=['GET', 'POST'])
def rank():
    # user point update
    if request.method == 'POST':
        result = 'bye'
        
        return jsonify(result)
    
    
    # user point return
    elif request.method == 'GET':
        return "hello"
    
    
    
if __name__ == '__main__':
    
    app.debug = True
    app.run(host='0.0.0.0', port=8000 )
        
        


