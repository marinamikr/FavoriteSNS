//
//  RepryTableViewCell.swift
//  FavoriteSNS
//
//  Created by 原田摩利奈 on 2019/07/25.
//  Copyright © 2019 原田摩利奈. All rights reserved.
//

import UIKit

class RepryTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var repryTextView: UITextView!
    
    @IBOutlet weak var iconImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setName(nameData: String) {
        self.nameLabel.text = nameData
    }
    func setRepryText(repryData: String) {
        self.repryTextView.text = repryData
    }
    func setIconImage(iconImageData: String) {
        self.iconImage.loadImageCircle(urlString: iconImageData)
    }
}
