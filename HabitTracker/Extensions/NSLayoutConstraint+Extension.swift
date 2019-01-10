//
//  NSLayoutConstraint+Extension.swift
//  HabitTracker
//
//  Created by Luciano Sclovsky on 10/01/19.
//  Copyright © 2019 Luciano Sclovsky. All rights reserved.
//

import Foundation
import UIKit

extension NSLayoutConstraint {
    
    @discardableResult class func activate(_ visualFormat: String, views: [String : Any], metrics: [String : Any]? = nil) -> [NSLayoutConstraint] {
        
        let arr = visualFormat
            .split(separator: ";")
            .map { NSLayoutConstraint.constraints(String($0), views: views, metrics: metrics) }
            .flatMap{$0}
        
        NSLayoutConstraint.activate(arr)
        return arr
    }
    
    class func constraints(_ visualFormat: String, views: [String : Any], metrics: [String : Any]? = nil) -> [NSLayoutConstraint] {
        
        return visualFormat.split(separator: ";")
            .map {
                NSLayoutConstraint.constraints(withVisualFormat: String($0), options: [], metrics: metrics, views: views)
            }.flatMap{$0}
    }

    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {

        self.priority = priority
        return self
    }
    

}
