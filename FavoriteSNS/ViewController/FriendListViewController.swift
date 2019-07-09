//
//  FriendListViewController.swift
//  FavoriteSNS
//
//  Created by 橋詰明宗 on 2019/06/25.
//  Copyright © 2019 原田摩利奈. All rights reserved.
//

import UIKit
import Firebase

class FriendListViewController: UIViewController {
    @IBOutlet weak var friendTableView: UITableView!
    var friendArray :Array<Friend> = Array()
    var ref:DatabaseReference!
    static var isFollow: Bool = false
    var childName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
        friendTableView.dataSource = self
        friendTableView.delegate = self
        
        if FriendListViewController.isFollow {
            childName = "follow"
        }else{
            childName = "follower"
        }
        
        ref.child(Util.getUUID()).child("userData").child(childName).observe(.value, with: {snapshot in
            for followUser in snapshot.children {
                let followUserDict = (followUser as! DataSnapshot).value as! [String:Any]
                let friendID = followUserDict["uuid"] as! String
                let friendGroupName = followUserDict["groupName"] as! String
                self.ref.child(friendID).child("userData").observe(.value, with: {snapshot in
                    let userDict = snapshot.value as! [String:Any]
                    let friend = Friend()
                    friend.uuid = friendID
                    friend.group = friendGroupName
                    friend.userName = userDict["name"] as! String
                    self.friendArray.append(friend)
                    self.friendTableView.reloadData()
                })
                
            }
        })
        //Identifierを設定する
        friendTableView.register(UINib(nibName: "FriendTableViewCell", bundle: nil), forCellReuseIdentifier: "friendTableViewCell")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender:
        Any?) {
        if (segue.identifier == "toPostViewController") {
            let postViewController = (segue.destination as?
                PostViewController)!
            postViewController.uuid = sender as! String
        }
    }
    
}

extension FriendListViewController: UITableViewDataSource,UITableViewDelegate {
    //cellの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendArray.count
    }
    
    //cellの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendTableView.dequeueReusableCell(withIdentifier: "friendTableViewCell", for: indexPath) as! FriendTableViewCell
        cell.setFriendName(friendName: friendArray[indexPath.row].userName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toPostViewController", sender: friendArray[indexPath.row].uuid)
    }
    
}
