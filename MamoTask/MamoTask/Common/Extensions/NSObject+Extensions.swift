//
//  NSObject+Extensions.swift
//  
//

//

import Foundation

// MARK: - Getter

extension NSObject {

    public static var className: String {
        return String(describing: self)
    }

}
