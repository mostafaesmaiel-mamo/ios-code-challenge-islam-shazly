//
//  AppCoordinator.swift
//  Mamo
//
//  Created by islam Elshazly on 02/06/2021.
//

import Foundation
import UIKit

final class AppCoordinnator: BaseCoordinator {
    
    // MARK: - Properties
    
    private let router: Router
    
    // MARK: - Init
    
    init(router: Router) {
        self.router = router
    }
    
    // MARK: - Overriden
    
    override func start() {
        let contactsListCoordinator = ContactsListCoordinator(router: router, builder: ContactsListBuilder())
        self.coordinate(to: contactsListCoordinator)
    }
}
