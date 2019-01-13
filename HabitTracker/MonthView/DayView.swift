//
//  DayView.swift
//  HabitTracker
//
//  Created by Luciano Sclovsky on 08/01/19.
//  Copyright © 2019 Luciano Sclovsky. All rights reserved.
//

import UIKit

class DayView: UIView {
    
    private let diameter = 42
    
    var text: String = "0" {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var habitState: HabitState = .none {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var active: Bool = true {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var date: Date?
    
    var isHeader = false

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
        
        activateConstraints("V:[self(\(diameter))]", views: viewsDict)
        activateConstraints("H:[self(\(diameter))]", views: viewsDict)
    }
    
    override func draw(_ rect: CGRect) {
        drawCircle()
        drawText()
    }
    
    private func drawCircle() {
        // colors for inactive and none
        UIColor.background.setStroke()
        UIColor.background.setFill()
        if active {
            switch habitState {
            case .none: break
            case .done:
                UIColor.doneStroke.setStroke()
                UIColor.doneFill.setFill()
            case .notDone:
                UIColor.notDoneStroke.setStroke()
                UIColor.notDoneFill.setFill()
            }
        }

        let lineWidth: CGFloat = 4.0
        let halfLineWidth = lineWidth / 2.0
        let rect = CGRect(x: halfLineWidth, y: halfLineWidth,
                          width: bounds.size.width - lineWidth,
                          height: bounds.height - lineWidth)
        let path = UIBezierPath(ovalIn: rect)
        path.lineWidth = lineWidth
        path.stroke()
        path.fill()
        
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = 0.0
        fadeAnimation.toValue = 1.0
        fadeAnimation.duration = 0.8
        fadeAnimation.repeatCount = 1
        
        layer.opacity = 1.0
        layer.add(fadeAnimation, forKey: "FadeAnimation")
    }
    
    private func drawText() {
        let color: UIColor
        if active {
            switch habitState {
            case .none: color = .activeText
            case .done: color = .doneText
            case .notDone: color = .notDoneText
            }
        } else {
            color = .inactiveText
        }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [NSAttributedString.Key : Any] = [
            .paragraphStyle: paragraphStyle,
            .font: active ? SFont.dayViewActive.font : SFont.dayViewInactive.font,
            .foregroundColor: color
        ]
        let attrStr = NSAttributedString(string: text, attributes: attributes)
        let attrSize = attrStr.size()
        let x = (bounds.size.width - 2 - attrSize.width) / 2 + 1
        let y = (bounds.size.height - 2 - attrSize.height) / 2 + 1
        let rect = CGRect(x: x, y: y, width: attrSize.width, height: attrSize.height)
        attrStr.draw(in: rect)
    }
    
}
