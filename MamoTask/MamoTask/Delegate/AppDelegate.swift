//
//  AppDelegate.swift
//  MamoTask
//
//

import UIKit
import AlamofireNetworkActivityLogger

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        AlamofireNetworkActivityLogger.NetworkActivityLogger.shared.startLogging()

        return true
    }
    
}

