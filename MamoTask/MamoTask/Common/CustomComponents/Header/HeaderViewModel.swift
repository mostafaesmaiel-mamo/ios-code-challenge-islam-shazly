//
//  HeaderView.swift
//  Mamo
//
//

import UIKit

final class HeaderViewModel: UICollectionReusableView {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var seperatorView: UIView!
    
    // configure ( text: String, shouldShowSeperator: Bool)
    func configure(headerModel: HeaderViewStateModel) {
        titleLabel.text = headerModel.title
        seperatorView.isHidden = !headerModel.shouldShowSeperatorr
    }
}
