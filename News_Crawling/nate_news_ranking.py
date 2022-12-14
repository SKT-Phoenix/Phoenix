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
import pandas as pd
import time
from selenium.webdriver.common.by import By

sleep_sec = 0.5

headers = {'User-Agent' : '________________'}

# 날짜 지정
yesterday = (datetime.today() - timedelta(1)).strftime("%Y%m%d")

def crawling_main_text(url):

    req = requests.get(url, headers=headers)
    req.encoding = None
    soup = BeautifulSoup(req.text, 'html.parser')

    text = soup.find('div', {'id' : 'realArtcContents'})
    date = soup.find('em').text
    title = soup.find('h3', {'class' : 'articleSubecjt'}).text
    date = date[0:10]

    a_tag = text.find_all('a')
    for i in range(len(a_tag)):
        text.find('a').decompose()

        
    return (text.text.replace('\n','').replace('\r','').replace('<br>','').replace('\t',''), date,title)


part_name = ['pol', 'eco', 'soc', 'int', 'its']
news_df=pd.DataFrame()


def news_crawling(part_name):
    
    service = Service(executable_path=ChromeDriverManager().install())
    browser = webdriver.Chrome(service=service)

    print('검색할 분야 : {}'.format(part_name))

    print('브라우저를 실행시킵니다(자동 제어)\n')

    news_url = 'https://news.nate.com/rank/interest?sc={0}&p=day&date={1}'.format(part_name,yesterday)
    browser.get(news_url)
    time.sleep(sleep_sec)

    ################# 뉴스 크롤링 #################

    print('\n크롤링을 시작합니다.')

    #####동적 제어로 페이지 넘어가며 크롤링
    idx = 1
    news_dict = {}

    table = browser.find_element(By.XPATH,'//div[@id="newsContents"]')
    li_list = table.find_elements(By.XPATH,'.//div[@class="mduSubjectList f_clear"]')
    a_list = [li.find_element(By.XPATH,'.//a[@class="lt1"]') for li in li_list][:2]

    
    for n in a_list:
        n_url = n.get_attribute('href')
        news_dict[idx] = {'분야': part_name,
                        '타이틀' : crawling_main_text(n_url)[2],
                        '발행일자' : crawling_main_text(n_url)[1],
                        '링크' : n_url,
                        '본문' : crawling_main_text(n_url)[0]}
            
        idx += 1

    part_df = pd.DataFrame(news_dict).T
    return part_df
            
    
for pn in part_name:
    df = news_crawling(pn)
    news_df = pd.concat([news_df,df])

folder_path = os.getcwd()
xlsx_file_name = '{0}.xlsx'.format(yesterday)
news_df.to_excel(xlsx_file_name, index=False)

print('Xlsx 저장 완료 | 경로 : {}\\{}\n'.format(folder_path, xlsx_file_name))