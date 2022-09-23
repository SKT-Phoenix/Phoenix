# 이슈닷(feat.에이닷)
- 긴 글과 뉴스를 잘 읽지 않는 MZ세대들을 위한 인공지능 뉴스 요약 및 퀴즈 생성 서비스
![image](https://user-images.githubusercontent.com/83276163/192003783-ea53b407-0eab-4c6f-8f90-82307595f927.png)


## 개발 기간
- 2022-08-22 ~ 2022-09-02

# Example

https://user-images.githubusercontent.com/83276163/189039905-79d90a03-d6cd-455c-8e03-efd282f9ec63.MP4

# Stack
- **Front-End**
    - **Application**:
        - Framework: `Flutter`
        - Language: `Dart`
    - **Chrome Extension**:
        - Framework: `Jquary`
        - Language: `HTML`, `CSS`, `JavaScript`
- **Back-End**
    - **Cloud Service:** Azure
        - **http Protocol Server(Application)**:
            - Framework: `Flask`
            - Language: `Python`
        - **https Protocol Server(ChromeExtension)**:
            - Framework: `Django`
            - Language: `Python`
        - **Crowling**:
            - Language: `Python`
            - Module: `BeautifulSoup, Selenium`
        - **Database**: `MySQL`
- **Model**
    - **News Summary Model**:
        - Framework: `Pytorch`
        - Language: `Python`
        - Model: `KoBART`
        - Datasets: `Dacon 한국어문서생성요약 AI 경진대회`
    - **Quiz Create Model**:
        - Framework: `Pytorch`
        - Language: `Python`
        - Model: `T5`
        - Datasets: `KorQuAD`
    - **News Selection:**
        - Clustering: `DBSCAN`
        - Language: `Python`
