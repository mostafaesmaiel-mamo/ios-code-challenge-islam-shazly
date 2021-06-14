//
//  Endpoints.swift
//
//

import Foundation
import Moya

// MARK: - Endpoints Enum
enum Endpoints {
    
    case frequentReceivers
    case searchAccounts(emails: [String], phones: [String])
}

// MARK: - API
extension Endpoints: TargetType {
    
    var baseURL: URL {
        
        return URL(string: Constant.baseURL)!
    }
    
    var path: String {
        switch self {
        case .frequentReceivers:
            return Constant.frequentReceivers
            
        case .searchAccounts:
            return Constant.searchAccounts
            
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
    var method: Moya.Method {
        switch self {
        case .frequentReceivers:
            return .get
            
        case .searchAccounts:
            return .post
        }
    }

    var parameterEncoding: ParameterEncoding {
         if method == .post {
            return JSONEncoding.default
         } else {
            return URLEncoding.queryString
        }
    }
    
    var task: Task {
        return .requestParameters(parameters: parameters!, encoding: parameterEncoding)
    }
    
    var headers: [String: String]? {
        
        return ["Content-Type": "application/json"]
    }
    
    public var sampleData: Data { return Data() }
}
