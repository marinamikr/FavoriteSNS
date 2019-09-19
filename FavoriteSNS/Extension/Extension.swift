//
//  Extension.swift
//  FavoriteSNS
//
//  Created by 原田摩利奈 on 2019/03/25.
//  Copyright © 2019 原田摩利奈. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    static func getRandomStringWithLength(length: Int) -> String {
        let alphabet = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let upperBound = UInt32(alphabet.characters.count)
        return String((0..<length).map { _ -> Character in
            //            return alphabet[alphabet.startIndex.advancedBy(Int(arc4random_uniform(upperBound)))]
            return alphabet[alphabet.index(alphabet.startIndex, offsetBy: Int(arc4random_uniform(upperBound)))]
        })
    }
}

extension UIImageView{
    //画像を非同期で読み込む
    func loadImage(urlString: String){
        let CACHE_SEC : TimeInterval = 5 * 60; //5分キャッシュ
        let req = URLRequest(url: NSURL(string:urlString)! as URL,
                             cachePolicy: .returnCacheDataElseLoad,
                             timeoutInterval: CACHE_SEC);
        let conf =  URLSessionConfiguration.default;
        let session = URLSession(configuration: conf, delegate: nil, delegateQueue: OperationQueue.main);
        session.dataTask(with: req, completionHandler:
            { (data, resp, err) in
                if((err) == nil){ //Success
                    let image = UIImage(data:data!)
                    self.image = image;
                    
                }else{ //Error
                    print("SimpleAsyncImageView:Error \(err?.localizedDescription)");
                }
        }).resume();
    }
    //画像を非同期で読み込む
    func loadImageCircle(urlString: String){
        let CACHE_SEC : TimeInterval = 5 * 60; //5分キャッシュ
        let req = URLRequest(url: NSURL(string:urlString)! as URL,
                             cachePolicy: .returnCacheDataElseLoad,
                             timeoutInterval: CACHE_SEC);
        let conf =  URLSessionConfiguration.default;
        let session = URLSession(configuration: conf, delegate: nil, delegateQueue: OperationQueue.main);
        session.dataTask(with: req, completionHandler:
            { (data, resp, err) in
                if((err) == nil){ //Success
                    let image = UIImage(data:data!)
                    
                    self.image = image?.maskCorner(radius: (image?.size.width)! / 2)
                    
                    
                }else{ //Error
                    print("SimpleAsyncImageView:Error \(err?.localizedDescription)");
                }
        }).resume();
    }
}

extension UIImage {
    
    func maskCorner(radius r: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        
        let rect = CGRect(origin:  CGPoint.zero, size: self.size)
        UIBezierPath(roundedRect: rect, cornerRadius: r).addClip()
        draw(in: rect)
        let clippedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return clippedImage
    }
    
}


enum UIBarButtonItemPotition {
    case right
    case left
}

extension UIBarButtonItem {
    
    /// UIBarButtonItemを使用する場合は基本的にこれを使ってね！
    /// 画面の右端、左端からそれぞれ6pt離れた位置にアイコンが表示されるよ!
    /// アイコンサイズは28pt固定になっているよ！適宜直してね！
    ///
    /// - Parameters:
    ///   - image: Bar Button Icon Image
    ///   - position: NavigationBarの右か左か
    ///   - target: Tapした時に呼ばれるTarget
    ///   - action: Tapした時に呼ばれるAction
    /// - Returns: UIBarButtonItem
    static func createBarButton(image: UIImage, position: UIBarButtonItemPotition, target: Any?, action: Selector) -> UIBarButtonItem {
        let button = ExpansionButton()
        if #available(iOS 11, *) {
            button.frame = CGRect(x: 0, y: 0, width: 40, height: 28)
            button.insets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        } else {
            button.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
            // UINavigationBarのButtonは余白が強制的に16入るので、そこからデザインに合わせて位置をずらしています
            switch position {
            case .left:
                // なんかiOS10でタップ領域鬼広いんだけどなんでだろ？
                // 左にずらす
                button.insets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: -4)
                button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
            case .right:
                // 右にずらす
                button.insets = UIEdgeInsets(top: 10, left: -4, bottom: 10, right: 0)
                button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
            }
        }
        button.setImage(image, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }
}


/// タップ領域を簡単に拡大、縮小できるUIButton
final class ExpansionButton: UIButton {
    
    @IBInspectable var top: CGFloat {
        get { return insets.top }
        set { insets.top = newValue }
    }
    @IBInspectable var left: CGFloat {
        get { return insets.left }
        set { insets.left = newValue }
    }
    @IBInspectable var bottom: CGFloat {
        get { return insets.bottom }
        set { insets.bottom = newValue }
    }
    @IBInspectable var right: CGFloat {
        get { return insets.right }
        set { insets.right = newValue }
    }
    
    var insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var rect = bounds
        rect.origin.x -= insets.left
        rect.origin.y -= insets.top
        rect.size.width += insets.left + insets.right
        rect.size.height += insets.top + insets.bottom
        
        return rect.contains(point)
    }
}
