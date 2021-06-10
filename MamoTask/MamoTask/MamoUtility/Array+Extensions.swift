//
//  Array+Extensions.swift
//  
//

//

import Foundation

// MARK: - Subscript

public extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// MARK: - Remove

public extension Array where Element: Equatable {

    mutating func removeDuplicates() {
        self = reduce([]) { $0.contains($1) ? $0 : $0 + [$1] }
    }

    func removedDuplicates() -> [Element] {
        return reduce([]) { $0.contains($1) ? $0 : $0 + [$1] }
    }

}

// MARK: - Index Getter

public extension Array where Element: Equatable {

    func indexes(of item: Element) -> [Int] {
        var indexes = [Int]()
        for index in 0 ..< count where self[index] == item {
            indexes.append(index)
        }
        return indexes
    }

}

// MARK: - Equatable Transform

public extension Array where Element: Equatable {

    func difference(with values: [Element]...) -> [Element] {
        var result = [Element]()
        elements: for element in self {
            for value in values {
                if value.contains(element) {
                    continue elements
                }
            }
            result.append(element)
        }
        return result
    }

    func intersection(for values: [Element]...) -> Array {
        var result = self
        var intersection = Array()

        for (index, value) in values.enumerated() {
            if index > 0 {
                result = intersection
                intersection = Array()
            }

            value.forEach {
                if result.contains($0) {
                    intersection.append($0)
                }
            }
        }
        return intersection
    }

    func union(values: [Element]...) -> Array {
        var result = self
        for array in values {
            for value in array {
                if !result.contains(value) {
                    result.append(value)
                }
            }
        }
        return result
    }

    func split(intoChunksOf chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            let endIndex = ($0.advanced(by: chunkSize) > self.count) ? self.count - $0 : chunkSize
            return Array(self[$0..<$0.advanced(by: endIndex)])
        }
    }

}
