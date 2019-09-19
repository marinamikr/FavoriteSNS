//
//  PostContentsViewController.swift
//  FavoriteSNS
//
//  Created by 原田摩利奈 on 2019/07/16.
//  Copyright © 2019 原田摩利奈. All rights reserved.
//

import UIKit
import Firebase
import KYDrawerController
import CropViewController

class PostContentsViewController: UIViewController {
    
    @IBOutlet weak var postTableView: UITableView!
    var selectedImage:UIImage!
    var DBRef:DatabaseReference!
    var ref:DatabaseReference!
    var postTextTableViewCell:PostTextTableViewCell!
    var postLikeTableViewCell:PostLikeTableViewCell!
    var postGroupItemTableViewCellArray :[PostGroupItemTableViewCell] = []
    var starIndex: Int = 0
    var groupArray: [String]! = []
    var alert:UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "投稿"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.gray]
        DBRef = Database.database().reference()
        postTableView.dataSource = self
        postTableView.delegate = self
        getUserData()
        self.postTableView.register(UINib(nibName: "PostGroupItemTableViewCell", bundle: nil), forCellReuseIdentifier: "postGroupItemTableViewCell")
        self.postTableView.register(UINib(nibName: "PostChooseGroupTableViewCell", bundle: nil), forCellReuseIdentifier: "postChooseGroupTableViewCell")
        self.postTableView.register(UINib(nibName: "PostLikeTableViewCell", bundle: nil), forCellReuseIdentifier: "postLikeTableViewCell")
        self.postTableView.register(UINib(nibName: "PostTextTableViewCell", bundle: nil), forCellReuseIdentifier: "postTextTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func chooseImage()  {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerView = UIImagePickerController()
            pickerView.sourceType = .photoLibrary
            pickerView.delegate = self
            self.present(pickerView, animated: true)
        }
    }
    
    func getUserData() {
        DBRef.child(Util.getUUID()).child("userData").child("group").observe(.value, with: {snapshot  in
            self.groupArray = snapshot.value as! [String]
            self.postTableView.reloadData()
        })
    }
    
    func uploadContents(){
        makeProgressDialog()
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: "gs://favoritesns3.appspot.com/")
        if let data = Util.resizeImage(src: postTextTableViewCell.pictureImageView.image, max: 500)?.jpegData(compressionQuality: 0.8) {
            let riversRef = storageRef.child(Util.getUUID()).child(String.getRandomStringWithLength(length: 60))
            riversRef.putData(data, metadata: nil, completion: { metaData, error in
                let downloadURL: String = (metaData?.downloadURL()?.absoluteString)!
                let dateManeger = DateManager()
                var time = dateManeger.stringFromDate(date: Date())
                let data = ["contents": self.postTextTableViewCell.textView.text,"imageURL": downloadURL,"likes": 0,"star": self.starIndex,"time": time] as [String : Any]
                let ref = Database.database().reference()
                for postGroupItemTableViewCell in self.postGroupItemTableViewCellArray{
                    if postGroupItemTableViewCell.chooseGroupSwitch.isOn { ref.child(Util.getUUID()).child("post").child(postGroupItemTableViewCell.groupNameLabel.text!).childByAutoId().setValue(data)
                        self.alert.dismiss(animated: true, completion: nil)
                    }
                }
                self.postTextTableViewCell.pictureImageView.image = nil
                self.postTextTableViewCell.textView.text = ""
                let elDrawer = self.navigationController?.parent?.parent as! KYDrawerController
                elDrawer.setDrawerState(KYDrawerController.DrawerState.closed, animated: true)
                let vc = self.tabBarController!.viewControllers![0]
                self.tabBarController!.selectedViewController = vc
            })
        }
    }
    
    func makeProgressDialog(){
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
    
    func makeAleart(title: String, message: String, okText: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okayButton = UIAlertAction(title: okText, style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okayButton)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        var isGroopChoiced = false
        for cell in postGroupItemTableViewCellArray{
            if cell.chooseGroupSwitch.isOn{
                isGroopChoiced = true
            }
        }
        print(isGroopChoiced)
        if isGroopChoiced && self.starIndex >= 1 && self.postTextTableViewCell.textView.text != "" && self.postTextTableViewCell.pictureImageView.image != nil{
            uploadContents()
        } else if  self.starIndex == 0 && self.postTextTableViewCell.textView.text != "" && self.postTextTableViewCell.pictureImageView.image != nil{
            makeAleart(title: "全て入力してください", message: "おすすめ度を選択してください", okText: "OK")
        } else if  self.starIndex >= 1 && self.postTextTableViewCell.textView.text
            == "" && self.postTextTableViewCell.pictureImageView.image != nil{
            makeAleart(title: "全て入力してください", message: "文を入力してください", okText: "OK")
        }else if self.postTextTableViewCell.pictureImageView.image == nil{
            makeAleart(title: "全て入力してください", message: "画像を選択してください", okText: "OK")
        }else{
            makeAleart(title: "全て入力してください", message: "グループを選択してください", okText: "OK")
        }
    }
    
    @objc func pictureImageViewTapped(_ sender: UITapGestureRecognizer) {
        chooseImage()
    }
}

extension PostContentsViewController: UITableViewDataSource,UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupArray.count + 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        postGroupItemTableViewCellArray.removeAll()
        if indexPath.row == 0 {
            postTextTableViewCell = postTableView.dequeueReusableCell(withIdentifier: "postTextTableViewCell", for: indexPath) as! PostTextTableViewCell
            postTextTableViewCell.textView.delegate = self
            postTextTableViewCell.textView.layer.borderColor = UIColor.black.cgColor
            postTextTableViewCell.textView.layer.borderWidth = 1
            postTextTableViewCell.pictureImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PostContentsViewController.pictureImageViewTapped(_:))))
            if postTextTableViewCell.pictureImageView.image == nil {
                postTextTableViewCell.choosePictureLabel.isHidden = false
            } else {
                postTextTableViewCell.choosePictureLabel.isHidden = true
            }
            return postTextTableViewCell
        } else if  indexPath.row == 1{
            postLikeTableViewCell = postTableView.dequeueReusableCell(withIdentifier: "postLikeTableViewCell", for: indexPath) as! PostLikeTableViewCell
            postLikeTableViewCell.star1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PostContentsViewController.imageViewTapped1(_:))))
            postLikeTableViewCell.star2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PostContentsViewController.imageViewTapped2(_:))))
            postLikeTableViewCell.star3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PostContentsViewController.imageViewTapped3(_:))))
            postLikeTableViewCell.star4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PostContentsViewController.imageViewTapped4(_:))))
            postLikeTableViewCell.star5.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PostContentsViewController.imageViewTapped5(_:))))
            return postLikeTableViewCell
        } else if  indexPath.row == 2{
            let cell = postTableView.dequeueReusableCell(withIdentifier: "postChooseGroupTableViewCell", for: indexPath) as! PostChooseGroupTableViewCell
            return cell
        } else {
            let cell = postTableView.dequeueReusableCell(withIdentifier: "postGroupItemTableViewCell", for: indexPath) as! PostGroupItemTableViewCell
            cell.groupNameLabel.text = groupArray![indexPath.row - 3]
            postGroupItemTableViewCellArray.append(cell)
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 250
        }else if indexPath.row == 1 {
            return 50
        }else if indexPath.row == 2 {
            return 50
        }else{
            return 80
        }
    }
}

extension PostContentsViewController : UIImagePickerControllerDelegate ,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectedImage = info[.originalImage] as! UIImage
        postTableView.reloadData()
        let cropViewController = CropViewController(image: selectedImage)
        cropViewController.setAspectRatioPreset(.presetSquare, animated: true)
        cropViewController.delegate = self
        self.dismiss(animated: true)
        present(cropViewController,animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        postTableView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
}

extension PostContentsViewController: CropViewControllerDelegate {
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        postTextTableViewCell.pictureImageView.image = image
        postTableView.reloadData()
        cropViewController.dismiss(animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: nil)
        postTableView.reloadData()
    }
}


extension PostContentsViewController {
    
    @objc func imageViewTapped1(_ sender: UITapGestureRecognizer) {
        postLikeTableViewCell.star1.image = UIImage(named: "yellowStar.png")
        postLikeTableViewCell.star2.image = UIImage(named: "star.png")
        postLikeTableViewCell.star3.image = UIImage(named: "star.png")
        postLikeTableViewCell.star4.image = UIImage(named: "star.png")
        postLikeTableViewCell.star5.image = UIImage(named: "star.png")
        starIndex = 1
    }
    
    @objc func imageViewTapped2(_ sender: UITapGestureRecognizer) {
        postLikeTableViewCell.star1.image = UIImage(named: "yellowStar.png")
        postLikeTableViewCell.star2.image = UIImage(named: "yellowStar.png")
        postLikeTableViewCell.star3.image = UIImage(named: "star.png")
        postLikeTableViewCell.star4.image = UIImage(named: "star.png")
        postLikeTableViewCell.star5.image = UIImage(named: "star.png")
        starIndex = 2
    }
    
    @objc func imageViewTapped3(_ sender: UITapGestureRecognizer) {
        postLikeTableViewCell.star1.image = UIImage(named: "yellowStar.png")
        postLikeTableViewCell.star2.image = UIImage(named: "yellowStar.png")
        postLikeTableViewCell.star3.image = UIImage(named: "yellowStar.png")
        postLikeTableViewCell.star4.image = UIImage(named: "star.png")
        postLikeTableViewCell.star5.image = UIImage(named: "star.png")
        starIndex = 3
    }
    
    @objc func imageViewTapped4(_ sender: UITapGestureRecognizer) {
        postLikeTableViewCell.star1.image = UIImage(named: "yellowStar.png")
        postLikeTableViewCell.star2.image = UIImage(named: "yellowStar.png")
        postLikeTableViewCell.star3.image = UIImage(named: "yellowStar.png")
        postLikeTableViewCell.star4.image = UIImage(named: "yellowStar.png")
        postLikeTableViewCell.star5.image = UIImage(named: "star.png")
        starIndex = 4
    }
    
    @objc func imageViewTapped5(_ sender: UITapGestureRecognizer) {
        postLikeTableViewCell.star1.image = UIImage(named: "yellowStar.png")
        postLikeTableViewCell.star2.image = UIImage(named: "yellowStar.png")
        postLikeTableViewCell.star3.image = UIImage(named: "yellowStar.png")
        postLikeTableViewCell.star4.image = UIImage(named: "yellowStar.png")
        postLikeTableViewCell.star5.image = UIImage(named: "yellowStar.png")
        starIndex = 5
    }
}

extension PostContentsViewController :UITextViewDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            postTextTableViewCell.textView.resignFirstResponder()
            return false
        }
        return true
    }
}



