from flask import Flask, render_template, request, redirect, url_for, jsonify
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from database_setup import *


from crawler import *

app = Flask(__name__)


News = News()



# DB 연결
engine = create_engine('mysql+pymysql://root:root@localhost/news')
Base.metadata.bind = engine

DBSession = sessionmaker(bind=engine)
session = DBSession()

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


