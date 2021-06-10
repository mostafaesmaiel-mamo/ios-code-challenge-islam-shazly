//
//  HeaderView.swift
//  Mamo
//
//

import UIKit

final class HeaderView: UICollectionReusableView {
    
    @IBOutlet weak var charLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    func configuare(row: Int) {
        switch row {
        case 0:
            lineView.isHidden = false
            charLabel.text = "Frequents"
        case 1:
            charLabel.text = "Your friends on Maomo"
            lineView.isHidden = true
        case 2:
            charLabel.text = "Your Contacts"
            lineView.isHidden = false
        default:
            break
        }
    }
    
}
