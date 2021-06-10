//
//  ContactsListCoordinator.swift
//  Mamo
//
//

import UIKit
import Combine

final class ContactsListCoordinator: BaseCoordinator {

    // MARK: - Properties
    
    private var router: Router
    private var builder: ContactsListBuilder!
    private var bindings = Set<AnyCancellable>()
    // Mark: - Init
    
    init(router: Router, builder: ContactsListBuilder) {
        self.router = router
        self.builder = builder
    }
    
    // MARK :- Overriden
    
    override func start() {
        let contactsViewController = builder.build()
        router.setRoot(presentable: contactsViewController, hideBar: true)
        setupNavigationBindings(viewModel: contactsViewController.viewModel)
    }
    
    func setupNavigationBindings(viewModel: ContactsListViewModel) {
        viewModel.showContactDetails
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] contact in
                self?.navigateToContactDetailsDetails(contact: contact)
            }
            .store(in: &bindings)
    }
    
    func navigateToContactDetailsDetails(contact: ContactViewStateModel) {

    }
}
