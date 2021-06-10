//
//  UITextField+Extensions.swift
//  
//

//

import UIKit

// MARK: - Misc

public extension UITextField {

    func setClearButton(with image: UIImage) {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(image, for: .normal)
        clearButton.frame = CGRect(origin: .zero, size: CGSize(width: self.height, height: self.height))
        clearButton.contentMode = .right
        clearButton.addTarget(self, action: #selector(clear), for: .touchUpInside)
        clearButtonMode = .never
        rightView = clearButton
        rightViewMode = .whileEditing
    }

    @objc private func clear() {
        text = ""
        sendActions(for: .editingChanged)
    }

    func setPlaceHolderTextColor(_ color: UIColor) {
        guard let placeholder = placeholder, !placeholder.isEmpty else {
            return
        }
        let attributes = [NSAttributedString.Key.foregroundColor: color]
        attributedPlaceholder = NSAttributedString(string: placeholder,
                                                   attributes: attributes)
    }
    
}
