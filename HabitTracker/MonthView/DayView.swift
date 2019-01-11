//
//  DayView.swift
//  HabitTracker
//
//  Created by Luciano Sclovsky on 08/01/19.
//  Copyright © 2019 Luciano Sclovsky. All rights reserved.
//

import UIKit

// TODO - review
import RxSwift
import RxCocoa
import RxGesture

// TODO: move to view model
enum DayState {
    case inactive
    case none
    case done
    case notDone
}

class DayView: UIView {
    
    // TODO - review
    private let disposeBag = DisposeBag()
    
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
        
        activateConstraints("V:[self(40)]", views: viewsDict)
        activateConstraints("H:[self(40)]", views: viewsDict)

        // TODO: review
        self.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                switch self.dayState {
                case .inactive: break
                case .none: self.dayState = .done
                case .done: self.dayState = .notDone
                case .notDone: self.dayState = .none
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    override func draw(_ rect: CGRect) {
        drawCircle()
        drawText()
    }
    
    private func drawCircle() {
        switch dayState {
        case .inactive, .none:
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
        case .inactive: color = .inactiveText
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
        let attrStr = NSAttributedString(string: text, attributes: attributes)
        let attrSize = attrStr.size()
        let x = (bounds.size.width - 2 - attrSize.width) / 2 + 1
        let y = (bounds.size.height - 2 - attrSize.height) / 2 + 1
        let rect = CGRect(x: x, y: y, width: attrSize.width, height: attrSize.height)
        attrStr.draw(in: rect)
    }
    
}
