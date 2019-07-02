//
//  MenuItemViewController.swift
//  FavoriteSNS
//
//  Created by 原田摩利奈 on 2019/03/27.
//  Copyright © 2019 原田摩利奈. All rights reserved.
//

import UIKit
import RealmSwift

class MenuItemViewController: UIViewController {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var menuTableVIew: UITableView!
    
    var userDefaults:UserDefaults = UserDefaults.standard
    var array:[String] = ["自分の投稿","MyQRコード","QRコード読み取り","グループ一覧","設定"]
    var dalegate : CustomDelegate!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuTableVIew.register(UINib(nibName: "MenuItemTableViewCell", bundle: nil), forCellReuseIdentifier: "menuItemTableViewCell")
        menuTableVIew.dataSource = self
        menuTableVIew.delegate = self
        
        
        followLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MenuItemViewController.tappedLabel(_:))))
        followerLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MenuItemViewController.tappedLabel(_:))))
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
    
    @objc func tappedLabel(_ sender:UITapGestureRecognizer) {
        dalegate.toFriend()
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
