# TestDemo
*mvvm架構設計。
*花費2小時

##Network網絡層:
使用moya+RxSwift進行網絡請求。使用HandyJson進行數據模型轉換。
*MoyaProvider+RX: 擴展Reactive,讓moya可以.rx這樣請求
*Moya+Extension:擴展Moya框架的Response響應對象，添加數據轉模型功能
*NetworkingType: 當實現 Moya TargetType協議的類不止一個時（分模塊創建Api接口）
設計一個協議， 將MoyaProvider泛型類的類型延遲到具體類來指定類型。
*Networking:實現NetworkingType 協議的具體類
*HomeApi: moya網絡請求擴展
*Api:對外開放的api使用接口 

##Tools工具:
*包括常量配置；json轉對象快捷方法；類擴展；

##Model:
*遵循HandyJson協議
*基類BaseModel；Post對像模型；Comment對像模型；

##View:
*Post界面的cell；Comment界面的cell；

##VewModel:
*HomeViewModel: 首頁Post的viewmodel，包含了網絡請求中的刷新、獲取保存、更改數據，模型數據的轉換等一切數據操作。
*DetailViewModel: Comment頁面的viewmodel，獲取保存數據。

##Controller層:
*PostsListViewController: 擁有postViewModel；創建展示view；只做一件事：建立View與ViewModel之間的綁定依賴關係。
*DetailPostViewController: 擁有commentViewModel；創建展示view；建立View與ViewModel之間的綁定依賴關係。

#English Version
*mvvm architecture design.
* takes 2 hours

##Network network layer:
Use moya+RxSwift to make network requests. Use HandyJson for data model transformation.
*MoyaProvider+RX: Extend Reactive, so that moya can request .rx like this
*Moya+Extension: Extend the Response object of the Moya framework and add the function of data to model
*NetworkingType: When there is more than one class that implements the Moya TargetType protocol (create Api interface by module)
Design a protocol that defers the type of the MoyaProvider generic class to a concrete class to specify the type.
*Networking: A concrete class that implements the NetworkingType protocol
*HomeApi: moya network request extension
*Api: API usage interface open to the outside world

##Toolstools:
*Including constant configuration; json to object shortcut method; class extension;

##Model:
* Follow the HandyJson protocol
*Base class BaseModel; Post object model; Comment object model;

##View:
*cell of Post interface; cell of Comment interface;

##VewModel:
*HomeViewModel: The viewmodel of the Home Post, which includes all data operations such as refreshing, obtaining and saving, changing data, and converting model data in network requests.
*DetailViewModel: The viewmodel of the Comment page to get the saved data.

##Controller layer:
*PostsListViewController: owns the postViewModel; creates a presentation view; does only one thing: establishes a binding dependency between the View and the ViewModel.
*DetailPostViewController: owns commentViewModel; creates display view; establishes binding dependencies between View and ViewModel.
