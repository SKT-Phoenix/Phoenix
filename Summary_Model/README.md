# Summary_Model

[KoBERT](https://sktelecom.github.io/project/kobert/) 문장 요약 모델

[DataFrame 형태로 시사 사전 뜻 매칭](https://github.com/SKT-Phoenix/Summary_Model/blob/master/news_dictionary.ipynb) 코드
1) 시사 용어 사전 가져오기
2) input(string) 값 받아서 사전에 들어가있는 단어 찾기
3) 파일에 포함된 의미는 너무 길기 때문에, 단어 자체만 파일에서 뽑고 그 의미는 짧고 간략하게 나타나는 Daum 사전 검색 크롤링 결과 이용.
4) 단어-의미 DataFrame 만들기
