//
//  ChooseGroupeViewController.swift
//  FavoriteSNS
//
//  Created by 原田摩利奈 on 2019/05/14.
//  Copyright © 2019 原田摩利奈. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class ChooseGroupeViewController: UIViewController {
    
    // インスタンス変数
    var DBRef:DatabaseReference!
    
    var uuid :String! = ""
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var groupPickerView: UIPickerView!
    
   
    
    var friendData: Friend = Friend()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //インスタンスを作成
        DBRef = Database.database().reference()
        getUserData(uuid: uuid)
        // ピッカー設定
        groupPickerView.delegate = self
        groupPickerView.dataSource = self
        groupPickerView.showsSelectionIndicator = true
    }
    func getUserData(uuid: String) {
        DBRef.child(uuid).child("userData").observe(.value, with: {snapshot  in
            let postDict = snapshot.value as! [String : AnyObject]
            self.friendData.userName = postDict["name"] as! String
            self.friendData.userIconURL = postDict["iconURL"] as! String
            let array = postDict["group"] as! [String]
            let groupNameArray = List<String>()
            for item in array{
                groupNameArray.append(item)
            }
            self.friendData.groupNameArray = groupNameArray
            self.reloadView()
        })
    }
    
    func reloadView()  {
        self.userName.text = self.friendData.userName
        self.iconImage.loadImage(urlString: self.friendData.userIconURL)
        self.groupPickerView.reloadAllComponents()
    }
    
    @IBAction func followButton(_ sender: Any) {
        let tmpGroupNameArray = List<String>()
        for item in friendData.groupNameArray{
            tmpGroupNameArray.append(item)
        }
        friendData.groupNameArray.removeAll()
        friendData.groupNameArray.append(tmpGroupNameArray[groupPickerView.selectedRow(inComponent: 0)])
        friendData.uuid = uuid
        let realm = try! Realm()

        try! realm.write {
            realm.add(friendData)
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    
}

extension ChooseGroupeViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    // ドラムロールの列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // ドラムロールの行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return friendData.groupNameArray.count
    }
    
    // ドラムロールの各タイトル
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return friendData.groupNameArray[row]
    }
    
}
