//
//  DayView.swift
//  HabitTracker
//
//  Created by Luciano Sclovsky on 08/01/19.
//  Copyright © 2019 Luciano Sclovsky. All rights reserved.
//

import UIKit

class DayView: UIView {

    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#file) \(#function) not implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let viewsDict = [
            "self" : self,
        ]

        backgroundColor = .yellowLighter
        translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[self(40)]", options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[self(40)]", options: [], metrics: nil, views: viewsDict))
    }

    override func draw(_ rect: CGRect) {
        // Drawing code
    }

}
