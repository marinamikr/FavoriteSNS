//
//  MakeContentsViewController.swift
//  FavoriteSNS
//
//  Created by 原田摩利奈 on 2019/03/26.
//  Copyright © 2019 原田摩利奈. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class MakeContentsViewController: UIViewController {
    
    @IBOutlet weak var contentsTextView: UITextView!
    
    @IBOutlet weak var pictureImageView: UIImageView!
    
    @IBOutlet weak var groupPickerView: UIPickerView!
    
    @IBOutlet weak var star1: UIImageView!
    
    @IBOutlet weak var star2: UIImageView!
    
    @IBOutlet weak var star3: UIImageView!
    
    @IBOutlet weak var star4: UIImageView!
    
    @IBOutlet weak var star5: UIImageView!
    
    
    var selectedImage:UIImage!
    
    var realm :Realm!
    var realmGroupNameArray:List<String>!
    var like = Int()
    var repry = String()
    var starIndex: Int = 0
    
    // インスタンス変数
    var DBRef:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentsTextView.delegate = self

        //インスタンスを作成
        DBRef = Database.database().reference()
        
        realm = try! Realm()
        realmGroupNameArray = realm.objects(User.self).first!.groupNameArray
        // ピッカー設定
        groupPickerView.delegate = self
        groupPickerView.dataSource = self
        groupPickerView.showsSelectionIndicator = true
        
        star1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MakeContentsViewController.imageViewTapped1(_:))))
        
        star2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MakeContentsViewController.imageViewTapped2(_:))))
        
        star3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MakeContentsViewController.imageViewTapped3(_:))))
        
        star4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MakeContentsViewController.imageViewTapped4(_:))))
        
        star5.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MakeContentsViewController.imageViewTapped5(_:))))
    }
    
    
    
    func uploadContents(text: String,pic: UIImage){
        // strageの一番トップのReferenceを指定
        let storage = Storage.storage()
        // let storageRef = storage.reference(forURL: "gs://calender-4a2d3.appspot.com")
        let storageRef = storage.reference(forURL: "gs://favoritesns3.appspot.com/")
        
        //変数dataにpicをNSDataにしたものを指定
        if let data = Util.resizeImage(src: pic, max: 500)?.jpegData(compressionQuality: 0.8) {
            // トップReferenceの一つ下の固有IDの枝を指定
            let riversRef = storageRef.child(Util.getUUID()).child(String.getRandomStringWithLength(length: 60))
            // strageに画像をアップロード
            riversRef.putData(data, metadata: nil, completion: { metaData, error in
                let downloadURL: String = (metaData?.downloadURL()?.absoluteString)!
                let data = ["contents": self.contentsTextView.text,"imageURL": downloadURL,"likes": self.like,"repry": self.repry,"star": self.starIndex] as [String : Any]
                let ref = Database.database().reference()
                
                ref.child(Util.getUUID()).child("post").child(self.realmGroupNameArray![self.groupPickerView.selectedRow(inComponent: 0)]).childByAutoId().setValue(data)
            })
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        uploadContents(text: contentsTextView.text, pic: pictureImageView.image!)
    }
    @IBAction func chooseButton(_ sender: Any) {
        // カメラロールが利用可能か？
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            // 写真を選ぶビュー
            let pickerView = UIImagePickerController()
            // 写真の選択元をカメラロールにする
            // 「.camera」にすればカメラを起動できる
            pickerView.sourceType = .photoLibrary
            // デリゲート
            pickerView.delegate = self
            // ビューに表示
            self.present(pickerView, animated: true)
        }
    }
    
  
}

extension MakeContentsViewController {
  
    @objc func imageViewTapped1(_ sender: UITapGestureRecognizer) {
        star1.image = UIImage(named: "pinkhearts.png")
        star2.image = UIImage(named: "star.jpg")
        star3.image = UIImage(named: "star.jpg")
        star4.image = UIImage(named: "star.jpg")
        star5.image = UIImage(named: "star.jpg")
        starIndex = 1
    }
    
    @objc func imageViewTapped2(_ sender: UITapGestureRecognizer) {
        star1.image = UIImage(named: "pinkhearts.png")
        star2.image = UIImage(named: "pinkhearts.png")
        star3.image = UIImage(named: "star.jpg")
        star4.image = UIImage(named: "star.jpg")
        star5.image = UIImage(named: "star.jpg")
        starIndex = 2
    }
    
    @objc func imageViewTapped3(_ sender: UITapGestureRecognizer) {
        star1.image = UIImage(named: "pinkhearts.png")
        star2.image = UIImage(named: "pinkhearts.png")
        star3.image = UIImage(named: "pinkhearts.png")
        star4.image = UIImage(named: "star.jpg")
        star5.image = UIImage(named: "star.jpg")
        starIndex = 3
    }
    
    @objc func imageViewTapped4(_ sender: UITapGestureRecognizer) {
        star1.image = UIImage(named: "pinkhearts.png")
        star2.image = UIImage(named: "pinkhearts.png")
        star3.image = UIImage(named: "pinkhearts.png")
        star4.image = UIImage(named: "pinkhearts.png")
        star5.image = UIImage(named: "star.jpg")
        starIndex = 4
    }
    
    @objc func imageViewTapped5(_ sender: UITapGestureRecognizer) {
        star1.image = UIImage(named: "pinkhearts.png")
        star2.image = UIImage(named: "pinkhearts.png")
        star3.image = UIImage(named: "pinkhearts.png")
        star4.image = UIImage(named: "pinkhearts.png")
        star5.image = UIImage(named: "pinkhearts.png")
        starIndex = 5
    }
    
}

extension MakeContentsViewController : UIImagePickerControllerDelegate ,UINavigationControllerDelegate {
    
    // 写真を選んだ後に呼ばれる処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectedImage = info[.originalImage] as! UIImage
        // ビューに表示する
        self.pictureImageView.image = selectedImage
        // 写真を選ぶビューを引っ込める
        self.dismiss(animated: true)
    }
}

extension MakeContentsViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    // ドラムロールの列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // ドラムロールの行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return realmGroupNameArray.count
    }
    
    // ドラムロールの各タイトル
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return realmGroupNameArray[row]
    }
    
}
extension MakeContentsViewController :UITextViewDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // hides text views
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        print("反応してる？")
        if (text == "\n") {
            //あなたのテキストフィールド
            contentsTextView.resignFirstResponder()
            return false
        }
        return true
    }
    
}
