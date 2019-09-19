//
//  FriendTableViewCell.swift
//  FavoriteSNS
//
//  Created by 橋詰明宗 on 2019/06/25.
//  Copyright © 2019 原田摩利奈. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    
    @IBOutlet weak var friendNameLabel: UILabel!
    
    @IBOutlet weak var iconImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setFriendName(friendName: String) {
        print(friendName)
        friendNameLabel.text = friendName
    }
    
}
