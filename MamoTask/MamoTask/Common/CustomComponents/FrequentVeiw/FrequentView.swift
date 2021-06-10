//
//  FrequentView.swift
//  Mamo
//
//

import UIKit

final class FrequentView: UIView {
    
    // MARK: - Outlets
    
    @IBOutlet weak private var charLabel: UILabel!
    @IBOutlet weak private var userImageView: UIImageView!
    @IBOutlet weak private var mamoImageView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var containerView: UIView!
    
    // MARK: - Properties
    
    var isSelected: Bool = false {
        didSet {
            
        }
    }
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    // MARK: - Setup
    
    func setupView() {
        self.loadNibView()
        charLabel.roundCorners(.allCorners, radius: charLabel.width / 2)
        userImageView.roundCorners(.allCorners, radius: userImageView.width / 2)
    }
    
    func configure(contact: ContactViewStateModel) {
    
        userImageView.image = contact.image
        mamoImageView.isHidden = !contact.isMamoAccount
        charLabel.text = contact.prefixName ?? ""
        nameLabel.text = contact.name ?? ""
        if contact.isSelected {
            containerView.addBorder(width: 2, color: #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 1, alpha: 1))
        } else {
            containerView.addBorder(width: 0, color: .clear)
        }
    }
}
