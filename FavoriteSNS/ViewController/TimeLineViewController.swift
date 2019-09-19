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
        (self.navigationController?.parent as? UITabBarController)?.delegate = self
        setUpNavigation()
        DBRef = Database.database().reference()
        userDefaults.register(defaults: ["isFirst":false])
        timeLineTableView.dataSource = self
        timeLineTableView.delegate = self
        timeLineTableView.refreshControl = refreshCtl
        refreshCtl.addTarget(self, action: #selector(TimeLineViewController.refresh(sender:)), for: .valueChanged)
        self.timeLineTableView.register(UINib(nibName: "FriendPostTableViewCell", bundle: nil), forCellReuseIdentifier: "friendPostTableViewCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let elDrawer = self.navigationController?.parent?.parent as! KYDrawerController
        (elDrawer.drawerViewController as! MenuItemViewController).dalegate = self
        isFirst = userDefaults.bool(forKey: "isFirst")
        if !isFirst {
            performSegue(withIdentifier: "toTopViewController",sender: nil)
        }else{
            getUserContents()
        }
        setUpSafeArea()
    }
    
    func setUpNavigation() {
        for familyName:String in UIFont.familyNames {
            print("Family Name: \(familyName)")
            for fontName:String in UIFont.fontNames(forFamilyName: familyName) {
                print("--Font Name: \(fontName)")
            }
        }
        self.navigationItem.title = "TimeLine"
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.gray,
             NSAttributedString.Key.font: UIFont(name: "azuki_font", size: 15)!]
    }
    
    private func setUpSafeArea(){
        var topPadding:CGFloat = 0
        var bottomPadding:CGFloat = 0
        var leftPadding:CGFloat = 0
        var rightPadding:CGFloat = 0
        let screenWidth:CGFloat = view.frame.size.width
        let screenHeight:CGFloat = view.frame.size.height
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows[0]
            topPadding = window.safeAreaInsets.top
            bottomPadding = window.safeAreaInsets.bottom
            leftPadding = window.safeAreaInsets.left
            rightPadding = window.safeAreaInsets.right
            print(topPadding)
        }
        topPadding = topPadding + (self.navigationController?.navigationBar.frame.size.height ?? 0)
        
        // portrait
        var safeAreaWidth = screenWidth - leftPadding - rightPadding
        var safeAreaHeight = (screenHeight) - topPadding - bottomPadding
        // landscape
        if(screenWidth > screenHeight){
            safeAreaWidth = screenWidth - leftPadding - rightPadding
            safeAreaHeight = (screenHeight) - topPadding - bottomPadding
        }
        
        let rect = CGRect(x: leftPadding,
                          y: topPadding,
                          width: safeAreaWidth,
                          height: safeAreaHeight)
        timeLineTableView.frame = rect
        print(rect)
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
                            if let repryData  = postDict["repry"]{
                                let repry = repryData as! Dictionary<String, Any>
                                for key in repry.keys{
                                    post.setRepryData(repryData: repry[key] as! Dictionary<String, String>)
                                }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = timeLineTableView.dequeueReusableCell(withIdentifier: "friendPostTableViewCell", for: indexPath) as! FriendPostTableViewCell
        if indexPath.row < postArray.count{
            let post = postArray[indexPath.row]
            cell.setPostModel(post: post)
            cell.setheartImage(imageName: "pinkhearts.png")
            cell.setIndex(indexData: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 580
    }
    
}
extension TimeLineViewController: CustomDelegate {
    
    func toCamera() {
        let vc = self.tabBarController!.viewControllers![4]
        self.tabBarController!.selectedViewController = vc
        let elDrawer = self.navigationController?.parent?.parent as! KYDrawerController
        elDrawer.setDrawerState(KYDrawerController.DrawerState.closed, animated: true)
    }
    
    func toQrcode() {
        let vc = self.tabBarController!.viewControllers![3]
        self.tabBarController!.selectedViewController = vc
        let elDrawer = self.navigationController?.parent?.parent as! KYDrawerController
        elDrawer.setDrawerState(KYDrawerController.DrawerState.closed, animated: true)
    }
    
    func toSetting() {
        let elDrawer = self.navigationController?.parent?.parent as! KYDrawerController
        elDrawer.setDrawerState(KYDrawerController.DrawerState.closed, animated: true)
        let vc = self.tabBarController!.viewControllers![0]
        self.tabBarController!.selectedViewController = vc
        performSegue(withIdentifier: "toSettingViewController", sender: nil)
    }
    
    func toMyPost() {
        let vc = self.tabBarController!.viewControllers![1]
        self.tabBarController!.selectedViewController = vc
        let elDrawer = self.navigationController?.parent?.parent as! KYDrawerController
        elDrawer.setDrawerState(KYDrawerController.DrawerState.closed, animated: true)
    }
    
    func toFriend() {
        let elDrawer = self.navigationController?.parent?.parent as! KYDrawerController
        elDrawer.setDrawerState(KYDrawerController.DrawerState.closed, animated: true)
        let vc = self.tabBarController!.viewControllers![0]
        self.tabBarController!.selectedViewController = vc
        performSegue(withIdentifier: "toFriendListViewController", sender: nil)
    }
}

extension TimeLineViewController:UITabBarControllerDelegate{
    // UITabBarDelegate
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    }
    
    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let vc = (viewController as! UINavigationController).visibleViewController!
        if vc.isKind(of: PostContentsViewController.classForCoder()) {
            let postContentsViewController :PostContentsViewController = vc as! PostContentsViewController
            if  postContentsViewController.postTextTableViewCell != nil {
                if postContentsViewController.postTextTableViewCell.pictureImageView.image == nil {
                    chooseImage(vc: postContentsViewController)
                }
            }else{
                chooseImage(vc: postContentsViewController)
            }
        }
    }
    
    func chooseImage(vc:PostContentsViewController)  {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerView = UIImagePickerController()
            pickerView.sourceType = .photoLibrary
            pickerView.delegate = vc
            self.present(pickerView, animated: true)
        }
    }
}
