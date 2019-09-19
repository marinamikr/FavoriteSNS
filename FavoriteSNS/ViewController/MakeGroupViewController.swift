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
    var DBRef:DatabaseReference!
    @IBOutlet weak var groupName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "投稿"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.gray]
        groupName.delegate = self
        DBRef = Database.database().reference()
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if groupName.text != "" {
            uploadGroupName(groupName: groupName.text!)
        } else {
            makeAleart(title: "全て入力してください", message: "全て入力してください", okText: "OK")
        }
    }
    
    func makeAleart(title: String, message: String, okText: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okayButton = UIAlertAction(title: okText, style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okayButton)
        present(alert, animated: true, completion: nil)
    }
    
    func uploadGroupName(groupName: String) {
        print("upload")
        let groupArray = [groupName]
        let ref = Database.database().reference()
        ref.child(Util.getUUID()).child("userData").child("group").setValue(groupArray)
        userDefaults.set(true, forKey: "isFirst")
        userDefaults.synchronize()
        ref.child(Util.getUUID()).child("userData").child("group").observe(.value, with: {snapshot  in
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        groupName.resignFirstResponder()
        return true
    }
}

extension MakeGroupViewController :UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
