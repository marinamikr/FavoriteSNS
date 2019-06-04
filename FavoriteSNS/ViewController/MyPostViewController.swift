//
//  MyPostViewController.swift
//  FavoriteSNS
//
//  Created by 原田摩利奈 on 2019/05/14.
//  Copyright © 2019 原田摩利奈. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class MyPostViewController: UIViewController {

    @IBOutlet weak var myPostTableView: UITableView!
    
    let userDefaults = UserDefaults.standard
    // インスタンス変数
    var DBRef:DatabaseReference!
    
    var postArray :Array<Post> = Array()
    
    var ref:DatabaseReference!
    
    var handler: UInt = 0
    
    let realm = try! Realm()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //インスタンスを作成
        DBRef = Database.database().reference()
        // Do any additional setup after loading the view.
        
        // Do any additional setup after loading the view.
        myPostTableView.dataSource = self
        myPostTableView.delegate = self
        //Identifierを設定する
        self.myPostTableView.register(UINib(nibName: "MyPostTableViewCell", bundle: nil), forCellReuseIdentifier: "myPostTableViewCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserContents()
    }

    func getUserContents(){
        
        let userResalt = realm.objects(User.self)
        
        for groupName in userResalt.first!.groupNameArray {
            let ref = Database.database().reference()
            handler = ref.child(Util.getUUID()).child("post").child(groupName).observe(.value, with: {snapshot  in
                for child in snapshot.children {
                    let postDict = (child as! DataSnapshot).value as! [String:Any]
                    ref.child(Util.getUUID()).child("userData").observe(.value, with: {snapshot  in
                        let userDict = snapshot.value as! [String:Any]
                        let post = Post()
                        post.setPictureURL(pictureURL: (postDict["imageURL"] as! String))
                        post.setContents(contents: (postDict["contents"] as! String))
                        post.setLikes(likes: (postDict["likes"] as! Int))
                        post.setRepry(repry: (postDict["repry"] as! String))
                        post.setStar(star: (postDict["star"] as! Int))
                        post.setUserName(userName: (userDict["name"] as! String))
                        post.setIconURL(iconURL: (userDict["iconURL"] as! String))
                        post.setUUID(uuid: Util.getUUID())
                        post.setGroupName(groupName: groupName)
                        post.setAutoID(autoID: (child as! DataSnapshot).key)
                        print(postDict)
                        print((child as! DataSnapshot).key)
                        self.postArray.append(post)
                        self.myPostTableView.reloadData()
                    })
                    
                }
            })
            
            
            
            //            self.ref.child("7BAD6550-B7F2-44DC-9F45-83410B9BA1CD").child("userData").removeAllObservers()
            
            //            self.ref.child("7BAD6550-B7F2-44DC-9F45-83410B9BA1CD").child("post").child("school").removeObserver(withHandle: self.handler)
            
        }
        
    }
    
}
extension MyPostViewController: UITableViewDataSource,UITableViewDelegate {
    //cellの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    //cellの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myPostTableView.dequeueReusableCell(withIdentifier: "myPostTableViewCell", for: indexPath) as! MyPostTableViewCell
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
