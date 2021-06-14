//
//  ContactListInteractable.swift
//  MamoTask
//
//

import Foundation
import Combine

protocol ContactListInteractable {
    
    var contactListSubject: PassthroughSubject<ContactListModel, Error> { get }
    var contactPermissionPublisher: Published<ContactPermission>.Publisher { get }
    func authorize()
}
