//
//  UIStackView+Extension.swift
//  HabitTracker
//
//  Created by Luciano Sclovsky on 09/01/19.
//  Copyright © 2019 Luciano Sclovsky. All rights reserved.
//

import Foundation
import UIKit

extension UIStackView {
    
    convenience init(_ axis: NSLayoutConstraint.Axis) {
        self.init()
        self.axis = axis
        distribution  = .equalCentering
        alignment = .center
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}

