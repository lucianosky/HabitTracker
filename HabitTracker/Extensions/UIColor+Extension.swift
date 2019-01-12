//
//  UIColor+Extension.swift
//  HabitTracker
//
//  Created by Luciano Sclovsky on 08/01/19.
//  Copyright © 2019 Luciano Sclovsky. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    static let background = UIColor(netHex: 0xDFE4E8)
    static let inactiveText = UIColor(netHex: 0x919EAB)
    static let activeText = UIColor(netHex: 0x212B35)
    
    static let doneStroke = UIColor(netHex: 0x108043)
    static let doneFill = UIColor(netHex: 0x50B83C)
    static let doneText = UIColor(netHex: 0xE3F1DF)
    
    static let notDoneStroke = UIColor(netHex: 0xB70711)
    static let notDoneFill = UIColor(netHex: 0xED6447)
    static let notDoneText = UIColor(netHex: 0xFBEAE5)
}

