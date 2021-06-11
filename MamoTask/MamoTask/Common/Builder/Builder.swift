//
//  Builder.swift
//  Mamo
//
//

import Foundation

import UIKit

protocol Builder {
    associatedtype ViewType: UIViewController
    func build() -> ViewType
}
