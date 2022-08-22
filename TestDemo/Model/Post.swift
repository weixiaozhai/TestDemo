//
//  Post.swift
//  TestDemo
//
//  Created by 潘佳炜 on 2022/8/21.
//

import Foundation

class Post: BaseModel {        
    var userId: Int?
    var id: Int?
    var title: String?
    var body: String?
    var isLiked: Bool = false
}
