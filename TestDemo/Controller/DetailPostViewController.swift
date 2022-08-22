//
//  DetailPostViewController.swift
//  TestDemo
//
//  Created by 潘佳炜 on 2022/8/21.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class DetailPostViewController: BaseViewController {
    private let cellIdentifier = "DetailTableViewCellID"
    var postID = 0
    var isLiked = false
    // 内部序列响应，不被外界影响
    fileprivate var mySubject = PublishSubject<Bool>()
    var likeObservable : Observable<Bool>{
        return mySubject.asObservable()
    }
    
    private lazy var viewModel: DetailViewModel = {
        let vm = DetailViewModel(postID: postID)
        return vm
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.setupTableViewRX()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if tableView.superview == nil {
            tableView.register(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
            view.addSubview(tableView)
            tableView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
    
    func setUpUI() {
        self.title = "Detail"
        view.backgroundColor = .white
        
        let rightBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        rightBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        rightBtn.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        rightBtn.tintColor = .red
        rightBtn.isSelected = isLiked
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn);
        rightBtn.rx.tap
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .asObservable()
            .share(replay: 1)
            .subscribe(onNext: {[weak self] _ in
                rightBtn.isSelected = !rightBtn.isSelected
                self?.mySubject.onNext(rightBtn.isSelected)
            })
            .disposed(by: disposeBag)
        
    }
    
    func setupTableViewRX() {
        viewModel.observable?.asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items){[weak self] (tableView, indexPath, model) -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(withIdentifier: self?.cellIdentifier ?? "DetailTableViewCellID") as! DetailTableViewCell
                cell.model = model
                cell.selectionStyle = .none
                return cell
            }
            .disposed(by: disposeBag)
        
        
    }
    
    deinit {
        debugPrint("DetailVC 销毁了~")
    }
}
