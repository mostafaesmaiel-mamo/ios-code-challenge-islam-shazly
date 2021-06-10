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
        
        switch self {
        
        default:
            #if DEBUG
            return URL(string: C.staging)!
            #else
            return URL(string: C.production)!
            #endif
        }
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
        if self.method == .get {
            return URLEncoding.queryString
        } else if self.method == .post {
            return JSONEncoding.default
        } else if self.method == .patch {
            return JSONEncoding.default
        }
        return URLEncoding.default
    }
    
    public var task: Task {
        return .requestParameters(parameters: parameters!, encoding: parameterEncoding)
    }
    
    public var headers: [String: String]? {
        
        return ["Content-Type": "application/json",
                "accept-language": ApiClientImplementation.language]
    }
    
    public var sampleData: Data { return Data() }
}
