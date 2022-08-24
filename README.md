# QnA_Model
Q&amp;A 생성 모델

- [Q&A생성 모델 학습용 데이터](https://github.com/seopbo/nlp_classification/tree/master/BERT_pairwise_text_classification/qpair)


- [Question Generation Model with KorQuAD](https://github.com/codertimo/KorQuAD-Question-Generation.git)

- [KorQUAD 2.0](https://korquad.github.io/)


----

### 22/08/23
* KorQUAD 2.0
    * 01_KorQUAD2.0.ipynb
* Multilingual BERT

### 22/08/24
* KorQUAD 2.0은 1.0과 달라서 1.0을 이용한 모델은 적용시키는 것에 한계 있음
* Multilingual BERT + KorQUAD 1.0 학습 => 질문에 대한 답 생성
    * 02_케라스로_KorQuAD(한국어 Q&A) 구현하기.ipynb
    * 03_question_generation.ipynb
* 중요한 뉴스가 무엇일지 고민
    * [참고-누구/T전화의 이슈](https://devocean.sk.com/search/techBoardDetail.do?ID=164033&query=뉴스&searchData=Tech+Gallery&page=&subIndex=&idList=[164128%2C+164033%2C+163981%2C+163969%2C+163802%2C+163719%2C+163699%2C+163698%2C+163674%2C+163583%2C+163534%2C+163511%2C+163470%2C+163405%2C+163401%2C+163324%2C+163319%2C+163292%2C+163288%2C+163226%2C+163212%2C+163205%2C+163188])
    * 어제 하루동안의 전체 뉴스 제목 수집
        > 제목은 뉴스의 하이라이트 키워드가 포함되어 있음
    * 모든 제목에서 KeyBERT로 중요 키워드 추출
    * 중요 키워드에 대한 뉴스 중 [종합]뉴스 선택
        > 종합뉴스는 해당 내용에 대한 보강이 완료된 기사
    * 선택된 뉴스 요약 제공
* try!
    * T전와/누구에 기능은 구현되어있음
* 뉴스에서 어려운 단어를 해석해주는 or 사전정의 알려주는 기능에 대한 고민
    * 어려운 단어에 하이퍼링크
        > MZ세대가 읽기에 어려운 단어가 무엇인가
    * 예를 들어 경제 분야면, 경제 사전에 단어가 있으면 사전정의 알려주기

