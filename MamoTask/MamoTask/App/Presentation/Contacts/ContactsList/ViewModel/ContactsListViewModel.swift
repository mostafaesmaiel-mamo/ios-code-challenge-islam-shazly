//
//  ContactsPermisionViewModel.swift
//  Mamo
//
//

import Foundation
import Combine
import SwiftyContacts

protocol ContactsListViewModelType {
    
    var shouldShowPermissionButton: Published<Bool>.Publisher { get }
    var shouldShowContactsCollectionView: Published<Bool>.Publisher { get }
    var contactsListViewStateModel: PassthroughSubject<ContactListViewStateModel, Error> { get }
    var showContactDetails: PassthroughSubject<ContactViewStateModel, Error> { get }
    var contactSelected: PassthroughSubject<ContactViewStateModel, Error> { get }
    
    func pickContact()
    func headerViewModel(section: Int) -> HeaderViewStateModel
}

final class ContactsListViewModel: ContactsListViewModelType {
    
    var shouldShowPermissionButton: Published<Bool>.Publisher { $shouldShowPermissionButtonState }
    var shouldShowContactsCollectionView: Published<Bool>.Publisher { $shouldShowContactsCollectionViewState }
    var contactsListViewStateModel: PassthroughSubject<ContactListViewStateModel, Error>
    
    // MARK: - Properties
    
    @Published private(set) var shouldShowPermissionButtonState: Bool = false
    @Published private(set) var shouldShowContactsCollectionViewState: Bool = false
    @Published private var contactPermissionState = ContactPermission.none
    
    var showContactDetails: PassthroughSubject<ContactViewStateModel, Error>
    var contactSelected: PassthroughSubject<ContactViewStateModel, Error>
    private var contactListViewStateModel: ContactListViewStateModel = ContactListViewStateModel(frequentsReceiver: [],
                                                                                                 mamoAccounts: [],
                                                                                                 contacts: [])
    
    private var bindings = Set<AnyCancellable>()
    private var interactor: ContactListInteractable!
    
    init(interactor: ContactListInteractable) {
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
    
    func pickContact() {
        interactor.authorize()
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
    
    
    private func fetchContacts() {
        interactor.contactListSubject
            .receive(on: RunLoop.main)
            .mapError({ [weak self] error -> Error in
                self?.sendError(error: error)
                return error
            })
            .sink { _ in
            } receiveValue: { [weak self] contacts in
                guard let self = self else { return }
                
                self.contactListViewStateModel = ContactListViewStateModel(frequentsReceiver: [],
                                                                           mamoAccounts: [],
                                                                           contacts: [])
                self.contactListViewStateModel.convertContactPresentationToViewStateModel(presentationModel: contacts)
                self.contactsListViewStateModel.send(self.contactListViewStateModel)
            }.store(in: &bindings)
    }
    
    private func authorizationStatus() {
        interactor.contactPermissionPublisher.sink { [weak self] contactPermissionState in
            guard let self = self else { return }
            
            if contactPermissionState == .authorized {
                self.fetchContacts()
                self.shouldShowContactsCollectionViewState = true
                self.shouldShowPermissionButtonState = false
            } else {
                self.shouldShowContactsCollectionViewState = false
                self.shouldShowPermissionButtonState = true
            }
        }
        .store(in: &bindings)
    }
    
    private func sendError(error: Error) {
        self.contactsListViewStateModel.send(completion: .failure(error))
    }
}
