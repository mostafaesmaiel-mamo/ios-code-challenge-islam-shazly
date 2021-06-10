//
//  UIWindow+Extensions.swift
//  
//

//

import UIKit

public extension UIWindow {

    convenience init(viewController: UIViewController) {
        self.init(frame: UIScreen.main.bounds)
        self.rootViewController = viewController
        self.makeKeyAndVisible()
    }
}
