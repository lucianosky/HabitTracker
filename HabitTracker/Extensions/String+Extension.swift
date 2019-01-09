//
//  String+Extension.swift
//  HabitTracker
//
//  Created by Luciano Sclovsky on 09/01/19.
//  Copyright © 2019 Luciano Sclovsky. All rights reserved.
//

import Foundation

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
