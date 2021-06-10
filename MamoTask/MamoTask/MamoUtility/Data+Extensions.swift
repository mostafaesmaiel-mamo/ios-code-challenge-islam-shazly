//
//  Data+Extensions.swift
//  
//

//

import Foundation

// MARK: - Getter

public extension Data {
    
    var deviceToken: String {
        let token = reduce("", {$0 + String(format: "%02X", $1)})
        return token.uppercased()
    }
    
}
