//
//  BaseViewController.swift
//  TestDemo
//
//  Created by 潘佳炜 on 2022/8/21.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    let disposeBag = DisposeBag()
    lazy var tableView: UITableView = {
        let tableV = UITableView(frame: .zero)
        tableV.estimatedRowHeight = 64
        tableV.rowHeight = UITableView.automaticDimension
        return tableV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
