//
//  FrequentCollectionViewCell.swift
//  Mamo
//
//

import UIKit

class FrequentCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var frequentView: FrequentView!

    func configure(contact: ContactViewStateModel) {
        frequentView.configure(contact: contact)
    }
}
