//
//  HeaderView.swift
//  Mamo
//
//

import UIKit

final class HeaderViewModel: UICollectionReusableView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var seperatorView: UIView!
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // configure ( text: String, shouldShowSeperator: Bool)
    func configure(headerModel: HeaderViewStateModel) {
        titleLabel.text = headerModel.title
        seperatorView.isHidden = !headerModel.shouldShowSeperatorr
    }
}

struct HeaderViewStateModel {
    var title: String
    var shouldShowSeperatorr: Bool
}
