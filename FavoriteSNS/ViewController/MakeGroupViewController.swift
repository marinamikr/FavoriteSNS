//
//  MakeGroupViewController.swift
//  FavoriteSNS
//
//  Created by 原田摩利奈 on 2019/03/26.
//  Copyright © 2019 原田摩利奈. All rights reserved.
//

import UIKit
import RealmSwift

class MakeGroupViewController: UIViewController {

    var userName: String!
    var iconImage: UIImage!
    
    @IBOutlet weak var groupName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
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

    }
    
}
