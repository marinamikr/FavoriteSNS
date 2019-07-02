//
//  DateManager.swift
//  FavoriteSNS
//
//  Created by 原田摩利奈 on 2019/07/02.
//  Copyright © 2019 原田摩利奈. All rights reserved.
//

import Foundation
import UIKit
class DateManager{
    
    let format = "yyyy/MM/dd/HH/mm/ss"
    
    func dateFromString(string: String) -> Date {
        print(string)
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.date(from: string)!
    }
    
    func stringFromDate(date: Date) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}
