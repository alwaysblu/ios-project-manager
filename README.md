# [Step 2] Project Manager 📑

안녕하세요 도미닉 `Step2` PR 보냅니다 😀

<br>

----

###구현 

#### 서버 동기화

##### Vapor

- `vapor` 서버를 이용하여 네트워크가 활성화되있을때 Task의 변경, 수정사항을 서버에 기록했습니다. 
- 기록된 내용은 앱을 껐다가 켰을때 네트워크가 연결되어 있다면 저장했던 Task를 서버로 부터 받아와 띄웠습니다. 

<br>

#### 로컬 디스크 캐시

- `CoreData`를 사용하여 Task의 변경사항, 수정사항을 네트워크와 무관하게 로컬 디스크에 저장했으며, 네트워크가 연결될 시 변경된 사항을 서버에 동기화시켰습니다.

<br>

#### 네트워크 유무 UI/UX

서버의 응답에 따라 네트워크의 유무를 판단했고, 이러한 상황에 따라 아래와 같은 표시가 되도록 했습니다.

<img src="https://raw.githubusercontent.com/Fezravien/UploadForMarkdown/forUpload/img/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202021-08-02%20%E1%84%8B%E1%85%A9%E1%84%8C%E1%85%A5%E1%86%AB%2012.51.08.png" alt="스크린샷 2021-08-02 오전 12.51.08" width="30%" /> <img src="https://raw.githubusercontent.com/Fezravien/UploadForMarkdown/forUpload/img/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202021-08-02%20%E1%84%8B%E1%85%A9%E1%84%8C%E1%85%A5%E1%86%AB%2012.52.31.png" alt="스크린샷 2021-08-02 오전 12.52.31" width="29%" />

<br>

#### 히스토리

Added, Updated, Moved, Deleted 히스토리

<img src="/Users/Fezz/Desktop/Simulator Screen Shot - iPad Pro (12.9-inch) (5th generation) - 2021-08-02 at 01.08.05.png" alt="Simulator Screen Shot - iPad Pro (12.9-inch) (5th generation) - 2021-08-02 at 01.08.05" width="70%" />

<br>

> 아래부터 Gif 파일이 안보이시면 눌러주세요 !

##### Added

<img src="https://raw.githubusercontent.com/Fezravien/UploadForMarkdown/forUpload/img/Simulator%20Screen%20Recording%20-%20iPad%20Pro%20(12.9-inch)%20(5th%20generation)%20-%202021-08-02%20at%2000.57.07-20210802011207167.gif" alt="Simulator Screen Recording - iPad Pro (12.9-inch) (5th generation) - 2021-08-02 at 00.57.07" width="70%" />

<br>

##### Updated

<img src="https://raw.githubusercontent.com/Fezravien/UploadForMarkdown/forUpload/img/Simulator%20Screen%20Recording%20-%20iPad%20Pro%20(12.9-inch)%20(5th%20generation)%20-%202021-08-02%20at%2000.57.48-20210802011251853.gif" alt="Simulator Screen Recording - iPad Pro (12.9-inch) (5th generation) - 2021-08-02 at 00.57.48" width="70%" />

<br>

##### Moved

<img src="https://raw.githubusercontent.com/Fezravien/UploadForMarkdown/forUpload/img/Simulator%20Screen%20Recording%20-%20iPad%20Pro%20(12.9-inch)%20(5th%20generation)%20-%202021-08-02%20at%2000.58.16-20210802011329316.gif" alt="Simulator Screen Recording - iPad Pro (12.9-inch) (5th generation) - 2021-08-02 at 00.58.16" width="70%" />

<br>

##### Deleted

<img src="https://raw.githubusercontent.com/Fezravien/UploadForMarkdown/forUpload/img/Simulator%20Screen%20Recording%20-%20iPad%20Pro%20(12.9-inch)%20(5th%20generation)%20-%202021-08-02%20at%2000.58.45-20210802011403800.gif" alt="Simulator Screen Recording - iPad Pro (12.9-inch) (5th generation) - 2021-08-02 at 00.58.45" width="70%" />

<br>

----

### 고민한 내용 및 조언을 얻고 싶은 부분 🗣

#### Layout warning 

- CollectionView에서 상하 스크롤할때 (`ReuseCell`) 
- CollecionView `darg and drop`

 앱을 실행하고 위와 같은 동작을 하게되면 수 많은 `layout warning`이 발생하는데  `WTF` 을 통해 확인을 해봤지만 어떻게 개선해야될지 잘모르겠습니다. 

 저희가 생각했던 문제점중 하나는 `Custom Swipe` 를 구현할때  초기에 이 값을 `false`로 주고 `NSLayoutConstraint` 을 줘 layout를 잡았고, 스와이프를 애니메이션으로 만들기 위해서 다시 `true`를 줬습니다. 왜냐하면 아래와 같이 위치를 조정해 줘야했기 때문입니다.

```swift
translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
            ...
])
```

```swift
translatesAutoresizingMaskIntoConstraints = true
...
self?.swipeView.frame = CGRect(x: 0, 
                               y: 0, 
                               width: (self?.contentView.frame.width)!, 
                               height: (self?.contentView.frame.height)!)
self?.deleteButton.frame = CGRect(x: (self?.contentView.frame.width)!-120, 
                                  y: 0, 
                                  width: 120, 
                                  height: (self?.contentView.frame.height)!)
```

아무래도 `translatesAutoresizingMaskIntoConstraints` 의 변화때문에 layout warning이 발생된다고 생각되는데, `도미닉`의 조언을 얻고 싶습니다. (애니메이션을 다른 방식으로 구현 등..)

<br>

#### popover modal 

 `modalPresentationStyle` 의 기존 modal 을 띄우는 방식과 `popover` 는 다른것 같아서 질문드려요!

```swift
    private let taskHistoryCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, 
                                              collectionViewLayout: UICollectionViewLayout())
        ...
        return collectionView
    }()

	 self.view.addSubview(taskHistoryCollectionView)
     NSLayoutConstraint.activate([
         self.taskHistoryCollectionView.leadingAnchor.constraint(
             	equalTo: self.view.leadingAnchor, 
				constant: Style.taskHistoryMargin.left),
            ...
        ])
```

 기존에 모달을 띄울 뷰 컨트롤러를 생각해보면 위와 같이 새로운 CollectionView를 만들고, `addSubview` 를 통해 붙이고, 레이아웃을 주는 형식으로 했었습니다. 하지만 `popover` 는 이렇게 하면 검은 화면만 띄워주고 동작하지 않았습니다. 이 부분은 아래와 같은 코드를 통해 UICollectionViewLayout을 지정해줘서 해결을 했습니다. 왜 `popover`는 이렇게 해야되는지 궁금합니다. 🤔

```swift
let layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
taskHistoryCollectionView.collectionViewLayout = listLayout
```

<br>

#### 로컬 디스크와 서버 동기화

현재 저희가 제한은 두고 있는 앱의 범위는 `단일 디바이스`, `단일 사용자`로 두고 있습니다.

**상황**

>  디바이스 A, B가 있다고 가정해보면 A에서 업데이트를 네트워크가 연결이 안되서 못했고, B는 현재(*A의 최신 자료가 업데이트 되지 않은 버전*) 서버에서 받아서 새로운 내용을 작성 및 수정하고 서버에 업데이트를 하게 된다면 A는 현재 로컬 디스크 버전에서 서버로 부터 새로운 데이터를 받게 되는 상황이 있다고 생각했습니다. 이러한 경우는 마치 `GIt 충돌`처럼 A의 데이터는 로컬과 서버가 달라지는 상황이 존재하게 됩니다.

`Real-Time` 은 API기 때문에 안 된다고 생각했지만, 위와 같은 다중 디바이스 또는 다중 사용자가 있을때 네트워크 유무에 따른 문제점을 어떻게 해결할 수 있을지 궁금합니다. 🤔

<br>

#### 아키텍처 

저희는 `MVVM` 아키텍처를 가지고 있습니다.

데이터들은 `ViewModel`에서 관리하고 있고, ViewModel과 View간의 Data Binding을 통해 Model data의 변화에 따라 View가 업데이트가 되도록 했습니다. 이 부분에서 업데이트 되는 부분은 Task Header 부분의 몇개의 Cell이 존재하는지 부분만 인데, Cell에 올라가는 data들 또한 Binding 되어야 되는지 궁금합니다. 

그리고 `도미닉`이 생각하시기에 저희가 구현하고 있는 앱에 전체적인 흐름이 어색하지 않는지, 기능에 위치 및 분담은 괜찮은지도 궁금합니다. 🤔 
