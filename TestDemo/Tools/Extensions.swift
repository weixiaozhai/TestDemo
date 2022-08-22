//
//  Extensions.swift
//  TestDemo
//
//  Created by 潘佳炜 on 2022/8/21.
//

import Foundation
import RxSwift

extension Reactive where Base: UITableViewCell {
    // 提供给外界重用序列
    public var prepareForReuse: RxSwift.Observable<Void> {
        var prepareForReuseKey: Int8 = 0
        if let prepareForReuseOB = objc_getAssociatedObject(base, &prepareForReuseKey) as? Observable<Void> {
            return prepareForReuseOB
        }
        let prepareForReuseOB = Observable.of(
            sentMessage(#selector(Base.prepareForReuse)).map { _ in }
            , deallocated)
            .merge()
        objc_setAssociatedObject(base, &prepareForReuseKey, prepareForReuseOB, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)

        return prepareForReuseOB
    }
    
    // 提供一个重用垃圾回收袋
        public var reuseBag: DisposeBag {
            MainScheduler.ensureExecutingOnScheduler()
            var prepareForReuseBag: Int8 = 0
            if let bag = objc_getAssociatedObject(base, &prepareForReuseBag) as? DisposeBag {
                return bag
            }
            
            let bag = DisposeBag()
            objc_setAssociatedObject(base, &prepareForReuseBag, bag, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            
            _ = sentMessage(#selector(Base.prepareForReuse))
                .subscribe(onNext: { [weak base] _ in
                    let newBag = DisposeBag()
                    guard let base = base else {return}
                    objc_setAssociatedObject(base, &prepareForReuseBag, newBag, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
                })
            return bag
        }
}

extension String {
    subscript(_ indexs: ClosedRange<Int>) -> String {
        let beginIndex = index(startIndex, offsetBy: indexs.lowerBound)
        let endIndex = index(startIndex, offsetBy: indexs.upperBound)
        return String(self[beginIndex...endIndex])
    }
    
    subscript(_ indexs: Range<Int>) -> String {
        let beginIndex = index(startIndex, offsetBy: indexs.lowerBound)
        let endIndex = index(startIndex, offsetBy: indexs.upperBound)
        return String(self[beginIndex..<endIndex])
    }
    
    subscript(_ indexs: PartialRangeThrough<Int>) -> String {
        let endIndex = index(startIndex, offsetBy: indexs.upperBound)
        return String(self[startIndex...endIndex])
    }
    
    subscript(_ indexs: PartialRangeFrom<Int>) -> String {
        let beginIndex = index(startIndex, offsetBy: indexs.lowerBound)
        return String(self[beginIndex..<endIndex])
    }
    
    subscript(_ indexs: PartialRangeUpTo<Int>) -> String {
        let endIndex = index(startIndex, offsetBy: indexs.upperBound)
        return String(self[startIndex..<endIndex])
    }
}

public extension Array where Element: Equatable {
    
    /// 去除数组重复元素
    /// - Returns: 去除数组重复元素后的数组
    func removeDuplicate() -> Array {
       return self.enumerated().filter { (index,value) -> Bool in
            return self.firstIndex(of: value) == index
        }.map { (_, value) in
            value
        }
    }
}

