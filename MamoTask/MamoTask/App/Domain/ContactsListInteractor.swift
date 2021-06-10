//
//  ContactsInteractor.swift
//  Mamo
//
//  Created by islam Elshazly on 08/06/2021.
//

import UIKit
import SwiftyContacts
import Combine

enum ContactPermissionState {
    case authorized
    case denied
    case none
}

protocol ContactsListInteractor {
    
    var contactsPresnetatoinLogic: Published<ContactsPresentationModel>.Publisher { get }
    var contactPermissionLogic: Published<ContactPermissionState>.Publisher { get }
    
    func fetchContacts()
    func authorizationStatus()
    func contactPermission()
}

final class ContactsListInteractorImplementation: ContactsListInteractor {
    
    // MARK: - Properties
    
    var contactsPresnetatoinLogic: Published<ContactsPresentationModel>.Publisher { $contactsPresnetatoinList }
    var contactPermissionLogic: Published<ContactPermissionState>.Publisher { $contactPermissionState }
    
    private var repository: ContactsListRepository!
    private var contactsDic = [String: ContactPresentationModel]()
    
    
    @Published private(set) var contactPermissionState = ContactPermissionState.none
    @Published private(set) var contactsPresnetatoinList: ContactsPresentationModel = ContactsPresentationModel(frequentRecivers: [ContactPresentationModel](), mamoAccounts: [ContactPresentationModel](), contacts: [ContactPresentationModel]())
    

    init(repository: ContactsListRepository) {
        self.repository = repository
        contactPermission()
        authorizationStatus()
    }
    
    // MARK: - API
    
    private func fetchMamoAccounts(emails: [String], phones: [String]) {

        var mamoContanctsListDTO: MamoAccountsDTO!
        var frequentsListDTO: FrequentListDTO!
        var mamoAccountDic = [String: ContactPresentationModel]()
        
        let group = DispatchGroup()
        
        group.enter()
        repository.fetchSearch(emails: emails, phones: phones) { result in
            
            switch result {
            case .success(let mamoAccounts):
                mamoContanctsListDTO = mamoAccounts
                group.leave()
            case .failure(let error):
                group.leave()
                print(error)
            }
        }
        
        group.enter()
        repository.fetchFrequentReceivers { result in
            
            switch result {
            case .success(let list):
                frequentsListDTO = list
                group.leave()
            case .failure(let error):
                print(error.localizedDescription)
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            
            var mamoAccountsPresentatoinModel = [ContactPresentationModel]()
            var frequentsPresentatioinModel = [ContactPresentationModel]()
            var contactsPresentatioinModel = [ContactPresentationModel]()
            
            for mamo in mamoContanctsListDTO.mamoAccounts {
                
                if let contact = self.contactsDic[mamo.value.lowercased()] {
                    self.contactsDic[mamo.value.lowercased()] = nil
                    let contactPresentationModel = ContactPresentationModel(id: mamo.id,
                                                                            key: mamo.key,
                                                                            value: mamo.value,
                                                                            publicName: mamo.publicName != nil ? mamo.publicName: contact.publicName,
                                                                            dataImage: contact.dataImage,
                                                                            isMamoAccount: true)
                    mamoAccountsPresentatoinModel.append(contactPresentationModel)
                    mamoAccountDic[mamo.id] = contactPresentationModel
                }
            }
            
            // get frequent form amamAccountDic
            
            for frequent in frequentsListDTO.frequents {
                var contactPresentationModel: ContactPresentationModel!
                
                if let mamo = mamoAccountDic[frequent.id] {
                    contactPresentationModel = ContactPresentationModel(id: mamo.id,
                                                                        key: mamo.key,
                                                                        value: mamo.value,
                                                                        publicName: mamo.publicName,
                                                                        dataImage: mamo.dataImage,
                                                                        isMamoAccount: mamo.isMamoAccount)
                } else {
                    contactPresentationModel = ContactPresentationModel(id: frequent.id,
                                                                        key: "",
                                                                        value: "",
                                                                        publicName: nil,
                                                                        dataImage: nil,
                                                                        isMamoAccount: false)
                }
                frequentsPresentatioinModel.append(contactPresentationModel)
            }
            
            for contact in self.contactsDic.values {
                contactsPresentatioinModel.append(contact)
            }
            
            self.contactsPresnetatoinList = ContactsPresentationModel(frequentRecivers: frequentsPresentatioinModel,
                               mamoAccounts: mamoAccountsPresentatoinModel,
                               contacts: contactsPresentatioinModel)
        }
    }
    
    // MARK: - Methods
    
    func authorizationStatus() {
        SwiftyContacts.authorizationStatus { [weak self] status in
            switch status {
            case .authorized:
                self?.contactPermissionState = .authorized
                break
            case .denied:
                self?.contactPermissionState = .denied
            default:
                break
            }
        }
    }
    
    func contactPermission() {
    
        SwiftyContacts.requestAccess { [weak self] response  in
            if response {
                self?.contactPermissionState = .authorized
            } else {
                self?.contactPermissionState = .denied
            }
        }
    }
    
    func fetchContacts() {
        SwiftyContacts.fetchContacts { (result) in
            
            switch result {

            case .success(let contacts):
                var emails = [String]()
                var phones = [String]()
                
                for contact in contacts {
                    for phone in contact.phoneNumbers {
                        let mobile = phone.value.stringValue.formatMobileNumber()
                        phones.append(mobile)
                        self.contactsDic[mobile] = ContactPresentationModel(id: "", key: "phone", value: mobile, publicName: contact.givenName + " " + contact.familyName, dataImage: contact.imageData, isMamoAccount: false)
                    }
                    
                    for email in contact.emailAddresses {
                        let email = String(email.value).lowercased()
                        emails.append(email)
                        self.contactsDic[email] = ContactPresentationModel(id: "", key: "email", value: email.lowercased(), publicName: contact.givenName + " " + contact.familyName, dataImage: contact.imageData, isMamoAccount: false)
                    }
                }
                
                self.fetchMamoAccounts(emails: emails, phones: phones)
                
            case .failure(let error):
                break
            }
        }
    }
    
}
