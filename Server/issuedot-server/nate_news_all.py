
from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from webdriver_manager.chrome import ChromeDriverManager
from datetime import datetime, timedelta
from pandas import DataFrame
import os
import time
import pandas as pd
import requests



start = time.time()

sleep_sec = 0.5

# User-Agent를 입력해주세요.
headers = {'User-Agent' : 'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36'}

# # 날짜 지정
# yesterday = (datetime.today() - timedelta(1)).strftime("%Y%m%d")

part_num = ['201', '301', '401', '501', '601'] #  정치, 경제, 사회, 세계, IT/과학
part_name = ['정치', '경제', '사회', '세계', 'IT/과학']
# news_df=pd.DataFrame()
# all_df = pd.DataFrame()

def title_pre(title):
    temp = ""
    key = False
    
    for text in title:
        if text == '[' or text == ']':
            key = True if key==False else False
            continue
        
        if key == False:
            temp += str(text)
    
    return temp

def crawling_dic(str_dic):

    service = Service(executable_path=ChromeDriverManager().install())
    browser = webdriver.Chrome(service=service)

    news_url = 'https://dic.daum.net/search.do?q={0}&dic=kor'.format(str_dic)

    browser.get(news_url)
    time.sleep(sleep_sec)
    
    try:
        table = browser.find_element(By.XPATH,'//div[@class="cleanword_type kokk_type"]')
        dic = table.find_element(By.XPATH,'.//span[@class="txt_search"]').text
        
    except:
        try:
            table = browser.find_element(By.XPATH,'//ul[@class="list_mean"]')
            dic = table.find_element(By.XPATH,'.//span[@class="txt_mean"]').text
        except:
            table = browser.find_element(By.XPATH,'//ul[@class="list_search"]')
            dic = table.find_element(By.XPATH,'.//span[@class="txt_search"]').text
    
    return dic

def crawling_main_text(url):

    req = requests.get(url,headers = headers)
    req.encoding = None
    soup = BeautifulSoup(req.text, 'html.parser')

    text = soup.find('div', {'id' : 'realArtcContents'})
    # a태그제거
    a_tag = text.find_all('a')
    for i in range(len(a_tag)):
        text.find('a').decompose()
    text= text.text
    
    date = soup.find('em').text
    title = soup.find('h3', {'class' : 'articleSubecjt'}).text
    date = date[0:10]

        
    return (text.replace('\n','').replace('\r','').replace('<br>','').replace('\t',''), date,title)


def news_crawling(part_num, yesterday):
    
    service = Service(executable_path=ChromeDriverManager().install())

    options = webdriver.ChromeOptions()
    options.add_experimental_option("excludeSwitches", ["enable-logging"])
    browser = webdriver.Chrome(options=options, service=service)


    print('검색할 분야 : {}'.format(part_num))

    print('브라우저를 실행시킵니다(자동 제어)\n')

    ################# 뉴스 크롤링 #################

    print('\n크롤링을 시작합니다.')

    #####동적 제어로 페이지 넘어가며 크롤링
    # tlt = str()

    page = 1
    news_dict = {}
    idx = 1
        


    while True:
     
        news_url = 'https://news.nate.com/recent?mid=n0{0}&type=c&date={1}&page={2}'.format(part_num,yesterday,page)
        
        
        browser.get(news_url)
        time.sleep(sleep_sec)

        

        table = browser.find_element(By.XPATH,'//div[@id="newsContents"]')
        li_list = table.find_elements(By.XPATH,'.//div[@class="mduSubjectList"]')
        a_list = [li.find_element(By.XPATH,'.//a[@class="lt1"]') for li in li_list]


        print(f"{page} 페이지" + "-"*10)
        
        for n in a_list:
            

            n_url = n.get_attribute('href')
            texts = crawling_main_text(n_url)[0]
            title = crawling_main_text(n_url)[2]
            title = title_pre(title)
            
            print(f"{idx}번째 기사 = 분야: {part_num} / url: {n_url} / 타이틀: {crawling_main_text(n_url)[2]}")
            news_dict[idx] = {'발행일자' : crawling_main_text(n_url)[1],
                            '분야': part_num,
                            '타이틀' : title.strip(),
                            '링크' : n_url,
                            '본문' : texts.strip()}
            
            idx += 1
            
        page += 1

        if len(a_list) == 0: #  
            print(news_dict)
            print('\n브라우저를 종료합니다.\n' + '=' * 100)
            time.sleep(0.7)
            browser.close()

            part_df = DataFrame(news_dict).T
            
            print("--------------------")
            print(part_df)

            break
    
    # part_df = DataFrame(news_dict).T

    return part_df
    

# 날짜 지정

yesterday = (datetime.today() - timedelta(1)).strftime("%Y%m%d")
print("\n" + "-"*10 + str(yesterday) + "크롤링" + "-"*10)

news_df=pd.DataFrame()
all_df = pd.DataFrame()

for index, pn in enumerate(part_num):
    df = news_crawling(pn, yesterday)
    news_df = pd.concat([news_df,df])

    news_df['분야'].replace(pn, part_name[index], inplace=True)
    
folder_path = os.getcwd()
xlsx_file_name = 'static/crawling/{0}_all.xlsx'.format(yesterday)
news_df.to_excel(xlsx_file_name, index=False, encoding='utf-8')

print(news_df.head())
print('엑셀 저장 완료 | 경로 : {}\\{}\n'.format(folder_path, xlsx_file_name))
now = time.time()

crawl_time = now - start

hour = crawl_time//3600
crawl_time = 13567 % 3600
minute = crawl_time // 60
crawl_time = crawl_time % 60
sec = crawl_time

print(f"걸린시간 : {hour}시간 {minute}분 {sec}초")

print("\n "+"=" * 50)
print("∥               [INFO] crwaling 완료             ∥") 
print(" "+"=" * 50)
