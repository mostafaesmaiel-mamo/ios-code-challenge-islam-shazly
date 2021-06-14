//
//  ContactDetailsViewModel.swift
//  Mamo
//
//

import Foundation
import Combine

protocol ContactDetailsViewModelType {
    
    var backToContactListState: PassthroughSubject<Void, Error> { get }
}

final class ContactDetailsViewModel: ContactDetailsViewModelType {
    
    var backToContactListState = PassthroughSubject<Void, Error>()
}
