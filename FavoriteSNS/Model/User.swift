//
//  User.swift
//  FavoriteSNS
//
//  Created by 原田摩利奈 on 2019/03/26.
//  Copyright © 2019 原田摩利奈. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var userName: String = ""
    @objc dynamic var userIcon: Data!
    var groupNameArray: List<String> = List<String>()
}
