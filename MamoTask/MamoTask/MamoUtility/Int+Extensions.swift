//
//  Int+Extensions.swift
//  
//

//

import Foundation

// MARK: - Misc

public extension Int {

    var isEven: Bool { isMultiple(of: 2) }
    var isOdd: Bool { !isEven }
    var isPositive: Bool { self > 0 }
    var isNegative: Bool { !isPositive }
    var range: Range<Int> { 0 ..< self }

    var digits: Int {
        if self == 0 { return 1 }
        return Int(log10(fabs(Double(self)))) + 1
    }

}

// MARK: - Transform

public extension Int {

    var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: self as NSNumber)!
    }

}
