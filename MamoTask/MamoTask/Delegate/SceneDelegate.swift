//
//  SceneDelegate.swift
//  MamoTask
//
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let rootController = UINavigationController()
    private lazy var appCoordinator: AppCoordinnator = {
        return AppCoordinnator(router:
                                RouterImplementation(rootController:
                                                        rootController))
    }()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let winScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: winScene)
        window?.rootViewController = rootController
        window?.makeKeyAndVisible()
        rootController.setNavigationBarHidden(true, animated: false)
        appCoordinator.start()
    }
}

