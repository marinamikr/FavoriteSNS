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
    @IBOutlet weak var heartImageView: UIImageView!
    @IBOutlet weak var containtsView: UIView!
    @IBOutlet weak var repryButton: UIButton!
    private var indexNum: Int!
    var URL = String()
    var imageURL = String()
    var postModel: Post = Post()
    var DBRef:DatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DBRef = Database.database().reference()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setPostModel(post: Post) {
        self.postModel = post
        setContents(contentsData: post.getContents())
        setImage(imageData: post.getPictureURL())
        setUserName(nameData: post.getUserName())
        setIconImage(iconURL: post.getIconURL())
        setLikeLabel(likeData: post.getLikes())
        setStarLabel(starData: post.getStar())
    }
    
    private func setImage(imageData: String) {
        self.imageURL = imageData
        pictureImageView.loadImage(urlString: imageData)
    }
    
    private func setContents(contentsData: String) {
        contentsTextView.text = contentsData
        contentsTextView.isUserInteractionEnabled = true
        contentsTextView.isEditable = false
    }
    
    private func setUserName(nameData: String) {
        userNameLabel.text = nameData
    }
    
    private func setIconImage(iconURL: String) {
        self.URL = iconURL
        iconImageView.loadImageCircle(urlString: iconURL)
    }
    
    private func setLikeLabel(likeData: Int) {
        likeLabel.text = String(likeData) + "件"
    }
    
    private func setStarLabel(starData: Int) {
        starLabel.text = String(starData)
    }
    
    func setheartImage(imageName: String) {
        heartImageView.image = UIImage(named: imageName)
        heartImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FriendPostTableViewCell.imageViewTapped(_:))))
    }
    
    @objc func imageViewTapped(_ sender: UITapGestureRecognizer) {
        postModel.setLikes(likes: postModel.getLikes() + 1)
        setLikeLabel(likeData: postModel.getLikes())
        uploadLikes(like: postModel.getLikes())
    }
    
    private func uploadLikes(like: Int){
        let ref = Database.database().reference()
        ref.child(postModel.getUUID()).child("post").child(postModel.getGroupName()).child(postModel.getAutoID()).child("likes").setValue(like)
    }
    
    func setIndex(indexData: Int){
        indexNum = indexData
    }
    
    func getIndex() -> Int{
        return indexNum
    }
    
    @IBAction func repryButton(_ sender: Any) {
        var baseView = UIApplication.shared.keyWindow?.rootViewController
        while ((baseView?.presentedViewController) != nil)  {
            baseView = baseView?.presentedViewController
        }
        let alert = UIAlertController(title: "コメント入力", message: "コメントを入力して下さい", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            if let textFields = alert.textFields {
                for textField in textFields {
                    self.upLoadComment(comment: textField.text!)
                }
            }
        })
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = "テキスト"
        })
        alert.view.setNeedsLayout()
        baseView?.present(alert, animated: true, completion: nil)
    }
    
    func upLoadComment(comment: String) {
        let dateManeger = DateManager()
        var time = dateManeger.stringFromDate(date: Date())
        let data = ["uuid": Util.getUUID(),"repry": comment,"time":time] as [String : Any]
        DBRef.child(postModel.getUUID()).child("post").child(postModel.getGroupName()).child(postModel.getAutoID()).child("repry").childByAutoId().setValue(data)
    }
    
}
