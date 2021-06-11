//
//  ContactsPermisionViewModel.swift
//  Mamo
//
//  Created by islam Elshazly on 03/06/2021.
//

import Foundation
import Combine
import SwiftyContacts


protocol ContactsListViewModel {
    var shouldShowPermssionButton: Published<Bool>.Publisher { get }
    var shouldShowContactsCollectionView: Published<Bool>.Publisher { get }
    var contactsListViewStateModel: PassthroughSubject<ContactListViewStateModel, Error> { get }
    var showContactDetails: PassthroughSubject<ContactViewStateModel, Error> { get }
    var contactSelected: PassthroughSubject<ContactViewStateModel, Error> { get }
    
    func contactPickerLogic()
}

final class ContactsListViewModelImplmentation: ContactsListViewModel {
    
    var shouldShowPermssionButton: Published<Bool>.Publisher { $shouldShowPermssionButtonState }
    var shouldShowContactsCollectionView: Published<Bool>.Publisher { $shouldShowContactsCollectionViewState }
    var contactsListViewStateModel: PassthroughSubject<ContactListViewStateModel, Error>

    // MARK: - Properties
    
    @Published private(set) var shouldShowPermssionButtonState: Bool = false
    @Published private(set) var shouldShowContactsCollectionViewState: Bool = false
    @Published private var contactPermissionState = ContactPermissionState.none
    
    var showContactDetails: PassthroughSubject<ContactViewStateModel, Error>
    var contactSelected: PassthroughSubject<ContactViewStateModel, Error>
    private var contactListViewStateModel: ContactListViewStateModel = ContactListViewStateModel(frequentsReciver: [],
                                                                                                 mamoAccounts: [],
                                                                                                 contacts: [])
    
    private var bindings = Set<AnyCancellable>()
    private var interactor: ContactsListInteractor!
    
    init(interactor: ContactsListInteractor) {
        self.interactor = interactor
        showContactDetails = PassthroughSubject<ContactViewStateModel, Error>()
        contactSelected = PassthroughSubject<ContactViewStateModel, Error>()
        contactsListViewStateModel = PassthroughSubject<ContactListViewStateModel, Error>()
        self.authorizationStatus()
        
        contactSelected
            .receive(on: RunLoop.main)
            .sink { _ in
            } receiveValue: { [weak self] contact in
                guard let self = self else { return }
                
                self.contactListViewStateModel.getContactMatched(contact: contact)
                self.contactsListViewStateModel.send(self.contactListViewStateModel)
            }.store(in: &bindings)
    }
    
    func fetchContacts() {
        interactor.contactsPresnetatoinLogic
            .receive(on: RunLoop.main)
            .mapError({ error -> Error in
                self.sendError(error: error)
                return error
            })
            .sink { _ in
            } receiveValue: { [weak self] contacts in
                guard let self = self else { return }
                
                self.contactListViewStateModel = ContactListViewStateModel(frequentsReciver: [], mamoAccounts: [], contacts: [])
                self.contactListViewStateModel.convertContactPresentationToViewStateModel(presentationModel: contacts)
                self.contactsListViewStateModel.send(self.contactListViewStateModel)
            }.store(in: &bindings)
    }
    
    func authorizationStatus() {
        interactor.contactPermissionLogic.sink { contactPermissionState in
            if contactPermissionState == .authorized {
                self.fetchContacts()
                self.shouldShowContactsCollectionViewState = true
                self.shouldShowPermssionButtonState = false
            } else {
                self.shouldShowContactsCollectionViewState = false
                self.shouldShowPermssionButtonState = true
            }
        }
    .store(in: &bindings)
    }
    
    func contactPickerLogic() {
        interactor.contactPickerLogic()
    }
    
    func sendError(error: Error) {
        
        self.contactsListViewStateModel.send(completion: .failure(error))
    }
    
    func headerViewModel(section: Int) -> HeaderViewStateModel {
        var headerStateModel: HeaderViewStateModel!
        
        switch section {
        case 0:
            headerStateModel = HeaderViewStateModel(title: "Frequents", shouldShowSeperatorr: true)
        case 1:
            headerStateModel = HeaderViewStateModel(title: "Your Friends on Momo", shouldShowSeperatorr: false)
        case 2:
            headerStateModel =  HeaderViewStateModel(title: "Your Contacts", shouldShowSeperatorr: true)
        default:
            return HeaderViewStateModel(title: "", shouldShowSeperatorr: false)
        }
        return headerStateModel
    }
    
}
