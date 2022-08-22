//
//  NetworkingType.swift
//  TestDemo
//
//  Created by 潘佳炜 on 2022/8/21.
//

import Moya
import RxSwift
import HandyJSON

protocol NetworkingType {
    associatedtype T: TargetType
    
    var provider:MoyaProvider<T> { get }
    
    static func defaultNetworking() -> Self
}


/*!
 有关请求扩展
 */
extension NetworkingType {
    
    // 将请求结果直接转成模型
    func requestModel<H,K: HandyJSON>(_ token: T, _ model:H.Type, _ childType: K.Type) -> Observable<H> {
        return self.provider.rx.request(token)
            .asObservable()
            .mapModel(H.self,K.self)
    }
    
}
