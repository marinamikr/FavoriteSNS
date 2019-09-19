//
//  PostGroupItemTableViewCell.swift
//  FavoriteSNS
//
//  Created by 原田摩利奈 on 2019/07/16.
//  Copyright © 2019 原田摩利奈. All rights reserved.
//

import UIKit

class PostGroupItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var chooseGroupSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
