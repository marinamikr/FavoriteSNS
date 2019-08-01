//
//  RepryViewControllerViewController.swift
//  FavoriteSNS
//
//  Created by 原田摩利奈 on 2019/07/24.
//  Copyright © 2019 原田摩利奈. All rights reserved.
//

import UIKit
import Firebase

class RepryViewController: UIViewController {
    
    @IBOutlet weak var repryTableView: UITableView!
    
    @IBOutlet weak var repryTextField: UITextField!
    
    var DBRef:DatabaseReference!
    
    
    var postModel: Post!
    var postHandler:UInt!
    var friendHandler:UInt!
    
    fileprivate let refreshCtl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "repry"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.gray]
        repryTableView.dataSource = self
        repryTableView.delegate = self
        //Identifierを設定する
        self.repryTableView.register(UINib(nibName: "RepryTableViewCell", bundle: nil), forCellReuseIdentifier: "repryTableViewCell")
        repryTableView.refreshControl = refreshCtl
        refreshCtl.addTarget(self, action: #selector(RepryViewController.refresh(sender:)), for: .valueChanged)
        DBRef = Database.database().reference()
    }
    
    @IBAction func sendRepryButton(_ sender: Any) {
        upLoadComment(comment: repryTextField.text!)
    }
    
    func upLoadComment(comment: String) {
        
        let data = ["uuid": Util.getUUID(),"repry": comment] as [String : Any]
        DBRef.child(postModel.getUUID()).child("post").child(postModel.getGroupName()).child(postModel.getAutoID()).child("repry").childByAutoId().setValue(data)
        
    }
    func getPostData() {
      
    }
    
    @objc func refresh(sender: UIRefreshControl) {
       
        refreshCtl.endRefreshing()
    }
    
    
}
extension RepryViewController: UITableViewDataSource,UITableViewDelegate {
    //cellの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postModel.getRepryData().count
    }
    
    //cellの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let repryDict = postModel.getRepryData()[indexPath.row]
        let cell = repryTableView.dequeueReusableCell(withIdentifier: "repryTableViewCell", for: indexPath) as! RepryTableViewCell
        cell.setRepryText(repryData: repryDict["repry"]!)
        self.DBRef.child(repryDict["uuid"]!).child("userData").observe(.value, with: {snapshot in
            let userDict = snapshot.value as! [String:Any]
            cell.setName(nameData: userDict["name"] as! String)
            cell.setIconImage(iconImageData: userDict["iconURL"] as! String)
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    
    
}
