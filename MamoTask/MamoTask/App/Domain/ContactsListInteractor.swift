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
    
    
    // MARK: - Properties
    
    var contactsPresnetatoinLogic: PassthroughSubject<ContactListPresentationModel, Error>
    var contactPermissionLogic: Published<ContactPermissionState>.Publisher { $contactPermissionState }
    
    private var repository: ContactsListRepository!
    private var contactsManger: ContactsManger!
    
    @Published private(set) var contactPermissionState = ContactPermissionState.none
    
    init(repository: ContactsListRepository, contactsManger: ContactsManger) {
        self.repository = repository
        self.contactsManger = contactsManger
        contactsPresnetatoinLogic = PassthroughSubject<ContactListPresentationModel, Error>()
        contactPickerLogic()
    }
    
    // MARK: - API
    
    func contactPickerLogic () {
        contactsManger.authorizationStatus { [weak self] status in
            switch status {
            case .authorized:
                self?.contactPermissionState = .authorized
                self?.fetchAllContacts()
            case .denied:
                self?.contactPermissionState = .denied
            case .none:
                self?.contactPermissionState = .denied
            }
        }
    }
    
    func fetchAllContacts() {
        contactsManger.fetchLocalContacts { result in
            switch result {
            case .success(let contacts):
                let tuple = self.extractContactsDicEmailPhone(contacts: contacts)
                let contactsDic = tuple.contactsDic
                let email = tuple.emails
                let phone = tuple.phones
                self.fetchMamoAccounts(emails: email, phones: phone) { result in
                    switch result {
                    case .success(let tuple):
                        let mamoListDTo = tuple.0
                        let frequentListDTO = tuple.1
                        let mamoInfoTuple = self.extractMamoAccountDicMamoListContactDic(
                            mamoContanctsListDTO: mamoListDTo,
                            contactsDic: contactsDic
                        )
                        let mamoPresentationList = mamoInfoTuple.mamoList
                        let mamoAccountsDic = mamoInfoTuple.mamoAccountdic
                        let contactsDicWithOutMamo = mamoInfoTuple.contactDicWithoutMamo
                        let frequentsPresentationList = self.extractFrequentFromMamaDic(
                            frequentsListDTO: frequentListDTO,
                            mamoAccountDic: mamoAccountsDic
                        )
                        let localContactPresentationList = self.extractLocalContactsFormContactDic(contactDic: contactsDicWithOutMamo)
                        let contactsPresentationList = ContactListPresentationModel(
                            frequentRecivers: frequentsPresentationList,
                            mamoAccounts: mamoPresentationList,
                            contacts: localContactPresentationList
                        )
                        self.contactsPresnetatoinLogic.send(contactsPresentationList)
                    case .failure(let error):
                        self.contactsPresnetatoinLogic.send(completion: .failure(error))
                    }
                }
            case .failure(let error):
                self.contactsPresnetatoinLogic.send(completion: .failure(error))
            }
        }
    }
    
    func fetchMamoAccounts(
        emails: [String],
        phones: [String],
        completion: @escaping (Result<(MamoAccountListDTO, FrequentListDTO), Error>) -> Void
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
    
    // MARK: - Methods
    
    func extractContactsDicEmailPhone(
        contacts: [CNContact]
    ) -> (contactsDic: [String: ContactPresentationModel], emails: [String], phones: [String]) {
        var contactsDic = [String: ContactPresentationModel]()
        var emails = [String]()
        var phones = [String]()
        
        for contact in contacts {
            for phone in contact.phoneNumbers {
                let mobile = phone.value.stringValue.formatMobileNumber()
                phones.append(mobile)
                contactsDic[mobile] = ContactPresentationModel(id: "", key: "phone", value: mobile, publicName: contact.givenName + " " + contact.familyName, dataImage: contact.imageData, isMamoAccount: false)
            }
            
            for email in contact.emailAddresses {
                let email = String(email.value).lowercased()
                emails.append(email)
                contactsDic[email] = ContactPresentationModel(id: "", key: "email", value: email.lowercased(), publicName: contact.givenName + " " + contact.familyName, dataImage: contact.imageData, isMamoAccount: false)
            }
        }
        return (contactsDic, emails, phones)
    }
    
    func extractMamoAccountDicMamoListContactDic(
        mamoContanctsListDTO: MamoAccountListDTO,
        contactsDic: [String: ContactPresentationModel]
    ) -> (mamoAccountdic: [String: ContactPresentationModel], mamoList: [ContactPresentationModel], contactDicWithoutMamo: [String: ContactPresentationModel]) {
        
        var mamoAccountsPresentatoinModel = [ContactPresentationModel]()
        var mamoAccountDic = [String: ContactPresentationModel]()
        var contactsDic = contactsDic
        for mamo in mamoContanctsListDTO.mamoAccounts {
            
            if let contact = contactsDic[mamo.value.lowercased()] {
                contactsDic[mamo.value.lowercased()] = nil
                let contactPresentationModel = ContactPresentationModel(
                    id: mamo.id,
                    key: mamo.key,
                    value: mamo.value,
                    publicName: mamo.publicName != nil ? mamo.publicName: contact.publicName,
                    dataImage: contact.dataImage,
                    isMamoAccount: true)
                mamoAccountsPresentatoinModel.append(contactPresentationModel)
                mamoAccountDic[mamo.id] = contactPresentationModel
            }
        }
        return (mamoAccountDic, mamoAccountsPresentatoinModel, contactsDic)
    }
    
    func extractFrequentFromMamaDic(
        frequentsListDTO: FrequentListDTO,
        mamoAccountDic: [String: ContactPresentationModel]
    ) -> [ContactPresentationModel] {
        var frequentsPresentatioinModel = [ContactPresentationModel]()
        for frequent in frequentsListDTO.frequents {
            var contactPresentationModel: ContactPresentationModel!
            
            if let mamo = mamoAccountDic[frequent.id] {
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
    
    func extractLocalContactsFormContactDic(contactDic: [String: ContactPresentationModel]) -> [ContactPresentationModel] {
        var contactsPresentatioinModel = [ContactPresentationModel]()
        
        for contact in contactDic.values {
            contactsPresentatioinModel.append(contact)
        }
        
        return contactsPresentatioinModel
    }
}
