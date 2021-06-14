//
//  ContactDetailsBuilder.swift
//  Mamo
//
//

import UIKit

final class ContactDetailsBuilder: Builder {
    
    private let contact: ContactViewStateModel
    
    init(contact: ContactViewStateModel) {
        self.contact = contact
    }
    
    func build() -> ContactDetailsViewController {
        let contactDetailsViewController = ContactDetailsViewController.initFromStoryboard(storyboard: Constant.StoryBoard.Contacts)
        let viewModel = ContactDetailsViewModel()
        contactDetailsViewController.viewModel = viewModel
        contactDetailsViewController.contact = contact
        
        return contactDetailsViewController
    }
}
