//
//  MenuItemViewController.swift
//  FavoriteSNS
//
//  Created by 原田摩利奈 on 2019/03/27.
//  Copyright © 2019 原田摩利奈. All rights reserved.
//

import UIKit

class MenuItemViewController: UIViewController {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var menuTableVIew: UITableView!

    var userDefaults:UserDefaults = UserDefaults.standard
    var array:[String] = ["自分の投稿","MyQRコード","QRコード読み取り","設定"]
    var imageArray:[String] = ["MyDiary.png","QRcode.png","friend.png","Setting.png"]
    var dalegate : CustomDelegate!



    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.table.register(UINib(nibName: "CustomDrawerTableViewCell", bundle: nil), forCellReuseIdentifier: "customDrawerTableViewCell")
//        table.dataSource = self
//        table.delegate = self
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if (self.userDefaults.string(forKey: "UserName") != nil) {
//            let realm = try! Realm()
//            let result = realm.objects(UserModel.self).first
//            var iconImage = UIImage(data: result?.icon  as! Data)
//            userIcon.image = iconImage
//            userName.text = result?.nickName
//        }
    }


}
