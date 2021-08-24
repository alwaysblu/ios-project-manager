# Project manager

## 📌 핵심 키워드

- Word Wrapping 방식의 이해
- 테이블뷰의 Drag an Drop 구현
- 동적 콜렉션뷰 셀 높이 구현
- 콜렉션뷰에서 커스텀 스와이프를 통한 삭제 구현
- Date Picker를 통한 날짜입력
- 서버와 API 설계 협의
- URLSession을 통한 네트워크 통신
- 로컬 디스크 캐시 구현

<br>

## 📌 Commit Convention 

Type|Emoji|Description
:---|:---:|:---
Feat      |✨| 기능 (새로운 기능)
Fix       |🐛| 버그 (버그 수정)
Refactor	|♻️| 리팩토링
Style	    |💄| 스타일 (코드 형식, 세미콜론 추가: 비즈니스 로직에 변경 없음)
Docs	    |📝| 문서 (문서 추가, 수정, 삭제)
Test	    |✅| 테스트 (테스트 코드 추가, 수정, 삭제: 비즈니스 로직에 변경 없음)
Chore	    |🔧| 기타 변경사항 (빌드 스크립트 수정 등)
Comment	  |💡| 필요한 주석 추가 및 변경
Rename    |🚚| 파일 혹은 폴더명을 수정하거나 옮기는 작업만인 경우
Remove    |🔥| 파일을 삭제하는 작업만 수행한 경우


```
ex) 

✨ [Feat] : Vapor App 베포함
```

<br>

## 📌 Pull Request

* [step 1](https://github.com/yagom-academy/ios-project-manager/pull/20)
* [step 2](https://github.com/yagom-academy/ios-project-manager/pull/26)

<br>

## 📌 트러블슈팅

- MVVM 아키텍처에서 Binding 된 값이 변하는 것에 대응해서 다양한 행위를 어떻게 구현할지 고민하였습니다.

```
-> 프로퍼티 옵져버의 oldValue를 이용하여 변한 값과 변하기 이전 값을 ViewController에 알려주도록하여

ViewModel이 특정 ViewController의 로직을 갖고 있지 않게 하여 ViewModel의 재사용성을 높였습니다.
```

<br>

- 명세에 주어진 레이아웃을 구현하기위해서는 collectionView를 사용해야했습니다.

WWDC에서 CollectionView에서의 swipe기능이 가능하다고 나와있었지만 Beta 버전에서만 지원하다가 swipe 기능을 지원하지 않았습니다.

그래서 명세에 주어진 레이아웃과 swipe 기능을 구현하기 위해서는 어떻게 해야할지 고민하였습니다.

```
레이아웃을 구현하기위해서는 테이블 뷰의 section을 이용하는 방법과

콜렉션 뷰를 이용하는 방법이 있었고

콜렉션 뷰에서 스와이프를 구현하기 위해서는 커스텀해야했습니다.


테이블 뷰의 section을 이용한 방법은 추후에 section이 필요한 경우에 수정에 문제가 생길 수 있을거라고 생각하였습니다.

WWDC에서 콜레션뷰에 스와이프 기능을 제공한다고 하였기 때문에 조만간

스와이프 기능이 콜렉션뷰의 모든 레이아웃에 적용될 것 같다고 생각하여

커스텀으로 스와이프를 구현한 후에 콜렉션 뷰에 스와이프 기능이 나오면 수정하는 방향으로 결정하였습니다.
```


<br>

## 📌 구조

<img width="1171" alt="스크린샷 2021-08-24 오전 7 44 19" src="https://user-images.githubusercontent.com/75533266/130529163-3d94651b-2b98-45e3-8613-2fa5d1ae43f5.png">

<br>

## 📌 구현사항

Add

![Simulator Screen Recording - iPad Pro (12 9-inch) (5th generation) - 2021-08-02 at 00 57 07-20210802011207167](https://user-images.githubusercontent.com/75533266/130536078-4dfa4d7a-7435-4862-b28e-acbda76212a9.gif)

Delete



https://user-images.githubusercontent.com/75533266/130537152-e33a775c-9f04-4a46-b4ea-539e0c4cb0e4.mov

