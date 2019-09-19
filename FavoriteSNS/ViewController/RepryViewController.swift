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
    
    var alert: UIAlertController!
    
    
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
        repryTextField.delegate = self
        //Identifierを設定する
        self.repryTableView.register(UINib(nibName: "RepryTableViewCell", bundle: nil), forCellReuseIdentifier: "repryTableViewCell")
        repryTableView.refreshControl = refreshCtl
        refreshCtl.addTarget(self, action: #selector(RepryViewController.refresh(sender:)), for: .valueChanged)
        DBRef = Database.database().reference()
        setUpSafeArea()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func sendRepryButton(_ sender: Any) {
        upLoadComment(comment: repryTextField.text!)
        repryTextField.text = ""
    }
    
    private func setUpSafeArea(){
        print("size")
        var topPadding:CGFloat = 0
        var bottomPadding:CGFloat = 0
        var leftPadding:CGFloat = 0
        var rightPadding:CGFloat = 0
        // 画面の横幅を取得
        // 以降、Landscape のみを想定
        let screenWidth:CGFloat = view.frame.size.width
        let screenHeight:CGFloat = view.frame.size.height
        // iPhone X , X以外は0となる
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            topPadding = window!.safeAreaInsets.top
            bottomPadding = window!.safeAreaInsets.bottom
            leftPadding = window!.safeAreaInsets.left + 16
            rightPadding = window!.safeAreaInsets.right + 16
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
        // frame をCGRectで作った矩形に合わせる
        repryTableView.frame = rect
        print(rect)
    }
    
    func upLoadComment(comment: String) {
        makeProgressDialog()
        let dateManeger = DateManager()
        var time = dateManeger.stringFromDate(date: Date())
        let data = ["uuid": Util.getUUID(),"repry": comment,"time":time] as [String : Any]
        DBRef.child(postModel.getUUID()).child("post").child(postModel.getGroupName()).child(postModel.getAutoID()).child("repry").childByAutoId().setValue(data)
        alert.dismiss(animated: true, completion: nil)
        getPostData()
        
        
    }
    
    func makeProgressDialog(){
        // インジケータ表示
        alert = UIAlertController(title: "投稿中...", message: "\n", preferredStyle: .alert)
        
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        alert.view.addSubview(indicator)
        
        let views: [String: UIView] = ["alert": alert.view, "indicator": indicator]
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[indicator]-(12)-|",
                                                         options: [],
                                                         metrics: nil,
                                                         views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[indicator]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: views)
        alert.view.addConstraints(constraints)
        
        indicator.isUserInteractionEnabled = false
        indicator.color = UIColor.lightGray
        indicator.startAnimating()
        
        present(alert, animated: true, completion: nil)
    }
    
    func getPostData() {
        print("hige")
        self.DBRef.child(postModel.getUUID()).child("post").child(postModel.getGroupName()).child(postModel.getAutoID()).child("repry").observe(.value, with: {snapshot  in
            
            
            var tmpRepryData: Array<Dictionary<String, String>> = Array()
            for child in snapshot.children {
                let repryDict = (child as! DataSnapshot).value as! Dictionary<String, String>
                print(repryDict)
                tmpRepryData.append(repryDict)
            }
            
            self.postModel.deletRepryData()
            
            let dateManeger = DateManager()
            tmpRepryData = tmpRepryData.sorted(by: { (a, b) -> Bool in
                return dateManeger.dateFromString(string: a["time"]! ) < dateManeger.dateFromString(string: b["time"]! )
            })
            for repry in tmpRepryData{
                self.postModel.setRepryData(repryData: repry)
            }
            
            self.repryTableView.reloadData()
            
            
        })
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        getPostData()
        self.refreshCtl.endRefreshing()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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

extension RepryViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        repryTextField.resignFirstResponder()
        return true
    }
}

