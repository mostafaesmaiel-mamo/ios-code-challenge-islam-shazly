//
//  CGRect+Extensions.swift
//  
//

//

// swiftlint:disable all

import UIKit

// MARK: - Getter & Setters

public extension CGRect {

    var x: CGFloat {
        get {
            return origin.x
        }
        
        set {
            origin.x = newValue
        }
    }

    var y: CGFloat {
        get {
            return origin.y
        }
        
        set {
            origin.y = newValue
        }
    }
    
    var width: CGFloat {
        get {
            return size.width
        }
        
        set {
            size.width = newValue
        }
    }
    
    var height: CGFloat {
        get {
            return size.height
        }
        
        set {
            size.height = newValue
        }
    }

}

// MARK: - Transform

public extension CGRect {

    func with(x: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func with(y: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }

    func with(width: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }

    func with(height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }

    func with(origin: CGPoint) -> CGRect {
        return CGRect(origin: origin, size: size)
    }

    func with(size: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }

}
