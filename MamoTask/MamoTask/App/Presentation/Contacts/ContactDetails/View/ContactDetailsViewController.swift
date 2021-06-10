//
//  ContactDetailsViewController.swift
//  Mamo
//
//

import UIKit

final class ContactDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var frequentView: FrequentView!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var contactIdLabel: UILabel!
    @IBOutlet weak var phoneOrEmailLabel: UILabel!
    @IBOutlet weak var isFrequentLabel: UILabel!
    @IBOutlet weak var isMamoLabel: UILabel!
    
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
        isFrequentLabel.text = "\(contact.isFrequet)"
        isMamoLabel.text = "\(contact.isMamoAccount)"
    }

}
