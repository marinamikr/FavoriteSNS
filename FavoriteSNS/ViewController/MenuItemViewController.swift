//
//  MenuItemViewController.swift
//  FavoriteSNS
//
//  Created by 原田摩利奈 on 2019/03/27.
//  Copyright © 2019 原田摩利奈. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase

class MenuItemViewController: UIViewController {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var menuTableVIew: UITableView!
    
    var userDefaults:UserDefaults = UserDefaults.standard
    var array:[String] = ["自分の投稿","MyQRコード","QRコード読み取り","グループ一覧","設定"]
    var dalegate : CustomDelegate!
    var ref:DatabaseReference!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuTableVIew.register(UINib(nibName: "MenuItemTableViewCell", bundle: nil), forCellReuseIdentifier: "menuItemTableViewCell")
        menuTableVIew.dataSource = self
        menuTableVIew.delegate = self
        ref = Database.database().reference()
        
        followLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MenuItemViewController.tappedFollowLabel(_:))))
        followerLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MenuItemViewController.tappedFollowerLabel(_:))))
        
        getUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (self.userDefaults.string(forKey: "UserName") != nil) {
            let realm = try! Realm()
            let result = realm.objects(User.self).first
            var iconImage = UIImage(data: result?.userIcon as! Data)
            iconImageView.image = iconImage
            nameLabel.text = result?.userName
        }
    }
    
    @objc func tappedFollowLabel(_ sender:UITapGestureRecognizer) {
        FriendListViewController.isFollow = true
        dalegate.toFriend()
    }
    
    @objc func tappedFollowerLabel(_ sender:UITapGestureRecognizer) {
        FriendListViewController.isFollow = false
        dalegate.toFriend()
    }
    
    func getUserData() {
        
        ref.child(Util.getUUID()).child("userData").child("follow").observe(.value, with: {snapshot in
            self.followLabel.text = String(snapshot.children.allObjects.count)
        })
        ref.child(Util.getUUID()).child("userData").child("follower").observe(.value, with: {snapshot in
            self.followerLabel.text = String(snapshot.children.allObjects.count)
        })
        
        ref.child(Util.getUUID()).child("userData").observe(.value, with: {snapshot in
           let userDict = snapshot.value as! [String:Any]
            self.nameLabel.text = userDict["name"] as! String
            self.iconImageView.loadImage(urlString: userDict["iconURL"] as! String)
        })
        
    }
    
}

extension MenuItemViewController :UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.menuTableVIew.dequeueReusableCell(withIdentifier: "menuItemTableViewCell") as? MenuItemTableViewCell
        cell?.label.text = array[indexPath.row]
        return cell!
    }
    //セルが押された時に呼ばれるデリゲートメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // indexPath.rowを使う
        switch indexPath.row {
        case 0:
            dalegate.toMyPost()
        case 1:
            dalegate.toQrcode()
        case 2:
            dalegate.toCamera()
        case 3:
            dalegate.toGroup()
        case 4:
            dalegate.toSetting()
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
}
