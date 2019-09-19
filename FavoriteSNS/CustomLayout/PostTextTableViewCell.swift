//
//  PostTextTableViewCell.swift
//  FavoriteSNS
//
//  Created by 原田摩利奈 on 2019/07/09.
//  Copyright © 2019 原田摩利奈. All rights reserved.
//

import UIKit

class PostTextTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var choosePictureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
