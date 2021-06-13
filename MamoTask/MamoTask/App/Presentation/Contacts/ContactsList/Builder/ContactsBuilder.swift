//
//  ContactsBuilder.swift
//  Mamo
//
//

import Foundation

final class ContactsListBuilder: Builder {
    
    func build() ->  ContactListViewController {
        let contactListViewController = ContactListViewController.initFromStoryboard(storyboard: C.StoryBoard.Contacts)
        contactListViewController.viewModel = ContactsListViewModelImplmentation(interactor:
                                                                                    ContactsListInteractorImplementation(repository:
                                                                                                                            ContactsListRepositoryImplementation(),
                                                                                                                         contactsManger:
                                                                                                                                ContactsMangerImplementation()))
        return contactListViewController
    }
}
