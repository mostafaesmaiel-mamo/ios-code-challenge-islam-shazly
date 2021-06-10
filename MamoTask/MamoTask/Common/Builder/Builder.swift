//
//  Builder.swift
//  Mamo
//
//  Created by islam Elshazly on 09/06/2021.
//

import Foundation

import UIKit

protocol Builder {
    associatedtype ViewType: UIViewController
    func build() -> ViewType
    func buildWithNavigationController() -> UINavigationController
}

extension Builder {
    func buildWithNavigationController() -> UINavigationController {
        return UINavigationController(rootViewController: build())
    }
}
