//
//  WeekTableViewCell.swift
//  HabitTracker
//
//  Created by Luciano Sclovsky on 07/01/19.
//  Copyright © 2019 Luciano Sclovsky. All rights reserved.
//

import UIKit

class WeekTableViewCell: UITableViewCell {
    
    let stack = UIStackView(.horizontal)
    var dayViews = [DayView]()

    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#file) \(#function) not implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        for i in 0...6 {
            let dayView = DayView()
            dayView.text = "\(i)"
            dayView.tag = i+1
            stack.addArrangedSubview(dayView)
            dayViews.append(dayView)
            
        }
        contentView.addSubview(stack)
        contentView.backgroundColor = .background
        
        let viewsDict = [
            "stack" : stack,
        ]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[stack]|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stack]|", options: [], metrics: nil, views: viewsDict))
    }
    
}



