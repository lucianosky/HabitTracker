//
//  UIButton+Extension.swift
//  HabitTracker
//
//  Created by Luciano Sclovsky on 09/01/19.
//  Copyright © 2019 Luciano Sclovsky. All rights reserved.
//

import Foundation
import UIKit

// TODO: not in use in this moment 
extension UIButton {
    
    convenience init(_ sfont: SFont, _ color: UIColor, _ title: String = "", _ tag: Int = 0) {
        self.init(type: .custom)
        titleLabel?.font = sfont.font
        setTitle(title, for: .normal)
        setTitleColor(color, for: .normal)
        setTitleColor(.red, for: .selected)
        accessibilityIdentifier = title
        translatesAutoresizingMaskIntoConstraints = false
        self.tag = tag
    }
    
}

