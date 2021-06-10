//
//  ContactPresentationModel.swift
//  Mamo
//
//  Created by islam Elshazly on 09/06/2021.
//

import Foundation

struct ContactPresentationModel {
 
    var id: String
    var key: String
    var value: String
    var publicName: String?
    var dataImage: Data?
    var isMamoAccount: Bool = false
}

struct ContactsPresentationModel {
    var frequentRecivers: [ContactPresentationModel]
    var mamoAccounts: [ContactPresentationModel]
    var contacts: [ContactPresentationModel]
}
