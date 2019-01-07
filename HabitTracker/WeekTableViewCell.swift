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
    var buttons = [UIButton]()

    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#file) \(#function) not implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // TODO: optional
        let font = UIFont(name: "Helvetica-Light", size: 18)!
        for i in 0...6 {
            let button = UIButton(font, .black, "\(i)", i+1)
            stack.addArrangedSubview(button)
        }
        contentView.addSubview(stack)
        
        let viewsDict = [
            "stack" : stack,
        ]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[stack]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[stack]-|", options: [], metrics: nil, views: viewsDict))
    }
    
}

extension UIButton {
    
    convenience init(_ font: UIFont, _ color: UIColor, _ title: String = "", _ tag: Int = 0) {
        self.init(type: .custom)
        titleLabel?.font = font
        setTitle(title, for: .normal)
        setTitleColor(.black, for: .normal)
        setTitleColor(.red, for: .selected)
        accessibilityIdentifier = title
        translatesAutoresizingMaskIntoConstraints = false
        self.tag = tag
    }

}

extension UIStackView {
    
    convenience init(_ axis: NSLayoutConstraint.Axis) {
        self.init()
        self.axis = axis
        distribution  = .equalSpacing
        alignment = .center
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}

