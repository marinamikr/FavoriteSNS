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
    var DBRef:DatabaseReference!
    var postArray :Array<Post> = Array()
    var ref:DatabaseReference!
    var handler: UInt = 0
    var groupHandler: UInt = 0
    let realm = try! Realm()
    var uuid :String =  Util.getUUID()
    let dateManeger = DateManager()
    fileprivate let refreshCtl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "MyPost"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.gray]
        DBRef = Database.database().reference()
        postTableView.dataSource = self
        postTableView.delegate = self
        postTableView.refreshControl = refreshCtl
        refreshCtl.addTarget(self, action: #selector(PostViewController.refresh(sender:)), for: .valueChanged)
        self.postTableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "postTableViewCell")
        setUpSafeArea()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserContents()
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
        postTableView.frame = rect
    }
    
    func getUserContents(){
        postArray.removeAll()
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
                            if let repryData  = postDict["repry"]{
                                var tmpRepryData: Array<Dictionary<String, String>> = Array()
                                let repry = repryData as! Dictionary<String, Any>
                                for key in repry.keys{
                                    tmpRepryData.append(repry[key] as! Dictionary<String, String>)
                                }
                                let dateManeger = DateManager()
                                tmpRepryData = tmpRepryData.sorted(by: { (a, b) -> Bool in
                                    return dateManeger.dateFromString(string: a["time"]! ) < dateManeger.dateFromString(string: b["time"]! )
                                })
                                for repry in tmpRepryData{
                                    post.setRepryData(repryData: repry)
                                }
                            }
                            post.setStar(star: (postDict["star"] as! Int))
                            post.setUserName(userName: (userDict["name"] as! String))
                            post.setIconURL(iconURL: (userDict["iconURL"] as! String))
                            post.setTime(time: self.dateManeger.dateFromString(string: (postDict["time"] as! String)))
                            post.setUUID(uuid: self.uuid)
                            post.setGroupName(groupName: groupName)
                            post.setAutoID(autoID: (child as! DataSnapshot).key)
                            self.postArray.append(post)
                            self.reload()
                        })
                    }
                })
            }
        })
    }
    
    func reload(){
        postArray = postArray.sorted(by: { (a, b) -> Bool in
            return a.getTime() > b.getTime()
        })
        self.postTableView.reloadData()
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        postArray.removeAll()
        getUserContents()
        refreshCtl.endRefreshing()
    }
}
extension PostViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postTableView.dequeueReusableCell(withIdentifier: "postTableViewCell", for: indexPath) as! PostTableViewCell
        let post = postArray[indexPath.row]
        cell.setPostModel(post: post)
        cell.setContents(contentsData: post.getContents())
        cell.setImage(imageData: post.getPictureURL())
        cell.setUserName(nameData: post.getUserName())
        cell.setIconImage(iconURL: post.getIconURL())
        cell.setLikeLabel(likeData: post.getLikes())
        cell.setStarLabel(starData: post.getStar())
        if post.getRepryData().count != 0 {
            cell.setRepryTextView(repryData: post.getRepryData()[0]["repry"]!)
        }
        cell.makeCorner()
        cell.repryTableViewCellDelegate = self
        cell.setIndex(indexData: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 580
    }
}


extension PostViewController: RepryTableViewCellDelegate {
    func toDetail(postModel: Post, index: Int) {
        performSegue(withIdentifier: "toRepryViewController", sender: postArray[index])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRepryViewController" {
            let repryViewController = segue.destination as! RepryViewController
            repryViewController.postModel = sender as! Post
        }
    }
}
