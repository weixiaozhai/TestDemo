//
//  ViewController.swift
//  TestDemo
//
//  Created by 潘佳炜 on 2022/8/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit

class PostsListViewController: BaseViewController {
    let cellIdentifier = "PostTableViewCellID"
    lazy var viewModel: HomeViewModel = {
        let vm = HomeViewModel()
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
            tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
            view.addSubview(tableView)
            tableView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
    func setUpUI() {
        self.title = "Posts"
        //刷新按钮
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        btn.setTitle("Reload", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn);
        btn.rx.tap
            .throttle(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .asObservable()
            .flatMapLatest { () -> Observable<[SectionModel<String, Post>]> in
                return self.viewModel.getPosts
            }
            .share(replay: 1)
            .retry()
            .subscribe(onNext: {[weak self] arr in
                debugPrint("拿到数据了按钮")
                self?.viewModel.refreshData(arr: arr)
                
            })
            .disposed(by: disposeBag)
        
        //排序按钮
        let rightBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 40))
        rightBtn.setTitle("Sort", for: .normal)
        rightBtn.setTitle("UnSort", for: .selected)
        rightBtn.setTitleColor(.black, for: .normal)
        rightBtn.setTitleColor(.black, for: .selected)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn);
        rightBtn.rx.tap
            .asObservable()
            .subscribe(onNext: {[weak self] Void in
                rightBtn.isSelected = !rightBtn.isSelected
                self?.viewModel.isSorted = rightBtn.isSelected
            })
            .disposed(by: disposeBag)
        
        
        
    }
    
    func setupTableViewRX() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,Post>> {[weak self] datasource, tableV, indexpath, model in
            let cell = tableV.dequeueReusableCell(withIdentifier: self?.cellIdentifier ?? "PostTableViewCellID") as! PostTableViewCell
            cell.model = model
            cell.likeBtn.rx.tap
                .subscribe(onNext: {[weak self] () in
                    self?.viewModel.updateLiked(indexP: indexpath, liked: !model.isLiked)
                    debugPrint("点击了\(indexpath)喜欢按钮")
                })
                .disposed(by: cell.rx.reuseBag)
            cell.selectionStyle = .none
            return cell
        }
        dataSource.titleForHeaderInSection = { ds, index in
            return ds.sectionModels[index].model
        }
        viewModel.publishSubject
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.scrollSubject.asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] needScroll in
                guard needScroll == true else {
                    return
                }
                self?.tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            })
            .disposed(by: disposeBag)
        
        
        
        // tableView点击事件
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(Post.self))
            .bind { [weak self] indexPath, post in
                debugPrint("点击了\(indexPath.row)行")
                let detailVC = DetailPostViewController()
                detailVC.isLiked = post.isLiked
                detailVC.postID = post.id ?? 0
                //监听detailVC的❤️按钮点击
                detailVC.likeObservable
                    .asDriver(onErrorJustReturn: false)
                    .drive(onNext: {[weak self] liked in
                        self?.viewModel.updateLiked(indexP: indexPath, liked: liked)
                        
                    })
                    .disposed(by: detailVC.disposeBag)
                
                self?.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(detailVC, animated: true)
            }
            .disposed(by: disposeBag)
        
    }
    
    
}

