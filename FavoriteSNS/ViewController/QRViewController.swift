//
//  QRViewController.swift
//  FavoriteSNS
//
//  Created by 原田摩利奈 on 2019/03/27.
//  Copyright © 2019 原田摩利奈. All rights reserved.
//

import UIKit
import Firebase

class QRViewController: UIViewController {
    
    // インスタンス変数
    var DBRef:DatabaseReference!
    
    @IBOutlet weak var qrImage: UIImageView!
    
    @IBOutlet weak var chooseGroupPickerView: UIPickerView!
    
    var groupArray: [String]! = []
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "QRcode"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.gray]
        //インスタンスを作成
        DBRef = Database.database().reference()
        getUserData()
        // ピッカー設定
        chooseGroupPickerView.delegate = self
        chooseGroupPickerView.dataSource = self
        chooseGroupPickerView.showsSelectionIndicator = true
        
//        qrImage.image = makeQRCodeImage(text: Util.getUUID())
//        self.navigationItem.title = "MyQRコード"
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Mamelon", size: 20)]
    }
    
    
    
    func makeQRCodeImage(text:String, group:String) -> UIImage? {
        guard let ciFilter = CIFilter(name: "CIQRCodeGenerator") else {
            return nil
        }
        ciFilter.setDefaults()
        let textData = text + "," + group
        // QRコードを設定
        ciFilter.setValue(textData.data(using: String.Encoding.utf8), forKey: "inputMessage")
        // 誤り訂正レベルを設定
        ciFilter.setValue("M", forKey: "inputCorrectionLevel")
        if let outputImage = ciFilter.outputImage {
            // 作成されたQRコードのイメージが小さいので拡大する
            let sizeTransform = CGAffineTransform(scaleX: 10, y: 10)
            let zoomedCiImage = outputImage.transformed(by: sizeTransform)
            return UIImage(ciImage: zoomedCiImage, scale: 1.0, orientation: .up)
        }
        return nil
    }
    
    func getUserData() {
        DBRef.child(Util.getUUID()).child("userData").child("group").observe(.value, with: {snapshot  in
            self.groupArray = snapshot.value as! [String]
            self.chooseGroupPickerView.reloadComponent(0)
           self.qrImage.image = self.makeQRCodeImage(text: Util.getUUID(), group: self.groupArray[0])
        })
    }
  

}

extension QRViewController : UIPickerViewDelegate, UIPickerViewDataSource {

    // ドラムロールの列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // ドラムロールの行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        return groupArray.count
    }

    // ドラムロールの各タイトル
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return groupArray[row]
    }
    
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        
        qrImage.image =  self.makeQRCodeImage(text: Util.getUUID(), group: self.groupArray[row])
        
    }

}
