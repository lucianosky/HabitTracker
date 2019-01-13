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

    // DARK THEME
    // TODO: Dracula Theme - Give credit
    static let background = UIColor(netHex: 0x282a36)
    static let backgroundXXX = UIColor(netHex: 0x44475a)

    static let inactiveText = UIColor(netHex: 0x8be9fd)
    static let notMonthText = UIColor(netHex: 0x6272a4)
    static let activeText = UIColor(netHex: 0x8be9fd)
    static let monthNameText = UIColor(netHex: 0x8be9fd)

    static let doneStroke = UIColor(netHex: 0x50fa7b)
    static let doneFill = UIColor(netHex: 0x50fa7b)
    static let doneText = UIColor(netHex: 0x282a36)

    static let notDoneStroke = UIColor(netHex: 0xff5555)
    static let notDoneFill = UIColor(netHex: 0xff5555)
    static let notDoneText = UIColor(netHex: 0x282a36)

    /*
    LIGHT THEME
     
    static let background = UIColor(netHex: 0xF4F6F8) // 0xDFE4E8)
    static let inactiveText = UIColor(netHex: 0x919EAB)
    static let activeText = UIColor(netHex: 0x212B35)
    
    static let doneStroke = UIColor(netHex: 0x33b679) //// 0x108043)
    static let doneFill = UIColor(netHex: 0xc2e9d7) //// 0xBBE5B3) // 0x50B83C)
    static let doneText = activeText // UIColor(netHex: 0x98b6a9) //// 0x414F3E) // 0xE3F1DF)
    
    static let notDoneStroke = UIColor(netHex: 0xd50000) //// 0xB70711)
    static let notDoneFill = UIColor(netHex: 0xf2b3b3) //// 0xED6447)
    static let notDoneText = activeText // UIColor(netHex: 0xa27c7d) //// // 0xFBEAE5)
    */
    
}

