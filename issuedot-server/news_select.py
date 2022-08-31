import pandas as pd
import numpy as np

import konlpy
from tqdm import tqdm
from konlpy.tag import Okt

from sklearn.feature_extraction.text import TfidfVectorizer

from sklearn.cluster import DBSCAN
import os

os.environ['JAVA_HOME'] = r'C:\Program Files\Java\jdk-18.0.2.1\bin\server'


def preprocessing_clustering(df, part):

  if part == 'int':
    df = df[df['분야'] == part]
    if df.shape[0] == 0:
      return pd.DataFrame()
  else:
    df = df[df['분야'] != part]
    


  df = df.drop_duplicates(['타이틀'], keep = 'first')
  # df.shape

  df['text50'] = np.nan
  df['text15'] = np.nan

  for index, row in df.iterrows():
    if len(str(df['본문'][index])) >= 50:
      df['text50'][index] = str(df['본문'][index])[:50]
    else:
      df['text50'][index] = str(df['본문'][index])

    if len(str(df['본문'][index])) >= 15:
      df['text15'][index] = str(df['본문'][index])[:15]
    else:
      df['text15'][index] = str(df['본문'][index])

  df = df.drop_duplicates(subset = 'text15', keep = 'first')

  regions = ['뉴스핌', '연예', '서울', '경기', '강원', '충청', '경상', '전라', '인천', '경남', '경북', '대구', '울산', '부산', '광주', '전남', '제주', '전북', '대전', '세종', '충남', '충북', '충청북도', '충청남도', '경상남도', '경상북도', '전라북도', '전라남도']


  drop_index_list = [] # 지워버릴 index를 담는 리스트
  for i, row in df.iterrows():
      temp_region = row['text15']
      # temp_region = row['본문'].split(".")[0]
      for region in regions:
        if region in temp_region: 
            drop_index_list.append(i)
  df = df.drop(drop_index_list) # 해당 index를 지우기
  # doc.shape


  okt = Okt() # 형태소 분석기 객체 생성
  noun_list = []
  for content in tqdm(df['text50']): 
      nouns = okt.nouns(content) # 명사만 추출하기, 결과값은 명사 리스트
      noun_list.append(nouns)

  df['nouns'] = noun_list


  # 명사리스트 비어있는 경우 삭제

  drop_index_list = [] # 지워버릴 index를 담는 리스트
  for i, row in df.iterrows():
      temp_nouns = row['nouns']
      if len(temp_nouns) == 0: # 만약 명사리스트가 비어 있다면
          drop_index_list.append(i) # 지울 index 추가
          
  df = df.drop(drop_index_list) # 해당 index를 지우기

  # index를 지우면 순회시 index 값이 중간중간 비기 때문에 index를 다시 지정
  df.index = range(len(df))

  if part == 'int':
    min_df = 6
    min_samples = 5
  elif df.shape[0] < 10000:
    min_df = 5
    min_samples = 5
  else:
    min_df = 6
    min_samples = 5


  # 문서를 명사 집합으로 보고 문서 리스트로 치환 (tfidfVectorizer 인풋 형태를 맞추기 위해)
  text = [" ".join(noun) for noun in df['nouns']]

  tfidf_vectorizer = TfidfVectorizer(min_df = 3, ngram_range=(1,3))
  tfidf_vectorizer.fit(text)
  vector = tfidf_vectorizer.transform(text).toarray()


  vector = np.array(vector) # Normalizer를 이용해 변환된 벡터
  model = DBSCAN(eps=0.7,min_samples=4, metric = "cosine")
  # 거리 계산 식으로는 Cosine distance를 이용
  result = model.fit_predict(vector)

  
  df['result'] = result
  if part == 'int':
    df['result'] = df['result'] + 100


  print(f"\n {df['result'].unique()} \n")

  return df

def cluster_result(df):

  cluster_idx = {}
  cluster_nums = {}
  for cluster_num in set(df['result']):
      # -1,0은 노이즈 판별이 났거나 클러스터링이 안된 경우
      if(cluster_num == -1 or cluster_num == 0 or cluster_num == 99 or cluster_num == 100): 
          continue
      else:
          print("cluster num : {}".format(cluster_num))
        
          temp_df = df[df['result'] == cluster_num] # cluster num 별로 조회
          num = len(df.index[df['result'] == cluster_num].to_list())
          for title in temp_df['타이틀']:
              print(title)
          cluster_idx[cluster_num] = df.index[df['result'] == cluster_num].to_list()
          cluster_nums[cluster_num] = num

          print("docs_num : {}".format(num))

          print()


  print(cluster_idx)

  return cluster_nums

df = pd.read_excel("static/20220830_all.xlsx") # , encoding = "CP949"

part_name = ['all', 'int'] # 

news_df = pd.DataFrame()

for part in part_name:
  df_result = preprocessing_clustering(df, part)
  news_df = pd.concat([news_df,df_result])
  
cluster_nums = cluster_result(news_df)

def top10(news_df, cluster_nums):
  result_clus = sorted(cluster_nums.items(), key = lambda x:x[1], reverse = True)[:10]
  print(result_clus)

  fin_df = pd.DataFrame()
  clus_group = []
  for clus in result_clus:
    clus_group.append(clus[0])
    print(f"{clus[0]}---------------------------------------")
    temp_df = news_df[news_df['result'] == clus[0]] # cluster num 별로 조회
    print(temp_df['본문'])

    fin_df = pd.concat([fin_df, temp_df])
  
  return fin_df, clus_group

fin_df, clus_group = top10(news_df, cluster_nums)
fin_df['result'].unique()

for idx in fin_df['본문'].index:
    if len(fin_df['본문'][idx]) < 1024:
        fin_df = fin_df.drop(idx)

import random

def final_dataset(fin_df, clus_group):

  # fin_df 인덱스 재설정
  fin_df.index = range(len(fin_df))

  # final_news = pd.DataFrame()
  idx = []
  for clus in clus_group:
    temp_idx = fin_df[fin_df['result'] == clus].index
    idx.append(temp_idx[random.randrange(0, len(temp_idx))])
    # print(temp_idx)

  # print(idx)
  final_news = fin_df.iloc[idx, :5]

  return final_news

final_news = final_dataset(fin_df, clus_group)

final_news.to_excel("static/news_0830.xlsx", encoding = "utf-8")