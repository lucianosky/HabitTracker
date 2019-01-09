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
    
    case helveticaLight18 = "hl18"
    case helveticaBold24 = "hb24"
    case helveticaBold20 = "hb20"
    
    var font: UIFont {
        
        let sizeNum = Double(rawValue.numbers) ?? 18
        let size = CGFloat(sizeNum)
        
        var type: String = "invalid"
        let name = String(rawValue[0..<1]) == "h" ? "Helvetica" : "invalid"
        
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
