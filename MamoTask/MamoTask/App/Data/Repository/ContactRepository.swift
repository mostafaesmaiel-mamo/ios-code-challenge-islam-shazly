//
//  ContactRepository.swift
//  Mamo
//
//

import Foundation

protocol ContactsListRepository {
    
    func fetchFrequentReceivers(completion: @escaping APIResultHandler<FrequentListDTO>)
    func fetchSearch(emails:[String], phones: [String], completion: @escaping APIResultHandler<MamoAccountsDTO>)
}

final class ContactsListRepositoryImplementation: ContactsListRepository {
    
    // MARK: - Properties
    
    let apiClient: ApiClient
    
    // MARK: - Init
    
    init(apiClient: ApiClient = ApiClientImplementation()) {
        self.apiClient = apiClient
    }
    
    // MARK: - API
    
    func fetchFrequentReceivers(completion: @escaping APIResultHandler<FrequentListDTO>) {
        self.apiClient.execute(request: .frequentReceivers) { result in
            
            switch result {
            case let .success(response):
                do {
                    let frequent = try FrequentListDTO.decode(from: response)
                    completion(.success(frequent))
                } catch {
                    completion(.failure(BackendError(error: error)))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchSearch(emails: [String], phones: [String], completion: @escaping APIResultHandler<MamoAccountsDTO>) {
        
        self.apiClient.execute(request: .searchAccounts(emails: emails, phones: phones)) { result in
            
            switch result {
            case let .success(response):
                do {
                    let accounts = try MamoAccountsDTO.decode(from: response)
                    completion(.success(accounts))
                } catch {
                    completion(.failure(BackendError(error: error)))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
