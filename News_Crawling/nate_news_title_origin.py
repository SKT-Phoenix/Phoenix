
import sys, os
from bs4 import BeautifulSoup
import requests
from selenium import webdriver
import selenium
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from webdriver_manager.chrome import ChromeDriverManager
from datetime import datetime, timedelta
from pandas import DataFrame
import time
from selenium.webdriver.common.by import By

sleep_sec = 0.5

# User-Agent를 입력해주세요.
headers = {'User-Agent' : '________________'}

# 날짜 지정
yesterday = (datetime.today() - timedelta(1)).strftime("%Y%m%d")

part_num = ['201', '301', '501', '601']

def news_crawling(part_num):
    
    service = Service(executable_path=ChromeDriverManager().install())
    browser = webdriver.Chrome(service=service)

    print('검색할 분야 : {}'.format(part_num))

    print('브라우저를 실행시킵니다(자동 제어)\n')

    ################# 뉴스 크롤링 #################

    print('\n크롤링을 시작합니다.')

    #####동적 제어로 페이지 넘어가며 크롤링
    tlt = str()
    page = 1
    news_num = 100
    

    while True:
     
        news_url = 'https://news.nate.com/recent?mid=n0{0}&type=c&date={1}&page={2}'.format(part_num,yesterday,page)
        browser.get(news_url)
        time.sleep(sleep_sec)

        table = browser.find_element(By.XPATH,'//div[@id="newsContents"]')
        li_list = table.find_elements(By.XPATH,'.//div[@class="mduSubjectList"]')
        a_list = [li.find_element(By.XPATH,'.//a[@class="lt1"]') for li in li_list]
    
        for n in a_list[:min(len(a_list), news_num-idx+1)]:
            n_url = n.get_attribute('href')
            tlt += n.find_element(By.XPATH,'.//strong[@class="tit"]').text
            #tlt += crawling_main_text(n_url)
            
        page += 1

        if len(a_list) == 0:
            print('\n브라우저를 종료합니다.\n' + '=' * 100)
            time.sleep(0.7)
            browser.close()
            break

    return tlt
       

news_dict = {}
idx = 1
for pn in part_num:
    tlt = news_crawling(pn)
    news_dict[idx] = {'분야': pn,
                    '제목모음' : tlt}            
    idx += 1

news_df = DataFrame(news_dict).T

folder_path = os.getcwd()
xlsx_file_name = '{0}_title.xlsx'.format(yesterday)

news_df['분야'].replace('201', '정치', inplace=True)
news_df['분야'].replace('301', '경제', inplace=True)
news_df['분야'].replace('501', '세계', inplace=True)
news_df['분야'].replace('601', 'IT/과학', inplace=True)

news_df.to_excel(xlsx_file_name, index=False)

print('엑셀 저장 완료 | 경로 : {}\\{}\n'.format(folder_path, xlsx_file_name))
    