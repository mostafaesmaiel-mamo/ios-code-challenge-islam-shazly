//
//  CollectionViewCell.swift
//  Mamo
//
//  Created by islam Elshazly on 07/06/2021.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var prefixNameLabel: UILabel!
    @IBOutlet private weak var mamoIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.setCornerRadius(radius: imageView.width / 2)
        prefixNameLabel.setCornerRadius(radius: prefixNameLabel.width / 2)
        setCornerRadius(radius: 16)
    }
    
    func configureMamo(contact: ContactViewStateModel) {
        imageView.image = contact.image
        nameLabel.text = contact.name
        mamoIcon.isHidden = false
        prefixNameLabel.text = contact.prefixName
        if contact.isSelected {
            addBorder(width: 2, color: #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 1, alpha: 1))
        } else {
            addBorder(width: 0, color: .clear)
        }
    }

    func configureLocalContacts(contact: ContactViewStateModel) {
        imageView.image = contact.image
        nameLabel.text = contact.name
        mamoIcon.isHidden = true
        prefixNameLabel.text = contact.prefixName
    }
}
