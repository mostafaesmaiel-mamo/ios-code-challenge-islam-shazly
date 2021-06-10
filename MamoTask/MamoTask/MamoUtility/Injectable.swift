//
//  Injectable.swift
//

import Foundation

public protocol Injectable {
    associatedtype T
    func inject(properties: T)
}
