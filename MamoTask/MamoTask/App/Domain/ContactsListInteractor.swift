//
//  ContactsInteractor.swift
//  Mamo
//
//  Created by islam Elshazly on 08/06/2021.
//

import UIKit
import SwiftyContacts
import Combine

protocol ContactsListInteractor {
    
    var contactsPresnetatoinLogic: PassthroughSubject<ContactListPresentationModel, Error> { get }
    var contactPermissionLogic: Published<ContactPermissionState>.Publisher { get }
    func contactPickerLogic()
}

final class ContactsListInteractorImplementation: ContactsListInteractor {
    
    private typealias CotactPresentationHashMap = [String: ContactPresentationModel]
    private typealias ContactsDTO = (MamoAccountListDTO, FrequentListDTO)
    private typealias ContactsDTOHandler = (Result<ContactsDTO, Error>) -> Void
    
    // MARK: - Properties
    
    var contactsPresnetatoinLogic: PassthroughSubject<ContactListPresentationModel, Error>
    var contactPermissionLogic: Published<ContactPermissionState>.Publisher { $contactPermissionState }
    private var repository: ContactsListRepository!
    private var contactsManger: ContactsManger!
    @Published private(set) var contactPermissionState = ContactPermissionState.none
    
    // MARK: - Init
    
    init(repository: ContactsListRepository, contactsManger: ContactsManger) {
        self.repository = repository
        self.contactsManger = contactsManger
        contactsPresnetatoinLogic = PassthroughSubject<ContactListPresentationModel, Error>()
        contactPickerLogic()
    }
    
    func contactPickerLogic() {
        contactsManger.authorizationStatus { [weak self] status in
            switch status {
            case .authorized:
                self?.contactPermissionState = .authorized
                self?.fetchAllContacts()
            case .denied:
                self?.contactPermissionState = .denied
            case .none:
                self?.requestContactPermission()
            }
        }
    }
    
    
    
}
// MARK: - Private Methods

extension ContactsListInteractorImplementation {
    
    private func requestContactPermission() {
        contactsManger.requestContactPermission { [weak self] status in
            switch status {
            case .authorized:
                self?.contactPermissionState = .authorized
                self?.fetchAllContacts()
            case .denied, .none:
                self?.contactPermissionState = .denied
            }
        }
    }
    
    private func sendContactsPresentationList(contactsDTO: ContactsDTO, contactHashMap: CotactPresentationHashMap) {
        
        let mamoListDTo = contactsDTO.0
        let frequentListDTO = contactsDTO.1
        let mamoInfoTuple = self.mamoAccountList(
            mamoContanctsListDTO: mamoListDTo,
            contactsHashMap: contactHashMap
        )
        let mamoPresentationList = mamoInfoTuple.mamoList
        let mamoAccountshashMap = mamoInfoTuple.mamoAccounthashMap
        let contactshashMapWithOutMamo = mamoInfoTuple.contacthashMapWithoutMamo
        let frequentsPresentationList = self.frequentList(
            frequentsListDTO: frequentListDTO,
            mamoAccounthashMap: mamoAccountshashMap
        )
        let localContactPresentationList = self.localContactsList(contacthashMap: contactshashMapWithOutMamo)
        let contactsPresentationList = ContactListPresentationModel(
            frequentRecivers: frequentsPresentationList,
            mamoAccounts: mamoPresentationList,
            contacts: localContactPresentationList
        )
        self.contactsPresnetatoinLogic.send(contactsPresentationList)
    }
    
    private func fetchAllContacts() {
        contactsManger.fetchLocalContacts { result in
            switch result {
            case .success(let contacts):
                let tuple = self.contactsHashMap(contacts: contacts)
                let contactsHashMap = tuple.contactsHashMap
                let email = tuple.emails
                let phone = tuple.phones
                self.fetchMamoAccounts(emails: email, phones: phone) { result in
                    switch result {
                    case .success(let tuple):
                        self.sendContactsPresentationList(contactsDTO: tuple, contactHashMap: contactsHashMap)
                    case .failure(let error):
                        self.contactsPresnetatoinLogic.send(completion: .failure(error))
                    }
                }
            case .failure(let error):
                self.contactsPresnetatoinLogic.send(completion: .failure(error))
            }
        }
    }
    
    private func fetchMamoAccounts(
        emails: [String],
        phones: [String],
        completion: @escaping ContactsDTOHandler
    ) {
        
        var mamoContanctsListDTO: MamoAccountListDTO!
        var frequentsListDTO: FrequentListDTO!
        var error: Error?
        
        let group = DispatchGroup()
        
        group.enter()
        repository.fetchSearch(emails: emails, phones: phones) { result in
            switch result {
            case .success(let mamoAccounts):
                mamoContanctsListDTO = mamoAccounts
                group.leave()
            case .failure(let err):
                error = err
                group.leave()
            }
        }
        
        group.enter()
        repository.fetchFrequentReceivers { result in
            switch result {
            case .success(let list):
                frequentsListDTO = list
                group.leave()
            case .failure(let err):
                error = err
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            if error != nil {
                completion(.failure(error!))
            } else {
                completion(.success((mamoContanctsListDTO,frequentsListDTO)))
            }
        }
    }
    
    private func contactsHashMap(contacts: [CNContact]) -> (contactsHashMap: CotactPresentationHashMap, emails: [String], phones: [String]) {
        var contactsHashMap = CotactPresentationHashMap()
        var emails = [String]()
        var phones = [String]()
        
        for contact in contacts {
            for phone in contact.phoneNumbers {
                let mobile = phone.value.stringValue.formatMobileNumber()
                phones.append(mobile)
                contactsHashMap[mobile] = ContactPresentationModel(id: "", key: "phone", value: mobile, publicName: contact.givenName + " " + contact.familyName, dataImage: contact.imageData, isMamoAccount: false)
            }
            
            for email in contact.emailAddresses {
                let email = String(email.value).lowercased()
                emails.append(email)
                contactsHashMap[email] = ContactPresentationModel(id: "", key: "email", value: email.lowercased(), publicName: contact.givenName + " " + contact.familyName, dataImage: contact.imageData, isMamoAccount: false)
            }
        }
        
        return (contactsHashMap, emails, phones)
    }
    
    private func mamoAccountList(
        mamoContanctsListDTO: MamoAccountListDTO,
        contactsHashMap: CotactPresentationHashMap
    ) -> (mamoAccounthashMap: CotactPresentationHashMap,
          mamoList: [ContactPresentationModel],
          contacthashMapWithoutMamo: CotactPresentationHashMap) {
        
        var mamoAccountsPresentatoinModel = [ContactPresentationModel]()
        var mamoAccounthashMap = CotactPresentationHashMap()
        var contactsHashMap = contactsHashMap
        for mamo in mamoContanctsListDTO.mamoAccounts {
            
            if let contact = contactsHashMap[mamo.value.lowercased()] {
                contactsHashMap[mamo.value.lowercased()] = nil
                let contactPresentationModel = ContactPresentationModel(
                    id: mamo.id,
                    key: mamo.key,
                    value: mamo.value,
                    publicName: mamo.publicName != nil ? mamo.publicName: contact.publicName,
                    dataImage: contact.dataImage,
                    isMamoAccount: true)
                mamoAccountsPresentatoinModel.append(contactPresentationModel)
                mamoAccounthashMap[mamo.id] = contactPresentationModel
            }
        }
        
        return (mamoAccounthashMap, mamoAccountsPresentatoinModel, contactsHashMap)
    }
    
    private func frequentList(
        frequentsListDTO: FrequentListDTO,
        mamoAccounthashMap: CotactPresentationHashMap
    ) -> [ContactPresentationModel] {
        var frequentsPresentatioinModel = [ContactPresentationModel]()
        for frequent in frequentsListDTO.frequents {
            let contactPresentationModel: ContactPresentationModel
            
            if let mamo = mamoAccounthashMap[frequent.id] {
                contactPresentationModel = ContactPresentationModel(
                    id: mamo.id,
                    key: mamo.key,
                    value: mamo.value,
                    publicName: mamo.publicName,
                    dataImage: mamo.dataImage,
                    isMamoAccount: mamo.isMamoAccount
                )
            } else {
                contactPresentationModel = ContactPresentationModel(
                    id: frequent.id,
                    key: "",
                    value: "",
                    publicName: nil,
                    dataImage: nil,
                    isMamoAccount: false
                )
            }
            frequentsPresentatioinModel.append(contactPresentationModel)
        }
        
        return frequentsPresentatioinModel
    }
    
    private func localContactsList(contacthashMap: [String: ContactPresentationModel]) -> [ContactPresentationModel] {
        var contactsPresentatioinModel = [ContactPresentationModel]()
        
        for contact in contacthashMap.values {
            contactsPresentatioinModel.append(contact)
        }
        
        return contactsPresentatioinModel
    }
    
}
