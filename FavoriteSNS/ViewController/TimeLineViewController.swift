//
//  TimeLineViewController.swift
//  FavoriteSNS
//
//  Created by 原田摩利奈 on 2019/03/25.
//  Copyright © 2019 原田摩利奈. All rights reserved.
//

import UIKit
import Firebase
import KYDrawerController
import RealmSwift


class TimeLineViewController: UIViewController {
    
    
    @IBOutlet weak var timeLineTableView: UITableView!
    
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
        
        userDefaults.register(defaults: ["isFirst":false])
        let isFirst: Bool = userDefaults.bool(forKey: "isFirst")
        if !isFirst {
            performSegue(withIdentifier: "toTopViewController",sender: nil)
        }
        // Do any additional setup after loading the view.
        timeLineTableView.dataSource = self
        timeLineTableView.delegate = self
        //Identifierを設定する
        self.timeLineTableView.register(UINib(nibName: "FriendPostTableViewCell", bundle: nil), forCellReuseIdentifier: "friendPostTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let elDrawer = self.navigationController?.parent as! KYDrawerController
        (elDrawer.drawerViewController as! MenuItemViewController).dalegate = self
        getUserContents()
    }
    
    func getUserContents(){
        
        let friendResalt = realm.objects(Friend.self)
        for friendData in friendResalt {
            let ref = Database.database().reference()
            handler = ref.child(friendData.uuid).child("post").child(friendData.groupNameArray.first!).observe(.value, with: {snapshot  in
                for child in snapshot.children {
                    let postDict = (child as! DataSnapshot).value as! [String:Any]
                    ref.child(friendData.uuid).child("userData").observe(.value, with: {snapshot  in
                        let userDict = snapshot.value as! [String:Any]
                        let post = Post()
                        post.setPictureURL(pictureURL: (postDict["imageURL"] as! String))
                        post.setContents(contents: (postDict["contents"] as! String))
                        post.setLikes(likes: (postDict["likes"] as! Int))
                        post.setRepry(repry: (postDict["repry"] as! String))
                        post.setStar(star: (postDict["star"] as! Int))
                        post.setUserName(userName: (userDict["name"] as! String))
                        post.setIconURL(iconURL: (userDict["iconURL"] as! String))
                        print(post)
                        self.postArray.append(post)
                        self.timeLineTableView.reloadData()
                    })
                    
                }
            })
            
            
            
            //            self.ref.child("7BAD6550-B7F2-44DC-9F45-83410B9BA1CD").child("userData").removeAllObservers()
            
            //            self.ref.child("7BAD6550-B7F2-44DC-9F45-83410B9BA1CD").child("post").child("school").removeObserver(withHandle: self.handler)
            
        }
        
    }
}

func setContents() {
    
}

extension TimeLineViewController: UITableViewDataSource,UITableViewDelegate {
    //cellの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    //cellの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = timeLineTableView.dequeueReusableCell(withIdentifier: "friendPostTableViewCell", for: indexPath) as! FriendPostTableViewCell
        let post = postArray[indexPath.row]
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
        return 500
    }
}

extension TimeLineViewController: CustomDelegate {
    func toCamera() {
        let elDrawer = self.navigationController?.parent as! KYDrawerController
        elDrawer.setDrawerState(KYDrawerController.DrawerState.closed, animated: true)
        performSegue(withIdentifier: "toCameraViewController", sender: nil)
    }
    
    func toQrcode() {
        let elDrawer = self.navigationController?.parent as! KYDrawerController
        elDrawer.setDrawerState(KYDrawerController.DrawerState.closed, animated: true)
        performSegue(withIdentifier: "toQrcodeViewController", sender: nil)
    }
    
    func toSetting() {
        let elDrawer = self.navigationController?.parent as! KYDrawerController
        elDrawer.setDrawerState(KYDrawerController.DrawerState.closed, animated: true)
        performSegue(withIdentifier: "toSettingViewController", sender: nil)
    }
    
    func toGroup() {
        let elDrawer = self.navigationController?.parent as! KYDrawerController
        elDrawer.setDrawerState(KYDrawerController.DrawerState.closed, animated: true)
        performSegue(withIdentifier: "toGroupViewController", sender: nil)
    }
    
    
    func toMyPost() {
        let elDrawer = self.navigationController?.parent as! KYDrawerController
        elDrawer.setDrawerState(KYDrawerController.DrawerState.closed, animated: true)
        performSegue(withIdentifier: "toMyPostViewController", sender: nil)
    }
    
    
}
