//
//  ContactListViewStateModel.swift
//  MamoTask
//
//

import UIKit

struct ContactListViewStateModel {
    
    var frequentsReciver: [ContactViewStateModel]
    var mamoAccounts: [ContactViewStateModel]
    var contacts: [ContactViewStateModel]
    
    mutating func convertContactPresentationToViewStateModel(presentationModel: ContactListPresentationModel) {
        frequentsReciver = presentationModel.frequentRecivers.map({ frequentPresentation in
            ContactViewStateModel(id: frequentPresentation.id,
                                  key: frequentPresentation.key, value: frequentPresentation.value,
                                  name: frequentPresentation.publicName,
                                  isMamoAccount: frequentPresentation.isMamoAccount, isFrequet: true,
                                  image: frequentPresentation.dataImage != nil ? UIImage(data: frequentPresentation.dataImage!) : nil)
        })
        
        mamoAccounts = presentationModel.mamoAccounts.map({ mamoPresentation in
            ContactViewStateModel(id: mamoPresentation.id, key: mamoPresentation.key,
                                  value: mamoPresentation.value,
                                  name: mamoPresentation.publicName,
                                  isMamoAccount: mamoPresentation.isMamoAccount, isFrequet: false,
                                  image: mamoPresentation.dataImage != nil ? UIImage(data: mamoPresentation.dataImage!) : nil)
        })
        
        contacts = presentationModel.contacts.map({ contactPresentation in
            ContactViewStateModel(id: contactPresentation.id, key: contactPresentation.key, value: contactPresentation.value, name: contactPresentation.publicName, isMamoAccount: contactPresentation.isMamoAccount, isFrequet: false, image: contactPresentation.dataImage != nil ? UIImage(data: contactPresentation.dataImage!) : nil)
        })
    }
    
    mutating func getContactMatched(contact: ContactViewStateModel) {
        let frequents: [ContactViewStateModel] = frequentsReciver.map { frequent in
            var frequent = frequent
            if frequent.id == contact.id {
                frequent.isSelected = true
            } else {
                frequent.isSelected = false
            }
            return frequent
        }
        frequentsReciver = frequents
        
        
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
