//
//  PostViewController.swift
//  FavoriteSNS
//
//  Created by 原田摩利奈 on 2019/05/14.
//  Copyright © 2019 原田摩利奈. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class PostViewController: UIViewController {
    
    @IBOutlet weak var postTableView: UITableView!
    
    let userDefaults = UserDefaults.standard
    // インスタンス変数
    var DBRef:DatabaseReference!
    
    var postArray :Array<Post> = Array()
    
    var ref:DatabaseReference!
    
    var handler: UInt = 0
    var groupHandler: UInt = 0
    
    let realm = try! Realm()
    
    var uuid :String =  Util.getUUID()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //インスタンスを作成
        DBRef = Database.database().reference()
        // Do any additional setup after loading the view.
        
        // Do any additional setup after loading the view.
        postTableView.dataSource = self
        postTableView.delegate = self
        //Identifierを設定する
        self.postTableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "postTableViewCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserContents()
    }
    
    func getUserContents(){
        
        ref = Database.database().reference()
        groupHandler = ref.child(self.uuid).child("userData").child("group").observe(.value, with: {snapshot  in
            let groupArray = (snapshot as! DataSnapshot).value as! [String]
            for groupName in groupArray {
                self.handler = self.ref.child(self.uuid).child("post").child(groupName).observe(.value, with: {snapshot  in
                    for child in snapshot.children {
                        let postDict = (child as! DataSnapshot).value as! [String:Any]
                        self.ref.child(self.uuid).child("userData").observe(.value, with: {snapshot  in
                            let userDict = snapshot.value as! [String:Any]
                            let post = Post()
                            post.setPictureURL(pictureURL: (postDict["imageURL"] as! String))
                            post.setContents(contents: (postDict["contents"] as! String))
                            post.setLikes(likes: (postDict["likes"] as! Int))
                            post.setRepry(repry: (postDict["repry"] as! String))
                            post.setStar(star: (postDict["star"] as! Int))
                            post.setUserName(userName: (userDict["name"] as! String))
                            post.setIconURL(iconURL: (userDict["iconURL"] as! String))
                            post.setUUID(uuid: self.uuid)
                            post.setGroupName(groupName: groupName)
                            post.setAutoID(autoID: (child as! DataSnapshot).key)
                            self.postArray.append(post)
                            self.postTableView.reloadData()
                        })
                        
                    }
                })
                
                
                
//                self.ref.child(self.uuid).child("userData").removeAllObservers()
//                self.ref.child(self.uuid).child("post").child(groupName).removeObserver(withHandle: self.handler)
                
            }
        })
//        ref.child(self.uuid).child("userData").child("group").removeAllObservers()
    }
    
}
extension PostViewController: UITableViewDataSource,UITableViewDelegate {
    //cellの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(postArray.count)
        return postArray.count
    }
    
    //cellの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postTableView.dequeueReusableCell(withIdentifier: "postTableViewCell", for: indexPath) as! PostTableViewCell
        let post = postArray[indexPath.row]
        cell.setPostModel(post: post)
        cell.setContents(contentsData: post.getContents())
        cell.setImage(imageData: post.getPictureURL())
        cell.setUserName(nameData: post.getUserName())
        cell.setIconImage(iconURL: post.getIconURL())
        cell.setLikeLabel(likeData: post.getLikes())
        cell.setRepryLabel(repryData: post.getRepry())
        cell.setStarLabel(starData: post.getStar())
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 580
    }
}