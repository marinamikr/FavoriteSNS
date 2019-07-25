//
//  Post.swift
//  FavoriteSNS
//
//  Created by 原田摩利奈 on 2019/03/27.
//  Copyright © 2019 原田摩利奈. All rights reserved.
//

import Foundation

class Post: NSObject {
    private var pictureURL: String = ""
    private var contents: String = ""
    private var likes: Int = 0
    private var star: Int = 0
    private var userName: String = ""
    private var iconURL: String = ""
    private var uuid: String = ""
    private var groupName: String = ""
    private var autoID: String = ""
    private var time: Date = Date()
    private var repryData: Array<Dictionary<String, String>> = Array()
    
    func setPictureURL(pictureURL:String){
        self.pictureURL = pictureURL
    }
    
    func getPictureURL() -> String {
        return self.pictureURL
    }
    
    func setContents(contents: String){
        self.contents = contents
    }
    
    func getContents() -> String {
        return self.contents
    }
    
    func setLikes(likes: Int) {
        self.likes = likes
    }
    
    func getLikes() -> Int {
        return self.likes
    }
    
    func setStar(star: Int) {
        self.star = star
    }
    
    func getStar() -> Int {
        return self.star
    }
    
    func setUserName(userName: String) {
        self.userName = userName
    }
    
    func getUserName() -> String {
        return self.userName
    }
    
    func setIconURL(iconURL: String) {
        self.iconURL = iconURL
    }
    
    func getIconURL() -> String {
        return self.iconURL
    }
    
    func setUUID(uuid: String){
        self.uuid = uuid
    }
    
    func getUUID() -> String {
        return self.uuid
    }
    
    func setGroupName(groupName: String) {
        self.groupName = groupName
    }
    
    func getGroupName() -> String {
        return self.groupName
    }
    
    func setAutoID(autoID: String) {
        self.autoID = autoID
    }
    
    func getAutoID() -> String {
        return self.autoID
    }
    
    func setTime(time: Date) {
        self.time = time
    }
    
    func getTime() -> Date {
        return self.time
    }
    
    func addRepryData(repryData: Dictionary<String, String>) {
        self.repryData.append(repryData)
    }
    
    func getRepryData() -> Array<Dictionary<String, String>> {
        return self.repryData
    }
    
    func deletRepryData() {
        self.repryData.removeAll()
    }
}
