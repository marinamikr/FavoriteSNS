//
// TimeLineViewController.swift
// FavoriteSNS
//
// Created by 原田摩利奈 on 2019/03/25.
// Copyright © 2019 原田摩利奈. All rights reserved.
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
    
    
    var followHandler: UInt = 0
    var friendHandler: UInt = 0
    var postHandler: UInt = 0
    
    let realm = try! Realm()
    
    let dateManeger = DateManager()
    
    var isFirst: Bool = false
    
    fileprivate let refreshCtl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // タイトルをセット
        self.navigationItem.title = "TimeLine"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.gray]
       
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.makeContains))
        
    
        //インスタンスを作成
        DBRef = Database.database().reference()
        
        userDefaults.register(defaults: ["isFirst":false])
        
        // Do any additional setup after loading the view.
        timeLineTableView.dataSource = self
        timeLineTableView.delegate = self
        timeLineTableView.refreshControl = refreshCtl
        refreshCtl.addTarget(self, action: #selector(TimeLineViewController.refresh(sender:)), for: .valueChanged)
        //Identifierを設定する
        self.timeLineTableView.register(UINib(nibName: "FriendPostTableViewCell", bundle: nil), forCellReuseIdentifier: "friendPostTableViewCell")
        
        if #available(iOS 11, *) {
            let guide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                timeLineTableView.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
                guide.bottomAnchor.constraint(equalToSystemSpacingBelow: timeLineTableView.bottomAnchor, multiplier: 1.0)
                ])
        } else {
            let standardSpacing: CGFloat = 8.0
            NSLayoutConstraint.activate([
                timeLineTableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: standardSpacing),
                bottomLayoutGuide.topAnchor.constraint(equalTo: timeLineTableView.bottomAnchor, constant: standardSpacing)
                ])
        }
        let frame = timeLineTableView.frame
        timeLineTableView.frame = CGRect(x:16 , y: frame.origin.y, width:  UIScreen.main.bounds.width - 32, height: frame.size.height)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let elDrawer = self.navigationController?.parent as! KYDrawerController
        (elDrawer.drawerViewController as! MenuItemViewController).dalegate = self
        elDrawer.setDrawerState(KYDrawerController.DrawerState.opened, animated: true)
        
        isFirst = userDefaults.bool(forKey: "isFirst")
        if !isFirst {
            performSegue(withIdentifier: "toTopViewController",sender: nil)
        }else{
            getUserContents()
        }
        
        // ナビゲーションを透明にする処理
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = .gray
    }
    @objc func makeContains(){
        performSegue(withIdentifier: "toContaints", sender: nil)
    }
    
    func getUserContents(){
        postArray.removeAll()
        
        let ref = Database.database().reference()
        
        self.followHandler = ref.child(Util.getUUID()).child("userData").child("follow").observe(.value, with: {snapshot in
            for followUser in snapshot.children {
                let followUserDict = (followUser as! DataSnapshot).value as! [String:Any]
                let friendID = followUserDict["uuid"] as! String
                let friendGroupName = followUserDict["groupName"] as! String
                self.friendHandler = ref.child(friendID).child("post").child(friendGroupName).observe(.value, with: {snapshot in
                    for child in snapshot.children {
                        let postDict = (child as! DataSnapshot).value as! [String:Any]
                        self.postHandler = ref.child(friendID).child("userData").observe(.value, with: {snapshot in
                            let userDict = snapshot.value as! [String:Any]
                            
                            let post = Post()
                            post.setPictureURL(pictureURL: (postDict["imageURL"] as! String))
                            post.setContents(contents: (postDict["contents"] as! String))
                            post.setLikes(likes: (postDict["likes"] as! Int))
//                            post.setRepry(repry: (postDict["repry"] as! [String]))
                            
                            if let repryData  = postDict["repry"]{
                                let repry = repryData as! Dictionary<String, Any>
                                
                                for key in repry.keys{
                                    post.setRepryData(repryData: repry[key] as! Dictionary<String, String>)
                                }
//                                print((postDict["repry"] as! Dictionary<>))
                            }
                            
                            post.setStar(star: (postDict["star"] as! Int))
                            post.setUserName(userName: (userDict["name"] as! String))
                            post.setIconURL(iconURL: (userDict["iconURL"] as! String))
                            post.setUUID(uuid: friendID)
                            post.setGroupName(groupName:friendGroupName)
                            post.setAutoID(autoID: (child as! DataSnapshot).key)
                            post.setTime(time: self.dateManeger.dateFromString(string: (postDict["time"] as! String)))
                            print((child as! DataSnapshot).key)
                            self.postArray.append(post)
                            self.reload()
                            ref.child(friendID).child("userData").removeObserver(withHandle: self.postHandler)
                        })
                        
                    }
                    
                    ref.child(friendID).child("post").child(friendGroupName).removeObserver(withHandle: self.friendHandler)
                    
                })
            }
            ref.child(Util.getUUID()).child("userData").child("follow").removeObserver(withHandle: self.followHandler)
        })
    }
    
    func reload(){
        postArray = postArray.sorted(by: { (a, b) -> Bool in
            return a.getTime() > b.getTime()
        })
        self.timeLineTableView.reloadData()
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        postArray.removeAll()
        getUserContents()
        refreshCtl.endRefreshing()
    }
    
}

extension TimeLineViewController: UITableViewDataSource,UITableViewDelegate {
    //cellの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    //cellの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = timeLineTableView.dequeueReusableCell(withIdentifier: "friendPostTableViewCell", for: indexPath) as! FriendPostTableViewCell
        if indexPath.row < postArray.count{
            let post = postArray[indexPath.row]
            cell.setPostModel(post: post)
            cell.setheartImage(imageName: "pinkhearts.png")
            cell.setIndex(indexData: indexPath.row)
            cell.makeCorner()
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
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
    
    func toMyPost() {
        let elDrawer = self.navigationController?.parent as! KYDrawerController
        elDrawer.setDrawerState(KYDrawerController.DrawerState.closed, animated: true)
        performSegue(withIdentifier: "toPostViewController", sender: nil)
    }
    
    func toFriend() {
        let elDrawer = self.navigationController?.parent as! KYDrawerController
        elDrawer.setDrawerState(KYDrawerController.DrawerState.closed, animated: true)
        performSegue(withIdentifier: "toFriendListViewController", sender: nil)
    }
    
    
}
