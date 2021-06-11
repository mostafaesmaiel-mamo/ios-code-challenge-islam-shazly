//
//  ContactsListInteractorTest.swift
//  MamoTaskTests
//
//  Created by islam Elshazly on 11/06/2021.
//

import XCTest
@testable import MamoTask
import Combine

class ContactsListInteractorTest: XCTestCase {
    
    // MARK: - Properties
    
    var interactor : ContactsListInteractor!
    var repository: ContactsListRepositoryMock!
    private var bindings = Set<AnyCancellable>()

    // MARK: - Life Cycle
    
    override func setUpWithError() throws {
        repository = ContactsListRepositoryMock()
        interactor = ContactsListInteractorImplementation(repository: repository)
    }

    override func tearDownWithError() throws {
        interactor = nil
        repository = nil
    }
    
    // MARK: - API Calls
    
    func test_FetchPresentationModel_ReturnValidList() {
        XCTAssertEqual(5, 5)
        interactor.contactPermission()
        interactor.authorizationStatus()
        interactor.contactsPresnetatoinLogic.sink { contactsPresentationModel in
            // conver to contactsViewaStateModel
            
        }.store(in: &bindings)
        
    }

}
