//
//  UIView+Extension.swift
//  HabitTracker
//
//  Created by Luciano Sclovsky on 10/01/19.
//  Copyright © 2019 Luciano Sclovsky. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    @discardableResult func equalConstraints(_ attribute: [NSLayoutConstraint.Attribute], to: Any?, constant: CGFloat = 0, priority: UILayoutPriority = UILayoutPriority.required) -> [NSLayoutConstraint] {
        
        var arr: [NSLayoutConstraint] = []
        for att in attribute {
            
            arr.append(
                NSLayoutConstraint(
                    item: self,
                    attribute: att,
                    relatedBy: NSLayoutConstraint.Relation.equal,
                    toItem: to,
                    attribute: att,
                    multiplier: 1,
                    constant: constant)
                    .withPriority(priority))
        }
        
        if arr.isEmpty == false {
            
            NSLayoutConstraint.activate(arr)
        }
        return arr
    }
    
    @discardableResult func equalConstraint(_ from: NSLayoutConstraint.Attribute, to: Any?, attribute: NSLayoutConstraint.Attribute, constant: CGFloat = 0, priority: UILayoutPriority) -> NSLayoutConstraint {
        
        let cons = NSLayoutConstraint(
            item: self,
            attribute: from,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: to,
            attribute: attribute,
            multiplier: 1,
            constant: constant
            ).withPriority(priority)
        cons.isActive = true
        return cons
    }

    @discardableResult func activateConstraints(_ visualFormat: String, views: [String : Any], metrics: [String : Any]? = nil) -> [NSLayoutConstraint] {
        
        return NSLayoutConstraint.activate(visualFormat, views: views, metrics: metrics)
    }

}
