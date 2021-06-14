//
//  SceneDelegate.swift
//  MamoTask
//
//

import UIKit
import AlamofireNetworkActivityLogger

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let rootController = UINavigationController()
    
    private lazy var appCoordinator: AppCoordinator = {
        return AppCoordinator(router: RouterImplementation(rootController: rootController))
    }()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        AlamofireNetworkActivityLogger.NetworkActivityLogger.shared.startLogging()
        startInitialRootViewController(scene: scene)
    }
    
    func startInitialRootViewController(scene: UIScene) {
        guard let winScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: winScene)
        window?.rootViewController = rootController
        window?.makeKeyAndVisible()
        rootController.setNavigationBarHidden(true, animated: false)
        appCoordinator.start()
    }
}

