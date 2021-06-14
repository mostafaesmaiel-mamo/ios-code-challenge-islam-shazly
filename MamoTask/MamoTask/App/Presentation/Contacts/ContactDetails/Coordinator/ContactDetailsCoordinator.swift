//
//  ContactDetailsCoordinator.swift
//  Mamo
//
//

import UIKit
import Combine

final class ContactDetailsCoordinator: BaseCoordinator {
    
    // MARK: - Properties
    private let router: Router
    private let builder: ContactDetailsBuilder
    private var bindings = Set<AnyCancellable>()
    
    // MARK: - Init
    init(router: Router, builder: ContactDetailsBuilder) {
        self.router = router
        self.builder = builder
    }
    
    // MARK: - Overridern
    override func start() {
        let contactDetailsViewController = builder.build()
        router.push(presentable: contactDetailsViewController, animated: true, completion: nil)
        setupNavigationBinding(viewModel: contactDetailsViewController.viewModel)
    }
    
    func setupNavigationBinding(viewModel: ContactDetailsViewModel) {
        viewModel.backToContactListState
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] _ in
                self?.backToContactList()
            }
            .store(in: &bindings)
    }
    
    func backToContactList() {
        self.router.pop(animated: true)
        free(coordinator: self)
    }
}
