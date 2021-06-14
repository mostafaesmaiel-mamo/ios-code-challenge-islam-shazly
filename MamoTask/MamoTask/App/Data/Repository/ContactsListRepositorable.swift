//
//  ContactsListRepositorable.swift
//  MamoTask
//
//

import Foundation

protocol ContactsListRepositorable {
    
    typealias FrequentReceiverHandler = APIResultHandler<FrequentListModel>
    typealias MamoAccountsHandler = APIResultHandler<MamoAccountListModel>
    
    func fetchFrequentReceivers(completion: @escaping FrequentReceiverHandler)
    func fetchSearch(emails:[String], phones: [String], completion: @escaping MamoAccountsHandler)
}
