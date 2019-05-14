//
//  QRViewController.swift
//  FavoriteSNS
//
//  Created by 原田摩利奈 on 2019/03/27.
//  Copyright © 2019 原田摩利奈. All rights reserved.
//

import UIKit

class QRViewController: UIViewController {
    
    @IBOutlet weak var qrImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qrImage.image = makeQRCodeImage(text: Util.getUUID())
        self.navigationItem.title = "MyQRコード"
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Mamelon", size: 20)]
    }
    
    
    
    func makeQRCodeImage(text:String) -> UIImage? {
        guard let ciFilter = CIFilter(name: "CIQRCodeGenerator") else {
            return nil
        }
        ciFilter.setDefaults()
        // QRコードを設定
        ciFilter.setValue(text.data(using: String.Encoding.utf8), forKey: "inputMessage")
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


}
