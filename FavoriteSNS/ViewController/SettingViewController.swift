//
//  SettingViewController.swift
//  FavoriteSNS
//
//  Created by 原田摩利奈 on 2019/05/14.
//  Copyright © 2019 原田摩利奈. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var settingTableView: UITableView!
    var labelNameArray = ["グループ編集・追加", "フォロー、フォロワー一覧"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "setting"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.gray]
        settingTableView.dataSource = self
        settingTableView.delegate = self
        //Identifierを設定する
        self.settingTableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "customCell")
        setUpSafeArea()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    private func setUpSafeArea(){
        print("setting")
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
        settingTableView.frame = rect
        print(rect)
    }
    
    
    
    
}

extension SettingViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labelNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingTableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
        cell.setText(text: labelNameArray[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: "toAddGroupViewController", sender: nil)
        case 1:
            self.performSegue(withIdentifier: "toFriendList", sender: nil)
        default: break
            
        }
    }
}

