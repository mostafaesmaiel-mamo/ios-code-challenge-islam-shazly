//
//  ContactRepository.swift
//  Mamo
//
//

import Foundation


final class ContactsListRepository: ContactsListRepositorable {
    
    // MARK: - Properties
    let apiClient: ApiClient
    
    // MARK: - Init
    init(apiClient: ApiClient = ApiClientImplementation()) {
        self.apiClient = apiClient
    }
    
    // MARK: - API
    func fetchFrequentReceivers(completion: @escaping FrequentReceiverHandler) {
        apiClient.execute(request: .frequentReceivers) { result in
            switch result {
            case let .success(response):
                do {
                    let frequent = try FrequentListModel.decode(from: response)
                    completion(.success(frequent))
                } catch {
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchSearch(emails: [String], phones: [String], completion: @escaping MamoAccountsHandler) {
        apiClient.execute(request: .searchAccounts(emails: emails, phones: phones)) { result in
            switch result {
            case let .success(response):
                do {
                    let accounts = try MamoAccountListModel.decode(from: response)
                    completion(.success(accounts))
                } catch {
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
