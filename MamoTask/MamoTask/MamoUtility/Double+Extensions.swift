//
//  Double+Extensions.swift
//  
//

//

import Foundation

// MARK: - Time Transform

public extension Double {
    var milliseconds: TimeInterval { return self / 1000 }
    var seconds: TimeInterval { return self }
    var minutes: TimeInterval { return self * 60 }
    var hours: TimeInterval { return self * 3600 }
    var days: TimeInterval { return self * 3600 * 24 }
}

// MARK: - Transform

extension Double {

    public var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: self as NSNumber)!
    }

}
