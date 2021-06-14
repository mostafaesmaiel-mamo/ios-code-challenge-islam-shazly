//
//  ContactsInteractor.swift
//  Mamo
//
//

import UIKit
import SwiftyContacts
import Combine

fileprivate typealias ContactsHashMap = [String: ContactModel]
fileprivate typealias MamoAndFrequentContacts = (MamoAccountListModel, FrequentListModel)
fileprivate typealias ContactsCompletion = (Result<MamoAndFrequentContacts, Error>) -> Void

final class ContactListInteractor: ContactListInteractable {
    
    // MARK: - Properties
    var contactListSubject: PassthroughSubject<ContactListModel, Error>
    var contactPermissionPublisher: Published<ContactPermission>.Publisher { $permission }
    private var repository: ContactsListRepositorable!
    private var contactsManager: ContactsManagerable!
    @Published private(set) var permission = ContactPermission.none
    
    // MARK: - Init
    init(repository: ContactsListRepositorable, contactsManager: ContactsManagerable) {
        self.repository = repository
        self.contactsManager = contactsManager
        contactListSubject = PassthroughSubject<ContactListModel, Error>()
        authorize()
    }
    
    func authorize() {
        contactsManager.authorizationStatus { [weak self] status in
            switch status {
            case .authorized:
                self?.permission = .authorized
                self?.fetchAllContacts()
            case .denied:
                self?.permission = .denied
            case .none:
                self?.requestPermission()
            }
        }
    }
}

// MARK: - Private Methods
private extension ContactListInteractor {
    
    func requestPermission() {
        
        contactsManager.requestContactPermission { [weak self] status in
            switch status {
            case .authorized:
                self?.permission = .authorized
                self?.fetchAllContacts()
            case .denied, .none:
                self?.permission = .denied
            }
        }
    }
    
    func fetchAllContacts() {
        
        contactsManager.fetchLocalContacts { result in
            switch result {
            case .success(let contacts):
                self.successfullyFetched(contacts: contacts)
            case .failure(let error):
                self.contactListSubject.send(completion: .failure(error))
            }
        }
    }
    
    func successfullyFetched(contacts: [CNContact]) {
        
        let (contactsHashMap, emails, phones) = self.contactsHashMap(contacts: contacts)
        
        syncContactsWithMamo(emails: emails, phones: phones) { [unowned self] result in
            switch result {
            case .success(let mamoAndFrequents):
                self.updateAndExtractContactSubject(contacts: mamoAndFrequents, contactsHasMap: contactsHashMap)
            case .failure(let error):
                self.contactListSubject.send(completion: .failure(error))
            }
        }
    }
}

// MARK: - Extract local contacts and perform repository API requests
private extension ContactListInteractor {
    
    func contactsHashMap(contacts: [CNContact]) -> (contactsHashMap: ContactsHashMap,
                                                    emails: [String],
                                                    phones: [String]) {
        
        var contactsHashMap = ContactsHashMap()
        var emails = [String]()
        var phones = [String]()
        
        for contact in contacts {
            for phone in contact.phoneNumbers {
                let mobile = phone.value.stringValue.formatMobileNumber()
                phones.append(mobile)
                contactsHashMap[mobile] = ContactModel(id: "",
                                                       key: "phone",
                                                       value: mobile,
                                                       publicName: contact.givenName + " " + contact.familyName,
                                                       dataImage: contact.imageData,
                                                       isMamoAccount: false)
            }
            
            for email in contact.emailAddresses {
                let email = String(email.value).lowercased()
                emails.append(email)
                contactsHashMap[email] = ContactModel(id: "",
                                                      key: "email",
                                                      value: email.lowercased(),
                                                      publicName: contact.givenName + " " + contact.familyName,
                                                      dataImage: contact.imageData,
                                                      isMamoAccount: false)
            }
        }
        
        return (contactsHashMap, emails, phones)
    }
    
    func syncContactsWithMamo(emails: [String],
                              phones: [String],
                              completion: @escaping ContactsCompletion) {
        
        var mamoContactsListModel: MamoAccountListModel!
        var frequentsListModel: FrequentListModel!
        var error: Error?
        
        let group = DispatchGroup()
        
        group.enter()
        repository.fetchSearch(emails: emails, phones: phones) { result in
            switch result {
            case .success(let mamoAccounts):
                mamoContactsListModel = mamoAccounts
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
                frequentsListModel = list
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
                completion(.success((mamoContactsListModel,frequentsListModel)))
            }
        }
    }
}

// MARK: - Extract Contacts (Mamo, frequents and local)
private extension ContactListInteractor {
    
    func updateAndExtractContactSubject(contacts: MamoAndFrequentContacts, contactsHasMap: ContactsHashMap) {
        
        let mamoContacts = contacts.0
        let frequentsContacts = contacts.1
        
        let (mamoAccounts, mamoHashMap, deviceContactsHashMap) = extractMamoContacts(from: mamoContacts, with: contactsHasMap)
        let frequentContacts = extractFrequentAccounts(from: frequentsContacts, with: mamoHashMap)
        let deviceContacts = extractDeviceContacts(from: deviceContactsHashMap)
        
        let contactListModel = ContactListModel(frequentReceivers: frequentContacts,
                                                mamoAccounts: mamoAccounts,
                                                deviceContacts: deviceContacts)
        self.contactListSubject.send(contactListModel)
    }
    
    func extractMamoContacts( from contacts: MamoAccountListModel,
                              with allContactsHashMap: ContactsHashMap) -> (mamoList: [ContactModel],
                                                                            mamoContactsHashMap: ContactsHashMap,
                                                                            deviceContactsHashMap: ContactsHashMap) {
        
        var mamoAccounts = [ContactModel]()
        var mamoHashMap = ContactsHashMap()
        var allContactsHashMap = allContactsHashMap
        for mamo in contacts.mamoAccounts {
            
            if let contact = allContactsHashMap[mamo.value.lowercased()] {
                allContactsHashMap[mamo.value.lowercased()] = nil
                let contactModel = ContactModel(id: mamo.id,
                                                key: mamo.key,
                                                value: mamo.value,
                                                publicName: mamo.publicName != nil ? mamo.publicName: contact.publicName,
                                                dataImage: contact.dataImage,
                                                isMamoAccount: true)
                mamoAccounts.append(contactModel)
                mamoHashMap[mamo.id] = contactModel
            }
        }
        
        return (mamoAccounts, mamoHashMap, allContactsHashMap)
    }
    
    func extractFrequentAccounts( from contacts: FrequentListModel,
                                  with mamoAccountsHashMap: ContactsHashMap) -> [ContactModel] {
        
        var frequentList = [ContactModel]()
        for frequent in contacts.frequents {
            let contact: ContactModel
            
            if let mamo = mamoAccountsHashMap[frequent.id] {
                contact = ContactModel(
                    id: mamo.id,
                    key: mamo.key,
                    value: mamo.value,
                    publicName: mamo.publicName,
                    dataImage: mamo.dataImage,
                    isMamoAccount: mamo.isMamoAccount
                )
            } else {
                contact = ContactModel(
                    id: frequent.id,
                    key: "",
                    value: "",
                    publicName: nil,
                    dataImage: nil,
                    isMamoAccount: false
                )
            }
            frequentList.append(contact)
        }
        
        return frequentList
    }
    
    func extractDeviceContacts(from hashMap: ContactsHashMap) -> [ContactModel] {
        
        var contacts = [ContactModel]()
        for contact in hashMap.values {
            contacts.append(contact)
        }
        return contacts
    }
}
