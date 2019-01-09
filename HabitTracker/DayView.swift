//
//  DayView.swift
//  HabitTracker
//
//  Created by Luciano Sclovsky on 08/01/19.
//  Copyright © 2019 Luciano Sclovsky. All rights reserved.
//

import UIKit

enum DayState {
    case none
    case done
    case notDone
}

class DayView: UIView {
    
    var text: String = "0" {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var dayState: DayState = .none {
        didSet {
            self.setNeedsDisplay()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#file) \(#function) not implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let viewsDict = [
            "self" : self,
        ]

        backgroundColor = .background
        translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[self(40)]", options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[self(40)]", options: [], metrics: nil, views: viewsDict))
    }
    
    override func draw(_ rect: CGRect) {
        drawCircle()
        drawText()
    }
    
    private func drawCircle() {
        switch dayState {
        case .none:
            UIColor.background.setStroke()
            UIColor.background.setFill()
        case .done:
            UIColor.greenG.setStroke()
            UIColor.greenLighter.setFill()
        case .notDone:
            UIColor.yellowY.setStroke()
            UIColor.yellowLighter.setFill()
        }

        let rect = CGRect(x: 1, y: 1, width: bounds.size.width-2, height: bounds.height-2)
        let path = UIBezierPath(ovalIn: rect)
        path.lineWidth = 2
        path.stroke()
        path.fill()
    }
    
    private func drawText() {
        let color: UIColor
        switch dayState {
        case .none: color = .darkText
        case .done: color = .greenText
        case .notDone: color = .yellowText
        }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [NSAttributedString.Key : Any] = [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.systemFont(ofSize: 12.0),
            .foregroundColor: color
        ]
        let aStr = NSAttributedString(string: text, attributes: attributes)
        let aSize = aStr.size()
        let x = (bounds.size.width - 2 - aSize.width) / 2 + 1
        let y = (bounds.size.height - 2 - aSize.height) / 2 + 1
        let rect2 = CGRect(x: x, y: y, width: aSize.width, height: aSize.height)
        aStr.draw(in: rect2)
    }

}
