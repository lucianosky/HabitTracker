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
        //let font = UIFont(name: "Helvetica-Light", size: 18)!
        for i in 0...6 {
            //let button = UIButton(.helveticaLight18, .black, "\(i)", i+1)
            //stack.addArrangedSubview(button)
            let dayView = DayView()
            stack.addArrangedSubview(dayView)
            
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

extension UIButton {
    
    convenience init(_ sfont: SFont, _ color: UIColor, _ title: String = "", _ tag: Int = 0) {
        self.init(type: .custom)
        titleLabel?.font = sfont.font
        setTitle(title, for: .normal)
        setTitleColor(color, for: .normal)
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
        distribution  = .equalCentering
        alignment = .center
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}

extension String {

    // MARK: - Properties

    var numbers: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
    
    // MARK: - Subscripts
    
    subscript(range: Range<Int>) -> String {
        return self.substring(with: range)
    }

    // MARK: - Methods

    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }
    
    func substring(to: String) -> String {
        if let index = range(of: to) {
            return String(self[..<index.lowerBound])
        }
        return self
    }
    
    func limit(to: Int) -> String {
        if count > to {
            return String(self[..<index(startIndex, offsetBy: to)])
        }
        return self
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
    
}

enum SFont: String {
    
    case helveticaLight18 = "hl18"
    case helveticaBold24 = "hb24"
    case helveticaBold20 = "hb20"

    var font: UIFont {
        
        let sizeNum = Double(rawValue.numbers) ?? 18
        let size = CGFloat(sizeNum)
        
        var type: String = "invalid"
        let name = String(rawValue[0..<1]) == "h" ? "Helvetica" : "invalid"
        
        switch String(rawValue[1..<2]) {
        case "b":
            type = "Bold"
        case "l":
            type = "Light"
        case "m":
            type = "Medium"
        case "r":
            type = "Regular"
        case "x":
            type = "ExtraLight"
        default:
            break
        }
        
        return UIFont(name: "\(name)-\(type)", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
