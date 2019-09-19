//
//  PostLikeTableViewCell.swift
//  FavoriteSNS
//
//  Created by 原田摩利奈 on 2019/07/09.
//  Copyright © 2019 原田摩利奈. All rights reserved.
//

import UIKit

class PostLikeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
