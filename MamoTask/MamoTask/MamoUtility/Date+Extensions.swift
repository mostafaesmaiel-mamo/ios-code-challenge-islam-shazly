//
//  Date+Extensions.swift
//  
//

//

import Foundation

// MARK: - IsIn

public extension Date {

    var isInFuture: Bool {
        return self > Date()
    }

    var isInPast: Bool {
        return self < Date()
    }

}
