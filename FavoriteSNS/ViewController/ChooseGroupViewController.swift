//
//  ChooseGroupViewController.swift
//  FavoriteSNS
//
//  Created by 原田摩利奈 on 2019/05/14.
//  Copyright © 2019 原田摩利奈. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class ChooseGroupViewController: UIViewController {
    
    var DBRef:DatabaseReference!
    var uuid :String! = ""
    var groupName :String! = ""
    var userName:String!
    var userIconURL :String!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var groupNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DBRef = Database.database().reference()
        getUserData(uuid: uuid, groupName: groupName)
    }
    
    func getUserData(uuid: String, groupName: String) {
        DBRef.child(uuid).child("userData").observe(.value, with: {snapshot  in
            let postDict = snapshot.value as! [String : AnyObject]
            self.userName  = postDict["name"] as! String
            self.userIconURL = postDict["iconURL"] as! String
            self.reloadView(userName: self.userName, userIconURL: self.userIconURL, groupName: self.groupName)
        })
    }
    
    func reloadView(userName:String, userIconURL:String, groupName:String)  {
        self.userNameLabel.text = userName
        self.iconImage.loadImage(urlString: userIconURL)
        self.groupNameLabel.text = groupName
    }
    
    @IBAction func followButton(_ sender: Any) {
        let myData = ["uuid":uuid,"groupName": groupName] as [String : Any]
        let friendData = ["uuid":Util.getUUID(),"groupName": groupName] as [String : Any]
        DBRef.child(Util.getUUID()).child("userData").child("follow").childByAutoId().setValue(myData)
        DBRef.child(uuid).child("userData").child("follower").childByAutoId().setValue(friendData)
        navigationController?.popToRootViewController(animated: true)
    }
}
