//
//  ContactDetailsViewController.swift
//  Mamo
//
//

import UIKit

final class ContactDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var frequentView: FrequentView!
    @IBOutlet private weak var contactLabel: UILabel!
    @IBOutlet private weak var contactIdLabel: UILabel!
    @IBOutlet private weak var phoneOrEmailLabel: UILabel!
    @IBOutlet private weak var isFrequentLabel: UILabel!
    @IBOutlet private weak var isMamoLabel: UILabel!
    
    // MARK: - Properties
    var contact: ContactViewStateModel!
    var viewModel: ContactDetailsViewModel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureContactData(contact: contact)
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        viewModel.backToContactListState.send()
    }
    
    func configureContactData(contact: ContactViewStateModel) {
        
        frequentView.configure(contact: contact)
        contactLabel.text = contact.name
        contactIdLabel.text = contact.id
        phoneOrEmailLabel.text = contact.value
        isFrequentLabel.text = "\(contact.isFrequent)"
        isMamoLabel.text = "\(contact.isMamoAccount)"
    }
}
