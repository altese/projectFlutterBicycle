# Bicycle 따릉이 대여량 예측 앱

<br>

<img src="https://cdn.icon-icons.com/icons2/1066/PNG/512/Books_icon-icons.com_76879.png" width="30" height="15" style="max-width: 100%;">
<a href="" rel="nofollow">포트폴리오 PDF</a>

<img src="https://user-images.githubusercontent.com/113036608/213998064-91428e50-80ec-4e94-b89c-dd6f9217d162.png" width="30" height="15" style="max-width: 100%;">
<a href="" rel="nofollow">YouTube 영상</a>

<br>

## 목차
- 프로젝트 설명
- 개발 환경
- 사용 API
- 기능 정리
---
<br>

<h1>프로젝트 설명</h1>
BICYCLE은 강남구 4곳의 따릉이 대여소의 1일 대여량을 예측하고 현재 거치된 따릉이의 수량을 알려줌으로써 업체로 하여금 따릉이를 재배치할 때 도움을 줄 수 있게 개발된 앱이다.


<h1>개발 환경</h1>
<br>

## 개발 Tool (분석)
### IDE
- RStudio

### 언어
- R

## 개발 Tool (앱)

### IDE
- Visual Studio Code
### 언어
- Dart 2.18.6
- Flutter 3.3.10
### 서버
- Apach tomcat 9.0
### 데이터베이스
- MySql 8.0.31
- Firebase

<br>

## 협업 Tool
<table>
 <thead>
    <tr>
        <th>Notion</th>
        <th>Figma</th>
        <th>Miro</th>
    </tr>
 </thead>
 <tbody>
    <tr>
        <td>GitHub</td>
        <td>Discord</td>
        <td>GoogleDocs</td>
    </tr>
 </tbody>
</table>

<br>
<h1>사용 API </h1>
<br>

- 구글 지도 API
- 실시간 날씨 API
- <a href="https://data.seoul.go.kr/dataList/OA-15493/A/1/datase   tView.do" rel="nofollow">실시간 대여소별 거치수량 API</a>
- <a href="https://data.seoul.go.kr/dataList/OA-14994/F/1 /datasetView.do" rel="nofollow">일별 대여량 API</a>

<br>
<h1>개발 기능 </h1>
<br>

- 로그인, 회원가입
  - ID 존재여부 확인
  - ID, PW 일치여부 확인

<br>

- 마이페이지
  - 회원 정보 수정
  - 회원 탈퇴

<br>

- 구글 맵
  - 대여소 마커 찍기
  - 대여소별 예측량 구하기

<br>

- Home
  - 현재 날씨 API
  - 캘린더

<br>

- 차트 페이지
  - 대여소별 월별 대여량 확인

