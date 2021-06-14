//
//  RouterImplementation.swift
//  Mamo
//
//  Created by islam Elshazly on 09/06/2021.
//

import UIKit

final class RouterImplementation: Router {
    
    // MARK: - Properties
    
    weak var rootController: UINavigationController?
    
    // MARK: - Init
    
    init(rootController: UINavigationController) {
        
        self.rootController = rootController
    }
    
    // MARK: - Router
    
    func toPresent() -> UIViewController? {
        return rootController
    }
    
    func setRoot(presentable: UIViewController?, hideBar: Bool) {
        
        guard let controller = presentable else { return }
        rootController?.setViewControllers([controller], animated: false)
        rootController?.isNavigationBarHidden = hideBar
    }
    
    func popToRoot(animated: Bool) {
        rootController?.popToRootViewController(animated: animated)
    }
    
    func present(presentable: UIViewController?, animated: Bool) {
        
        guard let controller = presentable else { return }
        rootController?.present(controller, animated: animated, completion: nil)
    }
    
    func dismiss(animated: Bool, completion: CompletionHandler?) {
        rootController?.dismiss(animated: animated, completion: completion)
    }
    
    func push(presentable: UIViewController?, animated: Bool, completion: CompletionHandler?) {
        
        guard let controller = presentable, (controller as? UINavigationController) == nil else {
            return
        }
        
        rootController?.pushViewController(controller, animated: animated)
    }
    
    func pop(animated: Bool) {
        rootController?.popViewController(animated: animated)
    }
    
    func setAppRoot(presentable: UIViewController?, animated: Bool) {
        
        guard let scene = UIApplication.shared.connectedScenes.first,
              let appScene = scene.delegate as? SceneDelegate else { return }
        
        guard animated, let window = appScene.window else {
            appScene.window?.rootViewController = presentable
            appScene.window?.makeKeyAndVisible()
            return
        }

        window.rootViewController = presentable
        window.makeKeyAndVisible()
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }
}
