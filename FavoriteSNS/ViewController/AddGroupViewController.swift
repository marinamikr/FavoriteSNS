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
        self.navigationItem.title = "setting"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.gray]
        allGroupTableView.delegate = self
        allGroupTableView.dataSource = self
        DBRef = Database.database().reference()
        DBRef.child(Util.getUUID()).child("userData").child("group").observe(.value, with: {snapshot  in
            self.groupNameArray = snapshot.value as! [String]
            self.allGroupTableView.reloadData()
        })
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.addGroup))
        self.allGroupTableView.register(UINib(nibName: "AddGroupCustomCell", bundle: nil), forCellReuseIdentifier: "addGroupCustomCell")
        setUpSafeArea()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setUpSafeArea(){
        var topPadding:CGFloat = 0
        var bottomPadding:CGFloat = 0
        var leftPadding:CGFloat = 0
        var rightPadding:CGFloat = 0
        let screenWidth:CGFloat = view.frame.size.width
        let screenHeight:CGFloat = view.frame.size.height
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            topPadding = window!.safeAreaInsets.top
            bottomPadding = window!.safeAreaInsets.bottom
            leftPadding = window!.safeAreaInsets.left + 16
            rightPadding = window!.safeAreaInsets.right + 16
            print(topPadding)
        }
        topPadding = topPadding + (self.navigationController?.navigationBar.frame.size.height ?? 0)
        var safeAreaWidth = screenWidth - leftPadding - rightPadding
        var safeAreaHeight = (screenHeight) - topPadding - bottomPadding
        if(screenWidth > screenHeight){
            safeAreaWidth = screenWidth - leftPadding - rightPadding
            safeAreaHeight = (screenHeight) - topPadding - bottomPadding
        }
        let rect = CGRect(x: leftPadding,
                          y: topPadding,
                          width: safeAreaWidth,
                          height: safeAreaHeight)
        allGroupTableView.frame = rect
        print(rect)
    }
    
    @objc func addGroup(){
        let alert = UIAlertController(title: "タイトル", message: "メッセージ", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            if let textFields = alert.textFields {
                for textField in textFields {
                    self.groupNameArray.append(textField.text!)
                    self.DBRef.child(Util.getUUID()).child("userData").child("group").setValue(self.groupNameArray)
                    self.allGroupTableView.reloadData()
                }
            }
        })
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = "テキスト"
        })
        alert.view.setNeedsLayout()
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
