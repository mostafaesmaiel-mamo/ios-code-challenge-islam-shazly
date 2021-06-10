//
//  ApiClient.swift
//  SampleTest
//
//

import Foundation
import Moya

public typealias APIEmptyResultHandler = (Result<Void, BackendError>) -> Void
public typealias APIResultHandler<T> = (Result<T, BackendError>) -> Void

// MARK: - APIService

public protocol ApiClient {
    typealias ApiClientCompletionHandler = (_ result: Result<Data, BackendError>) -> Void
    func execute(request: Endpoints, completionHandler: @escaping ApiClientCompletionHandler)
}

// MARK: - APIServiceImplementation

public final class ApiClientImplementation: ApiClient {
    
    // MARK: - Properties
    
    let provider: MoyaProvider<Endpoints>
    static public var token: String?
    static public var language = "en-US"
    
    // MARK: - Init
    
    public init(provider: MoyaProvider<Endpoints> = MoyaProvider<Endpoints>()) {
        self.provider = provider
    }
    
    // MARK: - API
    
    public func execute(request: Endpoints, completionHandler: @escaping ApiClientCompletionHandler) {
        
        provider.request(request) { result in
            
            switch result {
            case let .success(moyaResponse):
                
                let data = moyaResponse.data
                do {
                    let error = try JSONDecoder().decode(BackendError.self, from: data)
                    
                    if (moyaResponse.response?.statusCode ?? 200) >= 200 &&
                        (moyaResponse.response?.statusCode ?? 200) < 300 {
                        completionHandler(.success(data))
                    } else {
                        completionHandler(.failure(error))
                    }
                    
                } catch {
                    completionHandler(.success(data))
                }
                
            case let .failure(error):
                let fanniError = BackendError(error: error as NSError)
                completionHandler(.failure(fanniError))
            }
            
        }
    }
    
}
