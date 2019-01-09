//
//  UILabel+Extension.swift
//  HabitTracker
//
//  Created by Luciano Sclovsky on 09/01/19.
//  Copyright © 2019 Luciano Sclovsky. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    convenience init(_ sfont: SFont, _ color: UIColor, _ text: String = "", _ tag: Int = 0) {
        self.init()
        self.text = text
        self.font = sfont.font
        self.textColor = color
        self.tag = tag
        accessibilityIdentifier = text
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}

