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
import CropViewController

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
    var groupNameArray: [String] = []
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
        DBRef.child(Util.getUUID()).child("userData").child("group").observe(.value, with: {snapshot  in
            self.groupNameArray = snapshot.value as! [String]
            self.groupPickerView.reloadAllComponents()
        })
        
        
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
    
    
    
    func uploadContents(){
        // strageの一番トップのReferenceを指定
        let storage = Storage.storage()
        // let storageRef = storage.reference(forURL: "gs://calender-4a2d3.appspot.com")
        let storageRef = storage.reference(forURL: "gs://favoritesns3.appspot.com/")
        
        //変数dataにpicをNSDataにしたものを指定
        if let data = Util.resizeImage(src: pictureImageView.image!, max: 500)?.jpegData(compressionQuality: 0.8) {
            // トップReferenceの一つ下の固有IDの枝を指定
            let riversRef = storageRef.child(Util.getUUID()).child(String.getRandomStringWithLength(length: 60))
            // strageに画像をアップロード
            riversRef.putData(data, metadata: nil, completion: { metaData, error in
                let downloadURL: String = (metaData?.downloadURL()?.absoluteString)!
                let dateManeger = DateManager()
                var time = dateManeger.stringFromDate(date: Date())
                let data = ["contents": self.contentsTextView.text,"imageURL": downloadURL,"likes": self.like,"repry": self.repry,"star": self.starIndex,"time": time] as [String : Any]
                let ref = Database.database().reference()
                ref.child(Util.getUUID()).child("post").child(self.groupNameArray[self.groupPickerView.selectedRow(inComponent: 0)]).childByAutoId().setValue(data)
                ref.child(Util.getUUID()).child("post").child(self.groupNameArray[self.groupPickerView.selectedRow(inComponent: 0)]).observe(.value, with: {snapshot  in
                    self.navigationController?.popToRootViewController(animated: true)
                })
            })
        }
    }
    func makeAleart(title: String, message: String, okText: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okayButton = UIAlertAction(title: okText, style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okayButton)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if self.starIndex >= 1 && self.contentsTextView.text != "" && self.pictureImageView.image != nil{
            uploadContents()
        }else{
            makeAleart(title: "全て入力してください", message: "おすすめ度を選択してください", okText: "OK")
        }
        
        
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
        star1.image = UIImage(named: "yellowStar.png")
        star2.image = UIImage(named: "star.png")
        star3.image = UIImage(named: "star.png")
        star4.image = UIImage(named: "star.png")
        star5.image = UIImage(named: "star.png")
        starIndex = 1
    }
    
    @objc func imageViewTapped2(_ sender: UITapGestureRecognizer) {
        star1.image = UIImage(named: "yellowStar.png")
        star2.image = UIImage(named: "yellowStar.png")
        star3.image = UIImage(named: "star.png")
        star4.image = UIImage(named: "star.png")
        star5.image = UIImage(named: "star.png")
        starIndex = 2
    }
    
    @objc func imageViewTapped3(_ sender: UITapGestureRecognizer) {
        star1.image = UIImage(named: "yellowStar.png")
        star2.image = UIImage(named: "yellowStar.png")
        star3.image = UIImage(named: "yellowStar.png")
        star4.image = UIImage(named: "star.png")
        star5.image = UIImage(named: "star.png")
        starIndex = 3
    }
    
    @objc func imageViewTapped4(_ sender: UITapGestureRecognizer) {
        star1.image = UIImage(named: "yellowStar.png")
        star2.image = UIImage(named: "yellowStar.png")
        star3.image = UIImage(named: "yellowStar.png")
        star4.image = UIImage(named: "yellowStar.png")
        star5.image = UIImage(named: "star.png")
        starIndex = 4
    }
    
    @objc func imageViewTapped5(_ sender: UITapGestureRecognizer) {
        star1.image = UIImage(named: "yellowStar.png")
        star2.image = UIImage(named: "yellowStar.png")
        star3.image = UIImage(named: "yellowStar.png")
        star4.image = UIImage(named: "yellowStar.png")
        star5.image = UIImage(named: "yellowStar.png")
        starIndex = 5
    }
    
}

extension MakeContentsViewController : UIImagePickerControllerDelegate ,UINavigationControllerDelegate {
    
    // 写真を選んだ後に呼ばれる処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectedImage = info[.originalImage] as! UIImage
        
        
        let cropViewController = CropViewController(image: selectedImage)
        cropViewController.delegate = self
        
        // 写真を選ぶビューを引っ込める
        self.dismiss(animated: true)
        present(cropViewController,animated: true, completion: nil)
        
    }
}

extension MakeContentsViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    // ドラムロールの列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // ドラムロールの行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return groupNameArray.count
    }
    
    // ドラムロールの各タイトル
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return groupNameArray[row]
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

extension MakeContentsViewController: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        //加工した画像が取得できる
        // ビューに表示する
        selectedImage = image
        self.pictureImageView.image = selectedImage
        cropViewController.dismiss(animated: true, completion: nil)
        
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        // キャンセル時
        cropViewController.dismiss(animated: true, completion: nil)
    }
}
