//
//  APIInterface.swift
//  TestDemo
//
//  Created by 潘佳炜 on 2022/8/21.
//  对外开放的api使用接口，

import Foundation
import RxSwift


protocol ApiService {
    func getPosts() -> Observable<[Post]>
    func getComments(postID: Int) -> Observable<[Comment]>

}

class Api: ApiService {
    
    let homeProvider:HomeNetworking
    
    static let `default` = Api()
    
    init() {
        homeProvider = HomeNetworking.defaultNetworking()
    }
    
}



extension Api {
    
    func getPosts() -> Observable<[Post]> {
        self.homeProvider.requestModel(.posts, [Post].self,Post.self)
    }
    
    func getComments(postID: Int) -> Observable<[Comment]> {
        self.homeProvider.requestModel(.comments(postID: postID), [Comment].self,Comment.self)
    }
}
