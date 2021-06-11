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
    var contactsViewModel: Published<ContactsViewStateModel>.Publisher { get }
    var showContactDetails: PassthroughSubject<ContactViewStateModel, Error> { get }
    var contactSelected: PassthroughSubject<ContactViewStateModel, Error> { get }
    
    func fetchContacts()
    func authorizationStatus()
}

final class ContactsListViewModelImplmentation: ContactsListViewModel {
    var shouldShowPermssionButton: Published<Bool>.Publisher { $shouldShowPermssionButtonState }
    var shouldShowContactsCollectionView: Published<Bool>.Publisher { $shouldShowContactsCollectionViewState }
    var contactsViewModel: Published<ContactsViewStateModel>.Publisher { $contactsStateViewModel }

    // MARK: - Properties
    
    @Published private(set) var shouldShowPermssionButtonState: Bool = false
    @Published private(set) var shouldShowContactsCollectionViewState: Bool = false
    @Published private var contactPermissionState = ContactPermissionState.none
    @Published private(set) var contactsStateViewModel = ContactsViewStateModel(frequentsReciver: [], mamoAccounts: [], contacts: [])
    
    var showContactDetails: PassthroughSubject<ContactViewStateModel, Error>
    var contactSelected: PassthroughSubject<ContactViewStateModel, Error>
    
    
    private var bindings = Set<AnyCancellable>()
    private var interactor: ContactsListInteractor!
    
    init(interactor: ContactsListInteractor) {
        self.interactor = interactor
        showContactDetails = PassthroughSubject<ContactViewStateModel, Error>()
        contactSelected = PassthroughSubject<ContactViewStateModel, Error>()
        self.authorizationStatus()
        contactSelected
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] contact in
                self?.contactsStateViewModel.getContactMatched(contact: contact)
            }
            .store(in: &bindings)
    }
    
    func fetchContacts() {
        interactor.contactsPresnetatoinLogic.sink { contactsPresentationModel in
            // conver to contactsViewStateModel
            self.contactsStateViewModel.convertContactPresentationToViewStateModel(presentationModel: contactsPresentationModel)
        }.store(in: &bindings)
        
        interactor.fetchContacts()
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
