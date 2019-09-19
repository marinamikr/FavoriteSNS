//
//  Util.swift
//  FavoriteSNS
//
//  Created by 原田摩利奈 on 2019/03/25.
//  Copyright © 2019 原田摩利奈. All rights reserved.
//
import UIKit
import RealmSwift
import UserNotifications
import FirebaseDatabase
import FirebaseStorage
import Firebase

class Util: NSObject {
    
    static var isObserving  = false
    static var likesDictionary : [String:Int] = [:]
    
    static func  printLog(viewC : Any ,tag : String, contents:Any){
        print(String(describing: viewC.self) + "【" + tag + "】", terminator: "")
        print(contents)
    }
    
    static func printErrorLog(viewC : Any ){
        printLog(viewC: viewC.self, tag: "error", contents: "Error")
    }
    
    /// イメージのサイズを変更
    static func resizeImage(src: UIImage!,max:Int) -> UIImage! {
        
        var resizedSize : CGSize!
        let maxLongSide : CGFloat = CGFloat(max)
        let ss = src.size
        if maxLongSide == 0 || ( ss.width <= maxLongSide && ss.height <= maxLongSide ) {
            resizedSize = ss
            return src
        }
        let ax = ss.width / maxLongSide
        let ay = ss.height / maxLongSide
        let ar = ax > ay ? ax : ay
        let re = CGRect(x: 0, y: 0, width: ss.width / ar, height: ss.height / ar)
        UIGraphicsBeginImageContext(re.size)
        src.draw(in: re)
        let dst = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        resizedSize = dst?.size
        return dst!
    }
    
    static func getUUID() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    //画像を非同期で読み込む
    static func loadImageCircle(urlString: String,completion:@escaping (UIImage) -> Void){
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
                    completion((image?.maskCorner(radius: (image?.size.width)! / 2))!)
                }else{ //Error
                    print("SimpleAsyncImageView:Error \(err?.localizedDescription)");
                }
        }).resume();
    }
}
