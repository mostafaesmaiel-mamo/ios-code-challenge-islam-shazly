//
//  ContactsRepositoryMock.swift
//  MamoTaskTests
//
//  Created by islam Elshazly on 11/06/2021.
//

import Foundation
@testable import MamoTask

final class ContactsListRepositoryMock: ContactsListRepository {
    
    var error: BackendError?
    var endPoint: EndPoint!
    
    enum EndPoint: String {
        case frequents
        case mamoAccounts
    }
    
    func fetchFrequentReceivers(completion: @escaping APIResultHandler<FrequentListDTO>) {
        if error != nil {
            completion(.failure(error!))
        } else {
            let data =  LocalJsonReader.loadJson(name: endPoint.rawValue, bundle: Bundle(for: ContactsListRepositoryMock.self))
            let decoder = JSONDecoder()
            let frequents = try! decoder.decode(FrequentListDTO.self, from: data)
            completion(.success(frequents))
        }
    }
    
    func fetchSearch(emails: [String], phones: [String], completion: @escaping APIResultHandler<MamoAccountListDTO>) {
        if error != nil {
            completion(.failure(error!))
        } else {
            let data =  LocalJsonReader.loadJson(name: endPoint.rawValue, bundle: Bundle(for: ContactsListRepositoryMock.self))
            let decoder = JSONDecoder()
            let mamo = try! decoder.decode(MamoAccountListDTO.self, from: data)
            completion(.success(mamo))
        }
    }
    
    
}
