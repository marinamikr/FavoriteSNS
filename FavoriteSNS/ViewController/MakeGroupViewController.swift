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
    let userDefaults = UserDefaults.standard
    
    
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
        uploadGroupName(groupName: groupName.text!)
    }
    
    func uploadGroupName(groupName: String) {
        print("upload")
        let groupArray = [groupName]
        let ref = Database.database().reference()
        ref.child(Util.getUUID()).child("userData").child("group").setValue(groupArray)
        
        userDefaults.set(true, forKey: "isFirst")
        userDefaults.synchronize()
        
        ref.child(Util.getUUID()).child("userData").child("group").observe(.value, with: {snapshot  in
           self.navigationController?.popToRootViewController(animated: true)
        })
        
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
