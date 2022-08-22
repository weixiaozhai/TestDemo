//
//  Moya+Extension.swift
//  TestDemo
//
//  Created by 潘佳炜 on 2022/8/21.
//

import Foundation
import Moya
import RxSwift
import HandyJSON

enum MyError: String, Error {
    case A = "status code not 200"
}
//扩展RxSwift的 ObservableType
extension ObservableType where Element == Response {
    
    func mapModel<T,K: HandyJSON>(_ type:T.Type, _ childType: K.Type) -> Observable<T> {
        return flatMap { (response) -> Observable<T> in
            guard response.statusCode == 200 else{
                return Single.create { single in
                    single(.error(MyError.A))
                    return Disposables.create {}
                }.asObservable()
            }
            return Observable.just(try! response.mapModel(type.self,childType.self))
        }

    }
    
}

//扩展Moya框架的Response响应对象，添加数据转模型功能
extension Response {
    
    //数据转模型 映射
    func mapModel<T,K: HandyJSON>(_ type: T.Type, _ childType: K.Type) throws -> T {
        let jsonString = String(data: self.data, encoding: .utf8) // nsdata to string
        guard let jsonString = jsonString else {
            throw MoyaError.jsonMapping(self)
        }
        return JsonUtil.jsonArrayToModel(jsonString, childType.self) as! T
    }
}

