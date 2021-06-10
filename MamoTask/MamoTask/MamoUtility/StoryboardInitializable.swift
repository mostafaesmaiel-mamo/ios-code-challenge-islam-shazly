//
//  StoryboardInitializable.swift

import UIKit

public protocol StoryboardNameProtocol {
    var name: String { get }
}

// MARK: - StoryboardInitializable

public protocol StoryboardInitializable: Identifiable {
    static func initFromStoryboard(storyboard: StoryboardNameProtocol) -> Self
    static func initNavigationFromStoryboard(storyboard: StoryboardNameProtocol) -> UINavigationController
}

// MARK: - StoryboardInitializable Default Implementation

public extension StoryboardInitializable where Self: UIViewController {
    static func initFromStoryboard(storyboard: StoryboardNameProtocol) -> Self {
        let storyboard = UIStoryboard(name: storyboard.name, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! Self
    }
    
    static func initNavigationFromStoryboard(storyboard: StoryboardNameProtocol) -> UINavigationController {
        let storyboard = UIStoryboard(name: storyboard.name, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! UINavigationController
    }

}

extension UIViewController: StoryboardInitializable { }
