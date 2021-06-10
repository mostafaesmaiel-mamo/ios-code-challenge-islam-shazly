//
//  UIViewController+Extensions.swift
//  
//

//

// swiftlint:disable all

import UIKit

public extension UIViewController {

    var isVisible: Bool {
        return self.isViewLoaded && view.window != nil
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    var tabBarHeight: CGFloat {
        if let me = self as? UINavigationController, let visibleViewController = me.visibleViewController {
            return visibleViewController.tabBarHeight
        }
        if let tab = self.tabBarController {
            return tab.tabBar.frame.size.height
        }
        return 0
    }
    
    var navigationBarHeight: CGFloat {
        if let me = self as? UINavigationController, let visibleViewController = me.visibleViewController {
            return visibleViewController.navigationBarHeight
        }
        if let nav = self.navigationController {
            return nav.navigationBar.height
        }
        return 0
    }
    
    var isNavBarHidden: Bool {
        get {
            return (navigationController?.isNavigationBarHidden)!
        }
        set {
            navigationController?.isNavigationBarHidden = newValue
        }
    }
    
    func addAsChildViewController(_ vc: UIViewController, toView: UIView) {
        self.addChild(vc)
        toView.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    func setBackgroundImage(_ named: String) {
        let image = UIImage(named: named)
        let imageView = UIImageView(frame: view.frame)
        imageView.image = image
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
    }
    
    func openURL(with stringUrl: String) {
        guard let url = URL(string: stringUrl) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func call(with stringUrl: String) {
        guard let url = URL(string: "tel://" + stringUrl) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func shareActionSheetFor(message: String, image: UIImage, stringUrl: String) {
        let secondActivityItem = URL(string: stringUrl)!
        
        let activityViewController: UIActivityViewController = UIActivityViewController (
            activityItems: [message, secondActivityItem, image], applicationActivities: nil)

        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.postToFacebook,
            UIActivity.ActivityType.postToTwitter,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo
        ]
        
        present(activityViewController, animated: true, completion: {})
    }
}

// MARK: - Observers

public extension UIViewController {
    func addNotificationObserver(_ name: String, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: NSNotification.Name(rawValue: name), object: nil)
    }
    
    func removeNotificationObserver(_ name: String) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: name), object: nil)
    }
    
    func removeNotificationObserver() {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Navigation

public extension UIViewController {
    
    func pushVC(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func popVC() {
        _ = navigationController?.popViewController(animated: true)
    }

    func popToRootVC() {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func presentVC(_ vc: UIViewController) {
        present(vc, animated: true, completion: nil)
    }
    
    func dismissVC(completion: (() -> Void)? = nil) {
        dismiss(animated: true, completion: completion)
    }
}
