//
//  ApiClient.swift
//  SampleTest
//
//

import Foundation
import Moya

public typealias APIResultHandler<T> = (Result<T, Error>) -> Void

// MARK: - APIService
protocol ApiClient {
    
    typealias ApiClientCompletionHandler = (_ result: Result<Data, Error>) -> Void
    func execute(request: Endpoints, completionHandler: @escaping ApiClientCompletionHandler)
}

// MARK: - APIServiceImplementation
final class ApiClientImplementation: ApiClient {
    
    // MARK: - Properties
    let provider: MoyaProvider<Endpoints>
    
    // MARK: - Init
    public init(provider: MoyaProvider<Endpoints> = MoyaProvider<Endpoints>()) {
        self.provider = provider
    }
    
    // MARK: - API
    public func execute(request: Endpoints, completionHandler: @escaping ApiClientCompletionHandler) {
        
        provider.request(request) { result in
            
            switch result {
            case let .success(response):
                let data = response.data
                completionHandler(.success(data))
                
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }
}
