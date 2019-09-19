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
import CropViewController

class TopViewController: UIViewController  {
    
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var iconImageView: UIImageView!
    var selectedImage:UIImage!
    var DBRef:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "アカウント作成"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.gray]
        userNameText.delegate = self
        DBRef = Database.database().reference()
    }
    
    
    @IBAction func chooseIcon(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerView = UIImagePickerController()
            pickerView.sourceType = .photoLibrary
            pickerView.delegate = self
            self.present(pickerView, animated: true)
        }
    }
    
    func uploadIcon(name: String,pic: UIImage){
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: "gs://favoritesns3.appspot.com/")
        if let data = Util.resizeImage(src: pic, max: 200).jpegData(compressionQuality: 0.8) {
            let riversRef = storageRef.child(Util.getUUID()).child(String.getRandomStringWithLength(length: 60))
            riversRef.putData(data, metadata: nil, completion: { metaData, error in
                let downloadURL: String = (metaData?.downloadURL()?.absoluteString)!
                let data = ["name": name,"iconURL": downloadURL] as [String : Any]
                let ref = Database.database().reference()
                ref.child(Util.getUUID()).child("userData").setValue(data)
            })
        }
    }
    
    @IBAction func startButton(_ sender: AnyObject) {
        if userNameText.text != "" && iconImageView.image != nil {
            uploadIcon(name: userNameText.text!, pic: iconImageView.image!)
            performSegue(withIdentifier: "toMakeGroupViewController", sender: nil)
        } else {
            makeAleart(title: "全て入力してください", message: "全て入力してください", okText: "OK")
        }
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
        userNameText.resignFirstResponder()
        return true
    }
    
    func makeAleart(title: String, message: String, okText: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okayButton = UIAlertAction(title: okText, style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okayButton)
        present(alert, animated: true, completion: nil)
    }
    
}
extension TopViewController :UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension TopViewController : UIImagePickerControllerDelegate ,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectedImage = info[.originalImage] as! UIImage
        let cropViewController = CropViewController(image: selectedImage)
        cropViewController.setAspectRatioPreset(.presetSquare, animated: true)
        cropViewController.delegate = self
        self.dismiss(animated: true)
        present(cropViewController,animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension TopViewController: CropViewControllerDelegate {
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        iconImageView.image = image
        cropViewController.dismiss(animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: nil)
    }
}


