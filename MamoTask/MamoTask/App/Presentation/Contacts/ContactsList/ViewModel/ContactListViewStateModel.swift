//
//  ContactListViewStateModel.swift
//  MamoTask
//
//

import UIKit

struct ContactListViewStateModel {
    
    var frequentsReceiver: [ContactViewStateModel]
    var mamoAccounts: [ContactViewStateModel]
    var contacts: [ContactViewStateModel]
    
    mutating func convertContactPresentationToViewStateModel(presentationModel: ContactListModel) {
        frequentsReceiver = presentationModel.frequentReceivers.map({ frequentPresentation in
            ContactViewStateModel(id: frequentPresentation.id,
                                  key: frequentPresentation.key, value: frequentPresentation.value,
                                  name: frequentPresentation.publicName,
                                  isMamoAccount: frequentPresentation.isMamoAccount, isFrequent: true,
                                  image: frequentPresentation.dataImage != nil ? UIImage(data: frequentPresentation.dataImage!) : nil)
        })
        
        mamoAccounts = presentationModel.mamoAccounts.map({ mamoPresentation in
            ContactViewStateModel(id: mamoPresentation.id, key: mamoPresentation.key,
                                  value: mamoPresentation.value,
                                  name: mamoPresentation.publicName,
                                  isMamoAccount: mamoPresentation.isMamoAccount, isFrequent: false,
                                  image: mamoPresentation.dataImage != nil ? UIImage(data: mamoPresentation.dataImage!) : nil)
        })
        
        contacts = presentationModel.deviceContacts.map({ contactPresentation in
            ContactViewStateModel(id: contactPresentation.id,
                                  key: contactPresentation.key,
                                  value: contactPresentation.value,
                                  name: contactPresentation.publicName,
                                  isMamoAccount: contactPresentation.isMamoAccount,
                                  isFrequent: false,
                                  image: contactPresentation.dataImage != nil ? UIImage(data: contactPresentation.dataImage!) : nil)
        })
    }
    
    mutating func getContactMatched(contact: ContactViewStateModel) {
        let frequents: [ContactViewStateModel] = frequentsReceiver.map { frequent in
            var frequent = frequent
            if frequent.id == contact.id {
                frequent.isSelected = true
            } else {
                frequent.isSelected = false
            }
            return frequent
        }
        frequentsReceiver = frequents
        
        
        let mamo: [ContactViewStateModel] = mamoAccounts.map { account in
            var account = account
            if account.id == contact.id {
                account.isSelected = true
            } else {
                account.isSelected = false
            }
            return account
        }
        
        mamoAccounts = mamo
    }   
}
