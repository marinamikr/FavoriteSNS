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
    
    
    
    func makeCorner() {
//        containtsView.layer.cornerRadius = 30
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
        likeLabel.text = String(likeData)
    }
    
    private func setStarLabel(starData: Int) {
        starLabel.text = String(starData)
    }
    
//        private func setRepryLabel(repryData: String) {
//            repryLabel.text = repryData
//        }
    
    func setheartImage(imageName: String) {
        heartImageView.image = UIImage(named: imageName)
        heartImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FriendPostTableViewCell.imageViewTapped(_:))))
    }
    
    
    // 画像がタップされたら呼ばれる
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
        
        // テキストフィールド付きアラート表示
        
        let alert = UIAlertController(title: "タイトル", message: "メッセージ", preferredStyle: .alert)
        
        // OKボタンの設定
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            
            // OKを押した時入力されていたテキストを表示
            if let textFields = alert.textFields {
                
                // アラートに含まれるすべてのテキストフィールドを調べる
                for textField in textFields {
                    self.upLoadComment(comment: textField.text!)
                }
            }
        })
        alert.addAction(okAction)
        
        // キャンセルボタンの設定
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        // テキストフィールドを追加
        alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = "テキスト"
        })
        
        alert.view.setNeedsLayout() // シミュレータの種類によっては、これがないと警告が発生
        
        
        baseView?.present(alert, animated: true, completion: nil)
    }
    
    func upLoadComment(comment: String) {

        let data = ["uuid": Util.getUUID(),"repry": comment] as [String : Any]
        DBRef.child(postModel.getUUID()).child("post").child(postModel.getGroupName()).child(postModel.getAutoID()).child("repry").childByAutoId().setValue(data)
    }
    
}

