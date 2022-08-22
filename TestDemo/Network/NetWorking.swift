//
//  NetWorking.swift
//  TestDemo
//
//  Created by 潘佳炜 on 2022/8/21.
//

import Foundation
import Moya


struct HomeNetworking : NetworkingType {
    
    typealias T = HomeApi
    
    let provider: MoyaProvider<T>
    
    static func defaultNetworking() -> HomeNetworking {
        return HomeNetworking(provider: MoyaProvider<T>(plugins: [HomeApiPlugin()]))
    }
    
    
}
