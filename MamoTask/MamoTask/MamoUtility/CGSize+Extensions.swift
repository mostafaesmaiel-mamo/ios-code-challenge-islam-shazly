//
//  CGSize+Extensions.swift
//  
//

//

import UIKit

// MARK: - Operators

public extension CGSize {

    static func + (lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }

    static func - (lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }

    static func * (size: CGSize, scalar: CGFloat) -> CGSize {
        return CGSize(width: size.width * scalar, height: size.height * scalar)
    }

    static func += (lhs: inout CGSize, rhs: CGSize) {
        lhs = CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }

    static func -= (lhs: inout CGSize, rhs: CGSize) {
        lhs = CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }

    static func *= (size: inout CGSize, scalar: CGFloat) {
        size = CGSize(width: size.width * scalar, height: size.height * scalar)
    }

}
