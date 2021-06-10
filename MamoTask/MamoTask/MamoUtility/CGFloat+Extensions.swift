//
//  CGFloat+Extensions.swift
//  
//

//

// swiftlint:disable all

import UIKit

// MARK: - Integer

public extension IntegerLiteralType {

    var f: CGFloat {
        return CGFloat(self)
    }

}

// MARK: - Float

public extension FloatLiteralType {

    var f: CGFloat {
        return CGFloat(self)
    }

}

public extension CGFloat {
        
    func toRadians() -> CGFloat {
        return (.pi * self) / 180.0
    }
    
    func radiansToDegrees() -> CGFloat {
        return (180.0 * self) / .pi
    }
}
