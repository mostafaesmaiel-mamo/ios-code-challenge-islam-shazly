//
//  ContactsManagerable.swift
//  MamoTask
//
//

import Foundation
import SwiftyContacts

protocol ContactsManagerable {
    
    typealias PermissionCompletion = (ContactPermission) -> Void
    
    func authorizationStatus(completion: @escaping PermissionCompletion)
    func requestContactPermission(completion: @escaping PermissionCompletion)
    func fetchLocalContacts(completion: @escaping APIResultHandler<[CNContact]>)
}
