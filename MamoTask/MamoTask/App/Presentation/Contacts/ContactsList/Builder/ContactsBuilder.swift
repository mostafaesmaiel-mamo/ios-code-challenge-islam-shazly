//
//  ContactsBuilder.swift
//  Mamo
//
//

import Foundation

final class ContactsListBuilder: Builder {
    
    func build() ->  ContactListViewController {
        let contactListViewController = ContactListViewController.initFromStoryboard(storyboard: Constant.StoryBoard.Contacts)
        contactListViewController.viewModel = ContactsListViewModel(interactor: ContactListInteractor(repository: ContactsListRepository(),
                                                                                                                   contactsManager: ContactsManager()))
        return contactListViewController
    }
}
