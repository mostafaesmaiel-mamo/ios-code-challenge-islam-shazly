//
//  ContactDetailsViewModel.swift
//  Mamo
//
//

import Foundation
import Combine

protocol ContactDetailsViewModel {
    var backToContactListState: PassthroughSubject<Void, Error> { get }

}

final class ContactDetailsViewModelImplmentation: ContactDetailsViewModel {
    
    var backToContactListState = PassthroughSubject<Void, Error>()
    
}
