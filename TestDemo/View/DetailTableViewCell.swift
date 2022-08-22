//
//  DetailTableViewCell.swift
//  TestDemo
//
//  Created by 潘佳炜 on 2022/8/21.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var bodyLabel: UILabel!
    
    var model: Comment?{
        didSet{
            self.titleLabel.text = model?.name
            self.emailLabel.text = model?.email
            self.bodyLabel.text = model?.body
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    
}
