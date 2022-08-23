from flask import Flask, render_template, request, redirect, url_for, jsonify
import pymysql


from crawler import *

app = Flask(__name__)


News = News()



# DB connection
conn = pymysql.connect(host='localhost', user='root', password='root',
                       db='madang', charset='utf8')


# ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ


@app.route('/', methods=['GET', 'POST'])
def news():
    
    # 크롬 확장프로그램 버전
    if request.method == 'POST':
        pass
    
    
    # app 버전
    elif request.method == 'GET':
        pass
    
    
if __name__ == '__main__':
    app.debug = True
    app.run(host='0.0.0.0', port=8000)
        
        
















# ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ


