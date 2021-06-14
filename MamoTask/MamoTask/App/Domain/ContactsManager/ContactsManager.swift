//
//  ContactsManager.swift
//  MamoTask
//
//

import Foundation
import SwiftyContacts

final class ContactsManager: ContactsManagerable {
    
    func authorizationStatus(completion: @escaping PermissionCompletion) {
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
    
    func requestContactPermission(completion: @escaping PermissionCompletion) {
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
