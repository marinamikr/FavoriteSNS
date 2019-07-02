//
//  MyPostTableViewCell.swift
//  FavoriteSNS
//
//  Created by 原田摩利奈 on 2019/06/04.
//  Copyright © 2019 原田摩利奈. All rights reserved.
//

import UIKit
import Firebase

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var pictureImageView: UIImageView!
    
    @IBOutlet weak var contentsTextView: UITextView!
    
    @IBOutlet weak var likeLabel: UILabel!
    
    @IBOutlet weak var starLabel: UILabel!
    
    @IBOutlet weak var repryLabel: UILabel!
    
    var URL = String()
    
    var imageURL = String()
    
    var postModel: Post = Post()
    
    // インスタンス変数
    var DBRef:DatabaseReference!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setPostModel(post: Post) {
        self.postModel = post
    }
    
    func setImage(imageData: String) {
        self.imageURL = imageData
        pictureImageView.loadImage(urlString: imageData)
    }
    
    func setContents(contentsData: String) {
        contentsTextView.text = contentsData
        contentsTextView.isUserInteractionEnabled = true
        contentsTextView.isEditable = false
    }
    
    func setUserName(nameData: String) {
        userNameLabel.text = nameData
    }
    
    func setIconImage(iconURL: String) {
        self.URL = iconURL
        iconImageView.loadImage(urlString: iconURL)
    }
    
    func setLikeLabel(likeData: Int) {
        likeLabel.text = String(likeData)
    }
    
    func setStarLabel(starData: Int) {
        starLabel.text = String(starData)
    }
    
    func setRepryLabel(repryData: String) {
        repryLabel.text = repryData
    }
    
    
}
