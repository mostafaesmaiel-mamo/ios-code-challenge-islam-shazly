//
//  ContactsRepositoryMock.swift
//  MamoTaskTests
//
//  Created by islam Elshazly on 11/06/2021.
//

import Foundation
@testable import MamoTask

final class ContactsListRepositoryMock: ContactsListRepositorable {
    
    var error: Error?
    let apiClient: APIClientMock
    
    enum EndPoint: String {
        case frequents
        case mamoAccounts
    }
    
    init(apiClient: APIClientMock) {
        self.apiClient = apiClient
    }
    
    func fetchFrequentReceivers(completion: @escaping APIResultHandler<FrequentListModel>) {
        if error != nil {
            completion(.failure(error!))
        } else {
            let data =  LocalJsonReader.loadJson(name: apiClient.endPoint.rawValue, bundle: Bundle(for: ContactsListRepositoryMock.self))
            let decoder = JSONDecoder()
            let frequents = try! decoder.decode(FrequentListModel.self, from: data)
            completion(.success(frequents))
        }
    }
    
    func fetchSearch(emails: [String], phones: [String], completion: @escaping APIResultHandler<MamoAccountListModel>) {
        if error != nil {
            completion(.failure(error!))
        } else {
            let data =  LocalJsonReader.loadJson(name: apiClient.endPoint.rawValue, bundle: Bundle(for: ContactsListRepositoryMock.self))
            let decoder = JSONDecoder()
            let mamo = try! decoder.decode(MamoAccountListModel.self, from: data)
            completion(.success(mamo))
        }
    }
}
