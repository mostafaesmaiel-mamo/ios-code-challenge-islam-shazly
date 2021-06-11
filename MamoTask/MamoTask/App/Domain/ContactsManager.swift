//
//  ContactsManager.swift
//  MamoTask
//
//  Created by islam Elshazly on 11/06/2021.
//

import Foundation
import SwiftyContacts

enum ContactPermissionState {
    case authorized
    case denied
    case none
}

protocol ContactsManger {
    func authorizationStatus(completion: @escaping ((ContactPermissionState) -> Void))
    func requestContactPermission(completion: @escaping ((ContactPermissionState) -> Void))
    func fetchLocalContacts(completion: @escaping APIResultHandler<[CNContact]>)
}

final class ContactsMangerImplementation: ContactsManger {
    
    func authorizationStatus(completion: @escaping ((ContactPermissionState) -> Void)) {
        SwiftyContacts.authorizationStatus {status in
            switch status {
            case .authorized:
                completion(.authorized)
                break
            case .denied:
                completion(.denied)
            default:
                completion(.none)
            }
        }
    }
    
    func requestContactPermission(completion: @escaping ((ContactPermissionState) -> Void)) {
        SwiftyContacts.requestAccess { response  in
            if response {
                completion(.authorized)
            } else {
                completion(.denied)
            }
        }
    }
    
    
    func fetchLocalContacts(completion: @escaping APIResultHandler<[CNContact]>) {
        SwiftyContacts.fetchContacts { (result) in
            switch result {
                case .success(let contacts):
                    completion(.success(contacts))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}
