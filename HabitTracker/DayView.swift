//
//  DayView.swift
//  HabitTracker
//
//  Created by Luciano Sclovsky on 08/01/19.
//  Copyright © 2019 Luciano Sclovsky. All rights reserved.
//

import UIKit

class DayView: UIView {
    
    var text: String = "0"

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
        let rect = CGRect(x: 1, y: 1, width: bounds.size.width-2, height: bounds.height-2)
        let path = UIBezierPath(ovalIn: rect)
        path.lineWidth = 2
        UIColor.yellowY.setFill()
        UIColor.yellowDark.setStroke()
        path.stroke()
        path.fill()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [NSAttributedString.Key : Any] = [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.systemFont(ofSize: 12.0),
            .foregroundColor: UIColor.blue,
            .backgroundColor: UIColor.green
        ]
        //let myText = "0"
        let aStr = NSAttributedString(string: text, attributes: attributes)
        let aSize = aStr.size()
        let x = (bounds.size.width - 2 - aSize.width) / 2 + 1
        let y = (bounds.size.height - 2 - aSize.height) / 2 + 1
        let rect2 = CGRect(x: x, y: y, width: aSize.width, height: aSize.height)
        aStr.draw(in: rect2)
        
    }

}
