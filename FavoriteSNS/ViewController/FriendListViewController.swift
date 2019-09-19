//
//  FriendListViewController.swift
//  FavoriteSNS
//
//  Created by 原田摩利奈 on 2019/06/25.
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
        if FriendListViewController.isFollow{
             self.navigationItem.title = "フォロー一覧"
        }else{
             self.navigationItem.title = "フォロワー一覧"
        }
       
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.gray]
        ref = Database.database().reference()
        friendTableView.dataSource = self
        friendTableView.delegate = self
        setUpSafeArea()
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
                    friend.userIconURL = userDict["iconURL"] as! String
                    self.friendArray.append(friend)
                    self.friendTableView.reloadData()
                })
            }
        })
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
        friendTableView.frame = rect
    }
}

extension FriendListViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendTableView.dequeueReusableCell(withIdentifier: "friendTableViewCell", for: indexPath) as! FriendTableViewCell
        cell.setFriendName(friendName: friendArray[indexPath.row].userName)
        cell.iconImageView.loadImageCircle(urlString: friendArray[indexPath.row].userIconURL)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toPostViewController", sender: friendArray[indexPath.row].uuid)
    }
}
