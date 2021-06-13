//
//  FrequentCollectionViewCell.swift
//  Mamo
//
//  Created by islam Elshazly on 08/06/2021.
//

import UIKit

class FrequentCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var frequentView: FrequentView!

    func configure(contact: ContactViewStateModel) {
        frequentView.configure(contact: contact)
    }
}
