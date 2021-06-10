//
//  UnderLine+Extensions.swift
//  
//

//

import UIKit

extension UIButton {
    
    func makeUnderline() {
        guard let text = self.title(for: .normal) else { return }
        let range = NSRange(location: 0, length: text.count)
        let color = self.titleColor(for: .normal)!
        let attributedString = NSMutableAttributedString(string: text)
        
        attributedString.addAttribute(.underlineColor, value: color, range: range)
        attributedString.addAttribute(.font, value: titleLabel!.font!, range: range)
        attributedString.addAttribute(.foregroundColor, value: color, range: range)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.thick.rawValue, range: range)
        self.setAttributedTitle(attributedString, for: .normal)
    }
}

extension UILabel {
    
    func makeUnderline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}
