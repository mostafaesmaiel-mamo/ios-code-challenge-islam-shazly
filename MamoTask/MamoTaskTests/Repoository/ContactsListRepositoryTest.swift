//
//  ContactsListRepository.swift
//  MamoTaskTests
//
//  Created by islam Elshazly on 11/06/2021.
//

import XCTest

@testable import MamoTask

final class ContactsListRepositoryTest: XCTestCase {
    
    // MARK: - Properties
    
    var apiClient: APIClientMock!
    private var repository: ContactsListRepository!
    
    // MARK: - Life Cycle
    
    override func setUpWithError() throws {
        
        apiClient = APIClientMock()
        repository = ContactsListRepositoryImplementation(apiClient: apiClient)
    }

    override func tearDownWithError() throws {
        
        apiClient = nil
        repository = nil
    }
    
    // MARK: - API Calls
    
    func test_FetchFrequentWithCorrectData_ReturnValidFrequentList() {
        apiClient.endPoint = .frequents
        repository.fetchFrequentReceivers { result in
            switch result {
            case .success(let frequents):
                XCTAssertEqual(frequents.frequents.count, 5)
                XCTAssertEqual(frequents.frequents[0].id, "32")
                XCTAssertEqual(frequents.frequents[0].publicName, "Clara J.")
            case .failure:
                break
            }
        }
    }
    
    func test_FetchMamoAccountsWithCorrectData_ReturnValidMamoList() {
        apiClient.endPoint = .frequents
        repository.fetchSearch(emails: ["",""], phones: [""]) { result in
            switch result {
            case .success(let mamoAccounts):
                XCTAssertEqual(mamoAccounts.mamoAccounts.count, 11)
                XCTAssertEqual(mamoAccounts.mamoAccounts[0].id, "32")
                XCTAssertEqual(mamoAccounts.mamoAccounts[0].publicName, "Clara J.")
                XCTAssertEqual(mamoAccounts.mamoAccounts[0].key, "email")
                XCTAssertEqual(mamoAccounts.mamoAccounts[0].value, "Clara.J.Hamel@yahoo.com")                
            case .failure:
                break
            }
        }
    }

}
