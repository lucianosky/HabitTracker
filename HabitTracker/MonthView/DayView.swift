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
    
    var shrink: Bool = false {
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
        // color for inactive and none
        var newColor = UIColor.background
        if active {
            switch habitState {
            case .none: break
            case .done: newColor = .doneStroke
            case .notDone: newColor = .notDoneStroke
            }
        } else if isHeader {
            newColor = .headerBackground
        }
        newColor.setFill()
        newColor.setStroke()

        let lineWidth: CGFloat = 4.0
        let halfLineWidth = lineWidth / 2.0
        let rect = CGRect(x: halfLineWidth, y: halfLineWidth,
                          width: bounds.size.width - lineWidth,
                          height: bounds.height - lineWidth)
        let path = UIBezierPath(ovalIn: rect)
        path.lineWidth = lineWidth
        path.stroke()
        path.fill()
        
        var animations = [CABasicAnimation]()

        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = shrink ? 1.0 : 0.75
        animation.toValue = shrink ? 0.75 : 1.0
        animation.duration = 0.5
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animations.append(animation)

        // simultaneous, otherwise use beginTime
        let animation2 = CABasicAnimation(keyPath: "opacity")
        animation2.fromValue = shrink ? 1.0 : 0.2
        animation2.toValue = shrink ? 0.2 : 1.0
        animation2.duration = 0.5
        animation2.isRemovedOnCompletion = false
        animation2.fillMode = .forwards
        animations.append(animation2)
        
        let group = CAAnimationGroup()
        group.duration = 0.5
        group.repeatCount = 1
        group.animations = animations
        group.fillMode = .forwards
        group.isRemovedOnCompletion = false
        
        layer.add(group, forKey: nil)
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
            if isHeader {
                color = .inactiveText
            } else {
                color = .notMonthText
            }
        }

        let font = isHeader ? SFont.dayViewActive.font : (active ? SFont.dayViewActive.font : SFont.dayViewInactive.font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [NSAttributedString.Key : Any] = [
            .paragraphStyle: paragraphStyle,
            .font: font,
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
