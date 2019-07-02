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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setFriendName(friendName: String) {
        friendNameLabel.text = friendName
    }
    
    
}
