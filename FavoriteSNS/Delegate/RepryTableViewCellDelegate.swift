//
//  RepryTableViewCellDelegate.swift
//  FavoriteSNS
//
//  Created by 原田摩利奈 on 2019/07/25.
//  Copyright © 2019 原田摩利奈. All rights reserved.
//

import Foundation
protocol RepryTableViewCellDelegate {
    func toDetail(postModel: Post, index: Int)
}
