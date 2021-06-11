//
//  APIMock.swift
//  MamoTaskTests
//
//

import XCTest

@testable import MamoTask


final class APIClientMock: ApiClient {
    
    // MARK: - Properties
    
    var error: BackendError?
    var endPoint: EndPoint!
    
    enum EndPoint: String {
        case frequents
        case mamoAccounts
    }
    
    // MARK: - API
    
    
    func execute(request: Endpoints, completionHandler: @escaping ApiClientCompletionHandler) {
        
        if error != nil {
            completionHandler(.failure(error!))
        } else {
            let data =  LocalJsonReader.loadJson(name: endPoint.rawValue, bundle: Bundle(for: APIClientMock.self))
            completionHandler(.success(data))
        }
    }
}
