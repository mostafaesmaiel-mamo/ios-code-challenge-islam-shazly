//
//  Dictionary+Extensions.swift
//  
//

//

import Foundation

// MARK: - Helpers

public extension Dictionary {

    func has(key: Key) -> Bool {
        return index(forKey: key) != nil
    }

}

// MARK: - Transform

public extension Dictionary {

    func union(values: Dictionary...) -> Dictionary {
        var result = self
        values.forEach { dictionary in
            dictionary.forEach { key, value in
                result[key] = value
            }
        }
        return result
    }

    mutating func merge<K, V>(with dictionaries: [K: V]...) {
        dictionaries.forEach {
            for (key, value) in $0 {
                guard let value = value as? Value, let key = key as? Key else {
                    continue
                }

                self[key] = value
            }
        }
    }

}

public extension Dictionary where Key: Hashable {

    // MARK: - Operator: +

    static func + (lhs: Dictionary, rhs: Dictionary) -> Dictionary {
        return lhs.merging(rhs) { (_, new) in new }
    }

    static func + (lhs: Dictionary, rhs: Dictionary?) -> Dictionary {
        return lhs + (rhs ?? [:])
    }

    static func + (lhs: Dictionary?, rhs: Dictionary) -> Dictionary {
        return (lhs ?? [:]) + rhs
    }

    // MARK: - Operator: +=

    static func += (lhs: inout Dictionary, rhs: Dictionary?) {
        // swiftlint:disable shorthand_operator
        lhs = lhs + (rhs ?? [:])
        // swiftlint:enable shorthand_operator
    }

    // MARK: - Properties

    var entries: [(Key, Value)] {
        return reduce([], { (result, element) -> [(Key, Value)] in
            var result = result

            result.append(element)

            return result
        })
    }

    // MARK: - Methods

    @discardableResult mutating func updateValueRejectingNil(
        _ value: Value?,
        forKey key: Key
    ) -> Value? {
        guard let value = value else { return nil }

        return updateValue(value, forKey: key)
    }

}

// MARK: adopting Equatable
public func == <K, V>(lhs: [K: V]?, rhs: [K: V]?) -> Bool {
    guard let lhs = lhs else { return false }

    guard let rhs = rhs else { return false }

    return NSDictionary(dictionary: lhs).isEqual(to: rhs)
}

// MARK: - Equatable Transform

extension Dictionary where Value: Equatable {

    public func difference(with dictionaries: [Key: Value]...) -> [Key: Value] {
        var result = self
        dictionaries.forEach {
            for (key, value) in $0 {
                if result.has(key: key) && result[key] == value {
                    result[key] = nil
                }
            }
        }
        return result
    }

}
