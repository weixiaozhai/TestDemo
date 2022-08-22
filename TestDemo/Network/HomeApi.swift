//
//  HomeApi.swift
//  TestDemo
//
//  Created by 潘佳炜 on 2022/8/21.
//

import Foundation
import Moya
import Toast_Swift


enum HomeApi {
    case posts
    case comments(postID: Int)
    
    
}


extension HomeApi : TargetType {
    var baseURL: URL {
        return try! Configs.Network.jsonBaseUrl.asURL()
    }
    
    var path: String {
        switch self {
        case .posts: return Configs.Network.postsPath
        case .comments(postID: let postid):
            return Configs.Network.postsPath + String(format: "/%i/", arguments: [postid]) + Configs.Network.commentsPath
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    
    var parameters:[String:Any]? {
        let params:[String:Any] = [:]
        switch self {
        case .posts, .comments(postID: _): break;
        }
        return params
    }
    
    var task: Task {
        if let parameters = parameters {
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
        return .requestPlain
        
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}

class HomeApiPlugin: PluginType {
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var mRequest = request
        mRequest.timeoutInterval = 10
        return mRequest
    }
    
    //开始请求
    func willSend(_ request: Moya.RequestType, target: TargetType) {
        DispatchQueue.main.async {
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.makeToastActivity(.center)
        }
    }
    
    //结束请求
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        DispatchQueue.main.async {
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.hideToastActivity()
            
        }
        
        
    }
    
    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        
        // 在这里对请求进行统一处理（比如有加密，可以统一进行解密）
        switch result {
        case .success(let response):
            if response.statusCode == 200 {
//                if let jsonStr = String(data: response.data, encoding: .utf8) {
//                    debugPrint("Moya 请求结果：" + jsonStr)
//                }
            }else{
                debugPrint("statusCode not 200")
            }
        case .failure( _):
            debugPrint("貌似网络有问题，稍后再试")
            
        }
        
        return result
    }
}

