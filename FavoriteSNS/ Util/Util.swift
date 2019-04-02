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
        
        // リサイズが必要か？
        let ss = src.size
        if maxLongSide == 0 || ( ss.width <= maxLongSide && ss.height <= maxLongSide ) {
            resizedSize = ss
            return src
        }
        
        // TODO: リサイズ回りの処理を切りだし
        
        // リサイズ後のサイズを計算
        let ax = ss.width / maxLongSide
        let ay = ss.height / maxLongSide
        let ar = ax > ay ? ax : ay
        let re = CGRect(x: 0, y: 0, width: ss.width / ar, height: ss.height / ar)
        
        // リサイズ
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

}
