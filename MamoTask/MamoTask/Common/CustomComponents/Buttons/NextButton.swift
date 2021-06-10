//
//  NextButton.swift
//  Mamo
//
//

import UIKit

final class NextButton: UIButton {
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                backgroundColor = #colorLiteral(red: 0.2, green: 0.2, blue: 1, alpha: 1)
                setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            } else {
                backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.9607843137, blue: 0.9764705882, alpha: 1)
                setTitleColor(#colorLiteral(red: 0.7333333333, green: 0.7333333333, blue: 0.7333333333, alpha: 1), for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCornerRadius(radius: 28)
    }
}
