//
//  DetailViewModel.swift
//  TestDemo
//
//  Created by 潘佳炜 on 2022/8/21.
//

import Foundation
import UIKit
import RxSwift
import Moya

class DetailViewModel{
    let disposeBag = DisposeBag()
    var commentsArr = [Comment]()
    var observable: Observable<[Comment]>?
    var postID = 0
    
    var getComments: Observable<[Comment]> {
        
        return Api.default.getComments(postID: postID)
        
    }
    
    init(postID: Int) {
        self.postID = postID
        self.observable = getComments
    }
}
