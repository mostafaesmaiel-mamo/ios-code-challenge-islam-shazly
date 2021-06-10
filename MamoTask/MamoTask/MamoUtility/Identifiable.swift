//
//  Identifiable.swift
//

import Foundation

// MARK: - Identifiable

public protocol Identifiable {
    static var identifier: String { get }
}

// MARK: - Identifiable Default implementation

public extension Identifiable {
    static var identifier: String {
        return String(describing: Self.self)
    }
}
