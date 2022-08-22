//
//  PostTableViewCell.swift
//  TestDemo
//
//  Created by 潘佳炜 on 2022/8/21.
//

import UIKit
import RxSwift

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var likeBtn: UIButton!
        
    var model: Post?{
        didSet{
            self.titleLabel.text = model?.title
            self.contentLabel.text = model?.body
            if let isLiked = model?.isLiked {
                likeBtn.isSelected = isLiked
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func likeCLick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    
}
