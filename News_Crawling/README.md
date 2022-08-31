# News_Crawling
Nate 뉴스 크롤링

## 조건
``` json
{
"Title": "뉴스제목",
"data": "뉴스내용",
"source": "출처(작성자 및 회사)",
"link": "원문 링크"
}
```


### 메모

- [크롤링 참고1](https://everyday-tech.tistory.com/1)
- [크롤링 참고2](https://velog.io/@ssokeem/naver-news-crawling)
- [본문 내용 가져오기(위의 참고1과 동일한 시리즈)](https://everyday-tech.tistory.com/entry/3%ED%83%84-%EC%89%BD%EA%B2%8C-%EB%94%B0%EB%9D%BC%ED%95%98%EB%8A%94-%EB%84%A4%EC%9D%B4%EB%B2%84-%EB%89%B4%EC%8A%A4-%ED%81%AC%EB%A1%A4%EB%A7%81-%EB%B3%B8%EB%AC%B8-%EA%B0%80%EC%A0%B8%EC%98%A4%EA%B8%B0?category=922285)

- 참고 내용들은 모두 네이버 기준이므로 네이트 뉴스 페이지로 변경해서 사용할 예정


#### 진경님 네이버 크롤링 참고2 사이트 시현 결과

![navercrowling](https://github.com/ParkWonYeong/IMGupload/blob/main/excelfile.png?raw=true)


#### 페이지 소스 구성

![페이지소스구성](https://github.com/ParkWonYeong/IMGupload/blob/main/%EB%84%A4%EC%9D%B4%ED%8A%B8%ED%8C%90%EB%89%B4%EC%8A%A4%EA%B5%AC%EC%84%B1.png?raw=true)

- 종류별 배너 구분

1) 뉴스메뉴(랭킹뉴스 선택)

![뉴스메뉴](https://github.com/ParkWonYeong/IMGupload/blob/main/%EB%89%B4%EC%8A%A4%EB%A9%94%EB%89%B4(%EB%9E%AD%ED%82%B9%EB%89%B4%EC%8A%A4%EC%84%A0%ED%83%9D).png?raw=true)


2) 뉴스분야(랭킹 뉴스 중 분야 선택 - 이미지는 스포츠 선택하고있는 이미지임)

![뉴스분야](https://github.com/ParkWonYeong/IMGupload/blob/main/%EB%9E%AD%ED%82%B9%20%EB%89%B4%EC%8A%A4%20%EC%A4%91%20%EB%B6%84%EC%95%BC%20%EC%84%A0%ED%83%9D(%ED%98%84%EC%9E%AC%20%EC%8A%A4%ED%8F%AC%EC%B8%A0%EB%A5%BC%20%EC%84%A0%ED%83%9D).png?raw=true)

3) 랭킹 1~3

![랭킹](https://github.com/ParkWonYeong/IMGupload/blob/main/%EB%9E%AD%ED%82%B9.png?raw=true)


4) 링크 들어가서 본문

![본문](https://github.com/ParkWonYeong/IMGupload/blob/main/%EB%B3%B8%EB%AC%B8.png?raw=true)
