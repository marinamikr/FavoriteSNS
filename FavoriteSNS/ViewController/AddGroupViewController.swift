//
//  addGroupViewController.swift
//  FavoriteSNS
//
//  Created by 原田摩利奈 on 2019/06/04.
//  Copyright © 2019 原田摩利奈. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase

class AddGroupViewController: UIViewController {
    
    var DBRef:DatabaseReference!

    @IBOutlet weak var allGroupTableView: UITableView!
    var groupNameArray:[String] = []
    
    let realm = try! Realm()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        allGroupTableView.delegate = self
        allGroupTableView.dataSource = self
        DBRef = Database.database().reference()

        
        DBRef.child(Util.getUUID()).child("userData").child("group").observe(.value, with: {snapshot  in
            self.groupNameArray = snapshot.value as! [String]
            self.allGroupTableView.reloadData()
        })
        
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.addGroup))

        //Identifierを設定する
        self.allGroupTableView.register(UINib(nibName: "AddGroupCustomCell", bundle: nil), forCellReuseIdentifier: "addGroupCustomCell")
    }
    @objc func addGroup(){
        // テキストフィールド付きアラート表示
        
        let alert = UIAlertController(title: "タイトル", message: "メッセージ", preferredStyle: .alert)
        
        // OKボタンの設定
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            
            // OKを押した時入力されていたテキストを表示
            if let textFields = alert.textFields {
                
                // アラートに含まれるすべてのテキストフィールドを調べる
                for textField in textFields {
                    self.groupNameArray.append(textField.text!)
                    self.DBRef.child(Util.getUUID()).child("userData").child("group").setValue(self.groupNameArray)
                    self.allGroupTableView.reloadData()
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
        
        //アラートを画面に表示
        self.present(alert, animated: true, completion: nil)
    }

}
extension AddGroupViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = allGroupTableView.dequeueReusableCell(withIdentifier: "addGroupCustomCell", for: indexPath) as! AddGroupCustomCell
        cell.setText(text: groupNameArray[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
