//
//  HomeViewModel.swift
//  TestDemo
//
//  Created by 潘佳炜 on 2022/8/21.
//

import Foundation
import UIKit
import RxSwift
import Moya
import RxDataSources

class HomeViewModel{
    let disposeBag = DisposeBag()
    //原始数据
    var originalPostsArr = [SectionModel<String, Post>]()
    //排序后的数据
    var sortedPostsArr = [SectionModel<String, Post>]()
    var publishSubject: PublishSubject<[SectionModel<String, Post>]> = PublishSubject()
    var scrollSubject: PublishSubject<Bool> = PublishSubject()
    //是否展示排序数据
    var isSorted = false{
        didSet{
            if isSorted {
                let transData = self.transformData(postsArr: originalPostsArr.first?.items ?? [])
                self.publishSubject.onNext(transData)
            }else{
                self.publishSubject.onNext(self.originalPostsArr)
            }
        }
    }
    //请求获取posts
    var getPosts: Observable<[SectionModel<String, Post>]> {
        return Api.default.getPosts()
            .flatMap { posts -> Observable<[SectionModel<String, Post>]> in
                self.originalPostsArr.removeAll()
                self.originalPostsArr.append(SectionModel(model: "", items: posts))
                guard self.isSorted else{
                    return Observable.just(self.originalPostsArr)
                }
                return Observable.just(self.transformData(postsArr: posts))
            }
        
    }
    
    init() {
        getPosts
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: {[weak self] sectionModelsArr in
                self?.publishSubject.onNext(sectionModelsArr)
            })
            .disposed(by: disposeBag)
        
    }
    
    func refreshData(arr: [SectionModel<String, Post>]) {
        publishSubject.onNext(arr)
        scrollSubject.onNext(arr.count > 0 ? true : false)
    }
    
    func updateLiked(indexP: IndexPath, liked: Bool) {
        guard isSorted else {
            let model = self.originalPostsArr[indexP.section].items[indexP.row]
            model.isLiked = liked
            originalPostsArr[indexP.section].items[indexP.row] = model
            publishSubject.onNext(originalPostsArr)
            return
        }
        let model = self.sortedPostsArr[indexP.section].items[indexP.row]
        model.isLiked = liked
        sortedPostsArr[indexP.section].items[indexP.row] = model
        publishSubject.onNext(sortedPostsArr)
    }
    
    ///将posts数组转换为SectionModel，以便分组使用
    func transformData(postsArr: [Post]) -> [SectionModel<String, Post>] {
        //取出所有title的首字母，按升序排序
        let arr = postsArr.map { post in
            return (post.title ?? "a")[..<1]
        }
        var sectionTitleArr = (arr as NSArray).sortedArray(using: #selector(NSNumber.compare(_:))) as! [String]
        sectionTitleArr = sectionTitleArr.removeDuplicate()
            .map({ str in
                str.uppercased()
            })
        
        //根据title的首字母，将postsArr分组，一个首字母对应同样首字母组成的数组
        var dataDict = [String : [Post]]()
        for post in postsArr {
            var letter = (post.title ?? "a")[..<1]
            letter = letter.uppercased()
            if dataDict[letter] == nil {
                var postsArr = [Post]()
                postsArr.append(post)
                dataDict[letter] = postsArr
            }else{
                var tmpPosts = dataDict[letter]!
                tmpPosts.append(post)
                dataDict[letter] = tmpPosts
            }
        }
        
        //转成SectionModel<String, Post>数据
        var sectionModelArr = [SectionModel<String, Post>]()
        for str in sectionTitleArr {
            let sectModel = SectionModel(model: str, items: dataDict[str] ?? [])
            sectionModelArr.append(sectModel)
        }
        self.sortedPostsArr.removeAll()
        self.sortedPostsArr.append(contentsOf: sectionModelArr)
        //        print(dataDict)
        return sectionModelArr
    }
}
