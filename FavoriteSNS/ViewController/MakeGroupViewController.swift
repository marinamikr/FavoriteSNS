//
//  MakeGroupViewController.swift
//  FavoriteSNS
//
//  Created by 原田摩利奈 on 2019/03/26.
//  Copyright © 2019 原田摩利奈. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase

class MakeGroupViewController: UIViewController {

    var userName: String!
    var iconImage: UIImage!
    
    // インスタンス変数
    var DBRef:DatabaseReference!
    
    @IBOutlet weak var groupName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupName.delegate = self
        //インスタンスを作成
        DBRef = Database.database().reference()
    }
    
    @IBAction func saveButton(_ sender: Any) {
        let realm = try! Realm()
        let picData: NSData? = iconImage!.jpegData(compressionQuality: 0.8) as! NSData
        var list : List<String>
        
        let saveData = User()
        saveData.userName = userName
        saveData.userIcon = iconImage.jpegData(compressionQuality: 0.8)
        saveData.groupNameArray.append(groupName.text!)
        
        try! realm.write {
            realm.add(saveData)
        }
        
        uploadGroupName(groupName: groupName.text!)

    }
    func uploadGroupName(groupName: String) {
        let groupArray = [groupName]
        let ref = Database.database().reference()
        ref.child(Util.getUUID()).child("userData").child("group").setValue(groupArray)
    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        groupName.resignFirstResponder()
        return true
    }
    
}
extension MakeGroupViewController :UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
