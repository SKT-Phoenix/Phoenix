# Stack
- **Cloud Service:** Azure
    - **Server**:
        - Framework: Flask
        - Language: Python
    - **Crowling**: Python
    - **Database**: MySQL? 뭐쓸까요 아니면 Azure에서 제공하는 DB써도 되고
    
- **Client**:
    - **Chrome Extension**:
        - Framework: Jquary
        - Language: JavaScript
    - **Application**:
        - Framework: Flutter
        - Language: Dart
- **Summary Model**:
    - **SKT KoBART**:
        - Framework: Pytorch
        - Language: Python
- **Q&A Model**:
    - ?

## Nate 뉴스 크롤링
[들어가기](https://github.com/SKT-Phoenix/News_Crowling)

- 각 분야별 랭킹 1~3위.
- 제목, 내용, 출처, 원문링크



## Flask & Azure
[들어가기](https://github.com/SKT-Phoenix/Flask_Server)

+ Cloud Service: Azure
+ Server: Flask

* Web page 만들지말고 API 형식으로 만들기

- Get
  1. 크롤링 데이터 전부
  2. 회원정보, 점수
  
- Post
  1. 크롤링해서 요약된 데이터 보내기
  2. Q&A 데이터
  3. Chrome 확장 프로그램과 통신
  
- DB: 회원정보, 총 점수(펫 성장에 필요), 이달의 점수(랭킹에 필요)



## Kobart 문장 요약모델
[들어가기](https://github.com/SKT-Phoenix/Summary_Model)

-

## Q&A 생성모델
[들어가기](https://github.com/SKT-Phoenix/QnA_Model)

-

## Chrome 확장 프로그램
[들어가기](https://github.com/SKT-Phoenix/Chrome_Client)

-

## 어플리케이션
[들어가기](https://github.com/SKT-Phoenix/App_Client)

1. 회원가입/로그인
    - 계정 정보 : 찬님이 구현한 적 있던 구글 계정 로그인 구현, T 로그인은 되면 좋지만 어려울 수 있음

2. 사용자의 점수
- 총 점수
    - 에이닷의 펫 불사조
    + 불사조인 이유는 우리 팀이라서도 있지만, SK의 상징색, 그리고 ‘날다’라는 Fly AI의 Fly와도 의미가 통하기 때문

- 이달의 점수
    - 랭킹시스템(매달 초기화)
    + 1~3등은 ‘이달의 시사왕’ 같은 걸로 한정판 펫 / 에이닷 캐릭터 의상 제공

3. Kobart 문장 요약모델에서 가져온 데이터로 UI/UX 적용해서 보기 편하게 하기

4. Q&A 생성모델에서 가져온 데이터로 실제 질문지처럼 만들어주고, 결과 점수를 DB에 보냄

5. 랭킹 보드 띄우기(실시간 랭킹)
    - 구글 아이디 계정 써서 점수 DB 만들 계획. 앱 내부가 아닌 Azure/Flask 부분 이용.
