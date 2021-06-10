//
//  URL+Extensions.swift
//  
//

//

// swiftlint:disable all

import Foundation

// MARK: - Query

public extension URL {
    
    var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self as URL, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else {
                return nil
        }
        
        var parameters = [String: String]()
        queryItems.forEach {
            parameters[$0.name] = $0.value
        }
        return parameters
    }
    
    func isSameWithURL(_ url: URL) -> Bool {
        if self == url {
            return true
        }
        if scheme?.lowercased() != url.scheme?.lowercased() {
            return false
        }
        if let host1 = host, let host2 = url.host {
            let whost1 = host1.hasPrefix("www.") ? host1 : "www." + host1
            let whost2 = host2.hasPrefix("www.") ? host2 : "www." + host2
            if whost1 != whost2 {
                return false
            }
        }
        let pathdelimiter = CharacterSet(charactersIn: "/")
        if path.lowercased().trimmingCharacters(in: pathdelimiter) != url.path.lowercased().trimmingCharacters(in: pathdelimiter) {
            return false
        }
        if (self as NSURL).port != (url as NSURL).port {
            return false
        }
        if query?.lowercased() != url.query?.lowercased() {
            return false
        }
        return true
    }
    
}
