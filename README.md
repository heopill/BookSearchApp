# 📚 BookSearchApp

책을 검색하고, 상세정보를 확인하고, 관심 있는 책을 담아 저장할 수 있는 iOS 앱입니다. <br>
Kakao REST API와 CoreData를 활용해 사용자 경험을 높이는 기능들을 구현했습니다.

<br>

## 📆 개발 기간
2025년 5월 9일 ~ 5월 19일

<br>

## 📸 스크린샷
<table>
  <tr>
    <td align="center">책 검색 화면</td>
    <td align="center">책 상세 화면</td>
    <td align="center">담은 책 목록</td>
  </tr>
  <tr>
    <td align="center"><img width="300" src="https://github.com/user-attachments/assets/22c4c2e0-2da7-47f3-9a22-0f104015052a" /></td>
    <td align="center"><img width="300" src="https://github.com/user-attachments/assets/a59cfb18-8f96-443b-bf5b-ed4c2bd0bb0c" /></td>
    <td align="center"><img width="300" src="https://github.com/user-attachments/assets/b350fb39-24f3-4d40-a244-713aafc47469" /></td>
  </tr>
  
  
</table>


<br>

## 💡 주요 기능

### 1. UIKit 화면 구성 및 화면 전환
- `UISearchBar`, `UITextField`, `UICollectionView`, `UITableView`를 활용한 직관적인 UI 구성
- 책 검색 화면 → 책 상세 화면으로의 자연스러운 화면 전환

### 2. REST API 활용
- [Kakao 책 검색 API](https://developers.kakao.com/docs/latest/ko/daum-search/dev-guide#search-book)를 활용하여 실시간 책 검색 기능 구현
- Kakao iOS SDK가 아닌 REST API 방식 사용

### 3. CoreData 저장 기능
- 관심 있는 책을 CoreData를 활용하여 기기 디스크에 영구 저장
- 앱 종료 후에도 저장한 책 정보 유지

<br>

## 📱 기능 상세

### 🔍 Step 2: 책 검색 화면 구현

#### 📱 화면 구성
- 사용자가 `UISearchBar`를 이용해 책 검색 가능
- 검색 결과는 `UICollectionView` 또는 `UITableView`로 출력
    - **FlowLayout** 또는 **CompositionalLayout** 사용 가능

#### 🔎 검색 기능
- 입력 완료 시 책 검색 API 호출
- 검색 결과 리스트에 책 정보(title, author 등)를 출력


### 📘 Step 3: 책 상세 보기 & 담기

- 책 상세 화면에서는 다음 정보를 자세히 표시
    - 제목(title)
    - 저자(authors)
    - 설명(contents)
    - 썸네일(thumbnail)
- `담기` 버튼 클릭 시 해당 책을 CoreData에 저장

#### 📚 담은 책 목록
- 저장된 책 리스트 출력
- 전체 삭제 및 개별 삭제 기능 지원
- 앱 종료 후에도 데이터 유지

### 🕘 Step 4: 최근 본 책 기능

- 사용자가 상세 화면을 확인한 책은 '최근 본 책'으로 등록
- 검색 결과 리스트 상단에 최근 본 책 섹션 표시
    - 최대 10권까지, 가장 최근 본 책이 최상단
    - 섹션은 최근 본 책이 있을 때만 표시
    - (선택) 가로 스크롤 구현 가능
    - (선택) 탭 시 상세화면으로 재이동

<br>

## 🛠 기술 스택

- **언어**: Swift
- **UI 프레임워크**: UIKit
- **API 통신**: Kakao REST API (`Alamofire`)
- **데이터 저장**: CoreData
- **아키텍처**: MVC
