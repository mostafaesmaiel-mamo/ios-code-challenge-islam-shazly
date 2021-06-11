//
//  UIAlertController+extensions.swift
//  
//

//

import UIKit

// MARK: - InitializersF

public extension UIAlertController {
    
    convenience init(title: String,
                     message: String? = nil,
                     defaultActionButtonTitle: String = "OK",
                     defaultActionButtonStyle: UIAlertAction.Style = .default,
                     tintColor: UIColor? = nil) {
        self.init(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: defaultActionButtonTitle,
                                          style: defaultActionButtonStyle,
                                          handler: nil)
        addAction(defaultAction)
        if let color = tintColor {
            view.tintColor = color
        }
    }
    
}

// MARK: - Actions

extension UIAlertController {

    @discardableResult
    func addAction(title: String,
                   style: UIAlertAction.Style = .default,
                   isEnabled: Bool = true,
                   handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        action.isEnabled = isEnabled
        addAction(action)
        return action
    }

}
