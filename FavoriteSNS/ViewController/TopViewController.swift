//
//  TopViewController.swift
//  FavoriteSNS
//
//  Created by 原田摩利奈 on 2019/03/25.
//  Copyright © 2019 原田摩利奈. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class TopViewController: UIViewController  {
    
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var iconImageView: UIImageView!
    let userDefaults = UserDefaults.standard
    var selectedImage:UIImage!
    
    // インスタンス変数
    var DBRef:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameText.delegate = self
        //インスタンスを作成
        DBRef = Database.database().reference()
    }
    
    
    @IBAction func chooseIcon(_ sender: Any) {
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
    
    func uploadIcon(name: String,pic: UIImage){
        // strageの一番トップのReferenceを指定
        let storage = Storage.storage()
        // let storageRef = storage.reference(forURL: "gs://calender-4a2d3.appspot.com")
        let storageRef = storage.reference(forURL: "gs://favoritesns3.appspot.com/")
        
        //変数dataにpicをNSDataにしたものを指定
        if let data = Util.resizeImage(src: pic, max: 200).jpegData(compressionQuality: 0.8) {
            // トップReferenceの一つ下の固有IDの枝を指定
            let riversRef = storageRef.child(Util.getUUID()).child(String.getRandomStringWithLength(length: 60))
            // strageに画像をアップロード
            riversRef.putData(data, metadata: nil, completion: { metaData, error in
                
                let downloadURL: String = (metaData?.downloadURL()?.absoluteString)!
                let data = ["name": name,"iconURL": downloadURL] as [String : Any]
                let ref = Database.database().reference()
                ref.child(Util.getUUID()).child("userData").setValue(data)
            })
        }
    }
    
    @IBAction func startButton(_ sender: AnyObject) {
        uploadIcon(name: userNameText.text!, pic: iconImageView.image!)
        userDefaults.set(true, forKey: "isFirst")
        userDefaults.synchronize()
        //        // 一つ前のViewControllerに戻る
        //        navigationController?.popViewController(animated: true)
        performSegue(withIdentifier: "toMakeGroupViewController", sender: nil)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender:
        Any?) {
        if (segue.identifier == "toMakeGroupViewController") {
            let MakeGroupViewController = (segue.destination as?
                MakeGroupViewController)!
            MakeGroupViewController.userName = self.userNameText.text
            MakeGroupViewController.iconImage = self.iconImageView.image
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        userNameText.resignFirstResponder()
        return true
    }
    
}
extension TopViewController :UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension TopViewController : UIImagePickerControllerDelegate ,UINavigationControllerDelegate {
    
    // 写真を選んだ後に呼ばれる処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectedImage = info[.originalImage] as? UIImage
        // ビューに表示する
        self.iconImageView.image = selectedImage
        // 写真を選ぶビューを引っ込める
        self.dismiss(animated: true)
    }
}
