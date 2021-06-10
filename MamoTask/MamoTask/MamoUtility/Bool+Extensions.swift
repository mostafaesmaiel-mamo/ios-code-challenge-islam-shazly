//
//  Bool+Extensions.swift
//  
//

//

import Foundation

public extension Bool {
    
    var toInt: Int { return self ? 1 : 0 }

    @discardableResult
    mutating func toggle() -> Bool {
        self = !self
        return self
    }
    
    var toggled: Bool {
        return !self
    }
}
