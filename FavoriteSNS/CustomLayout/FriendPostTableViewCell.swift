//
//  FriendPostTableViewCell.swift
//  FavoriteSNS
//
//  Created by 原田摩利奈 on 2019/03/27.
//  Copyright © 2019 原田摩利奈. All rights reserved.
//

import UIKit
import Firebase

class FriendPostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var pictureImageView: UIImageView!
    
    @IBOutlet weak var contentsTextView: UITextView!
    
    @IBOutlet weak var likeLabel: UILabel!
    
    @IBOutlet weak var starLabel: UILabel!
    
    @IBOutlet weak var repryLabel: UILabel!
    
    @IBOutlet weak var heartImageView: UIImageView!
    
    var URL = String()
    
    var imageURL = String()
    
    var postModel: Post = Post()
    
    // インスタンス変数
    var DBRef:DatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //インスタンスを作成
        DBRef = Database.database().reference()
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
    
    func setheartImage(imageName: String) {
        heartImageView.image = UIImage(named: imageName)
        heartImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FriendPostTableViewCell.imageViewTapped(_:))))
    }
    
    
    
    
    // 画像がタップされたら呼ばれる
    @objc func imageViewTapped(_ sender: UITapGestureRecognizer) {
        postModel.setLikes(likes: postModel.getLikes() + 1)
        uploadLikes(like: postModel.getLikes())
        print(postModel.getLikes())
    }
    
    func uploadLikes(like: Int){
        let ref = Database.database().reference()
        ref.child(postModel.getUUID()).child("post").child(postModel.getGroupName()).child(postModel.getAutoID()).child("likes").setValue(like)
    }
}
