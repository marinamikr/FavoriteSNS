//
//  Friend.swift
//  FavoriteSNS
//
//  Created by 原田摩利奈 on 2019/05/14.
//  Copyright © 2019 原田摩利奈. All rights reserved.
//

import Foundation
import RealmSwift

class Friend: Object {
    @objc dynamic var userName: String = ""
    @objc dynamic var userIconURL: String!
     @objc dynamic var uuid: String = ""
    var groupNameArray: List<String> = List<String>()
}

