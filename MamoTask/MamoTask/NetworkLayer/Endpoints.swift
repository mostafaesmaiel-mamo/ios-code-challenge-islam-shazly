//
//  Endpoints.swift
//
//

import Foundation
import Moya

// MARK: - Endpoints Enum

public enum Endpoints {
    case frequentReceivers
    case searchAccounts(emails: [String], phones: [String])

}

// MARK: - API

extension Endpoints: TargetType {
    
    public var baseURL: URL {
        
        return URL(string: C.baseURL)!
    }
    
    public var path: String {
        switch self {
        case .frequentReceivers:
            return C.frequentReceivers
            
        case .searchAccounts:
            return C.searchAccounts
            
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .frequentReceivers:
            return [:]
            
        case .searchAccounts(let emails, let phones):
            return ["emails" : emails,
                    "phones": phones]
            
        }
    }
    public var method: Moya.Method {
        switch self {
        case .frequentReceivers:
            return .get
            
        case .searchAccounts:
            return .post
        }
    }

    public var parameterEncoding: ParameterEncoding {
         if self.method == .post {
            return JSONEncoding.default
         } else {
            return URLEncoding.queryString
        }
    }
    
    public var task: Task {
        return .requestParameters(parameters: parameters!, encoding: parameterEncoding)
    }
    
    public var headers: [String: String]? {
        
        return ["Content-Type": "application/json"]
    }
    
    public var sampleData: Data { return Data() }
}
