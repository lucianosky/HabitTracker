//
//  UIFont+Extension.swift
//  HabitTracker
//
//  Created by Luciano Sclovsky on 09/01/19.
//  Copyright © 2019 Luciano Sclovsky. All rights reserved.
//

import Foundation
import UIKit

enum SFont: String {
    
    case dayViewActive = "hb16"
    case dayViewInactive = "hr16"
    case monthName = "hb24"
    
    var font: UIFont {
        
        let sizeNum = Double(rawValue.numbers) ?? 18
        let size = CGFloat(sizeNum)
        
        var type: String = "invalid"
        let name = String(rawValue[0..<1]) == "h" ? "AppleSDGothicNeo" : "invalid"
        
        switch String(rawValue[1..<2]) {
        case "b":
            type = "Bold"
        case "l":
            type = "Light"
        case "m":
            type = "Medium"
        case "r":
            type = "Regular"
        case "x":
            type = "ExtraLight"
        default:
            break
        }
        
        return UIFont(name: "\(name)-\(type)", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
