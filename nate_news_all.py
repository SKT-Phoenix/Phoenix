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
from pandas import DataFrame
import time
from selenium.webdriver.common.by import By

sleep_sec = 0.5

# User-Agent를 입력해주세요.
headers = {'User-Agent' : '________________'}

# # 날짜 지정
# yesterday = (datetime.today() - timedelta(1)).strftime("%Y%m%d")

part_num = ['201', '301', '401', '501', '601'] #  정치, 경제, 사회, 세계, IT/과학
part_name = ['pol', 'eco', 'soc', 'int', 'its'] #  정치, 경제, 사회, 세계, IT/과학
# news_df=pd.DataFrame()
# all_df = pd.DataFrame()

def crawling_main_text(url):

    req = requests.get(url,headers = headers)
    req.encoding = None
    soup = BeautifulSoup(req.text, 'html.parser')

    text = soup.find('div', {'id' : 'realArtcContents'}).text
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
    tlt = str()

    page = 1
    news_num = 100000
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
        
        for n in a_list[:min(len(a_list), news_num-idx+1)]:
            

            n_url = n.get_attribute('href')
            print(f"{idx}번째 기사 = 분야: {part_num} / url: {n_url} / 타이틀: {crawling_main_text(n_url)[2]}")
            news_dict[idx] = {'분야': part_num,
                            '타이틀' : crawling_main_text(n_url)[2],
                            '발행일자' : crawling_main_text(n_url)[1],
                            '링크' : n_url,
                            '본문' : crawling_main_text(n_url)[0]}
            
            idx += 1
            
        page += 1

        if len(a_list) == 0: #  or idx >= 2001
            print(news_dict)
            print('\n브라우저를 종료합니다.\n' + '=' * 100)
            time.sleep(0.7)
            browser.close()

            part_df = DataFrame(news_dict).T
            # print(news_dict)
            print("--------------------")
            print(part_df)

            break
    
    # part_df = DataFrame(news_dict).T

    return part_df
    

# 날짜 지정


for yes in range(1, 3):
    yesterday = (datetime.today() - timedelta(yes)).strftime("%Y%m%d")
    print("\n" + "-"*10 + str(yesterday) + "크롤링" + "-"*10)

    news_df=pd.DataFrame()
    all_df = pd.DataFrame()

    for index, pn in enumerate(part_num):
        df = news_crawling(pn, yesterday)
        news_df = pd.concat([news_df,df])

        news_df['분야'].replace(pn, part_name[index], inplace=True)

        folder_path = os.getcwd()
        xlsx_file_name = '{0}_all_{1}.xlsx'.format(yesterday, part_num)
        news_df.to_excel(xlsx_file_name, index=False, encoding='utf-8')

    print(news_df.head())
    print('엑셀 저장 완료 | 경로 : {}\\{}\n'.format(folder_path, xlsx_file_name))
    



# news_df['분야'].replace('201', '정치', inplace=True)
# news_df['분야'].replace('301', '경제', inplace=True)
# news_df['분야'].replace('501', '세계', inplace=True)
# news_df['분야'].replace('601', 'IT/과학', inplace=True)

# news_df.to_excel(xlsx_file_name, index=False)


print("\n" + '='*30 + "\n")
