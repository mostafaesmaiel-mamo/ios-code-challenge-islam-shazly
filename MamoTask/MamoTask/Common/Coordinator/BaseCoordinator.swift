//
//  BaseCoordinator.swift
//  Mamo
//
//  Created by islam Elshazly on 02/06/2021.
//

import Foundation

protocol CoordinatorDelegate: AnyObject {
    func coordinatorHasCompleted(coordinator: BaseCoordinator, data: Any?)
}

class BaseCoordinator {
    private let identifier = UUID()
    private var childCoordinators = [UUID: Any]()
    weak var delegate: CoordinatorDelegate?
    
    // MARK:- Private Helping
    
    private func store(coordinator: BaseCoordinator) {
        childCoordinators[coordinator.identifier] = coordinator
    }
    
    func free(coordinator: BaseCoordinator) {
        childCoordinators[coordinator.identifier] = nil
    }
    
    func freeAll() {
        for key in childCoordinators.keys {
            childCoordinators[key] = nil
        }
    }
    
    
    // MARK:- Public Helping
    
    func coordinate(to coordinator: BaseCoordinator) {
        store(coordinator: coordinator)
        coordinator.start()
    }
    
    
    func start() {
        fatalError("Start method must be implemented.")
    }
    
}
