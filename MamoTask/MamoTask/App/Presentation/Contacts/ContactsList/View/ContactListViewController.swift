//
//  ViewController.swift
//  Mamo
//
//  Created by islam Elshazly on 31/05/2021.
//

import UIKit
import Combine

final class ContactListViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak private var button: UIButton!
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: NextButton!
    
    
    // MARK: - Properties
    
    var viewModel: ContactsListViewModelImplmentation!
    private var bindings = Set<AnyCancellable>()
    private var frequentList = [ContactViewStateModel]()
    private var mamoList = [ContactViewStateModel]()
    private var contacts = [ContactViewStateModel]()
    private var selectedContact: ContactViewStateModel!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBinding()
        collectionView.register(cellType: CollectionViewCell.self)
        collectionView.register(cellType: FrequentCollectionViewCell.self)
        collectionView.collectionViewLayout = ContactListViewController.createLayout()
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        connfigureUI()
        
    }
    
    private func connfigureUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        nextButton.isEnabled = false
    }
    
    private func setupBinding() {
        viewModel.$shouldShowContactsCollectionViewState
            .receive(on: RunLoop.main)
            .sink { [weak self] bool in
                self?.collectionView.isHidden = !bool
            }.store(in: &bindings)
        
        viewModel.$shouldShowPermssionButtonState
            .receive(on: RunLoop.main)
            .sink { [weak self] bool in
                self?.button.isHidden = !bool
            }.store(in: &bindings)
        
        
        viewModel.contactsListViewStateModel
            .receive(on: RunLoop.main)
            .mapError({ error -> Error in
                self.showAlert(string: error.localizedDescription) { _ in
                    self.viewModel.contactPickerLogic()
                }
                return error
            })
            .sink { _ in
            } receiveValue: { [weak self] viewModel in
                
                guard let self = self else { return }
                
                self.frequentList = viewModel.frequentsReciver
                self.mamoList = viewModel.mamoAccounts
                self.contacts = viewModel.contacts
                self.collectionView.reloadData()
            }.store(in: &bindings)
    }
    
    static func createLayout() -> UICollectionViewLayout {
            let layout = UICollectionViewCompositionalLayout { (section: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
                
                if section == 0 {
                    let itemInset = NSDirectionalEdgeInsets(top: 0.0,
                                                            leading: 8.0,
                                                            bottom: 0.0,
                                                            trailing: 8.0)
                    let sectionInset = NSDirectionalEdgeInsets(top: 16.0,
                                                               leading: 0.0,
                                                               bottom: 16.0,
                                                               trailing: 0.0)
                    let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                                      heightDimension: .fractionalHeight(0.20))
                    let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.1),
                                                                                         heightDimension: .fractionalHeight(1.0)))
                    
                    item.contentInsets = itemInset
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = sectionInset
                    section.orthogonalScrollingBehavior = .continuous
                    
                    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                            heightDimension: .estimated(40))
                    let headerSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                                layoutSize: headerSize,
                                elementKind: UICollectionView.elementKindSectionHeader,
                                alignment: .topLeading)
                    section.boundarySupplementaryItems = [headerSupplementary]
                    
                    return section
                } else {
                    let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
                    item.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                                 leading: 0,
                                                                 bottom: 0,
                                                                 trailing: 0)
                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                           heightDimension: .estimated(70))
                    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                                 subitem: item,
                                                                 count: 1)
                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = NSDirectionalEdgeInsets(top: 10,
                                                                    leading: 12,
                                                                    bottom: 0,
                                                                    trailing: 12)
                    
                    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                            heightDimension: .estimated(40))
                    let headerSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                                layoutSize: headerSize,
                                elementKind: UICollectionView.elementKindSectionHeader,
                                alignment: .topLeading)
                    section.boundarySupplementaryItems = [headerSupplementary]
                    
                    return section
                }
                
            }
            return layout
        }
    
    @IBAction func permissionAction(_ sender: Any) {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
             return
         }

         if UIApplication.shared.canOpenURL(settingsUrl) {
             UIApplication.shared.open(settingsUrl, completionHandler: { (_) in
             })
         }
    }
    
    @IBAction func nextAction(_ sender: Any) {
        viewModel.showContactDetails.send(selectedContact)
    }
}

extension ContactListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let headerView = collectionView.dequeueReusableView(
                with: HeaderViewModel.self,
                for: indexPath,
                ofKind: UICollectionView.elementKindSectionHeader) as? HeaderViewModel else {
            
            return UICollectionReusableView()
        }
        
        headerView.configure(headerModel: viewModel.headerViewModel(section: indexPath.section))
        
        return headerView
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return frequentList.count
        case 1:
            return mamoList.count
        case 2:
            return contacts.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(with: FrequentCollectionViewCell.self, for: indexPath)
            cell.configure(contact: frequentList[indexPath.row])
            
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(with: CollectionViewCell.self, for: indexPath)
            cell.configureMamo(contact: mamoList[indexPath.row])
        
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(with: CollectionViewCell.self, for: indexPath)
            cell.configureLocalContacts(contact: contacts[indexPath.row])
            
            return cell
        default:
            break 
        }
        
        return UICollectionViewCell()
    }
}

extension ContactListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            selectedContact = frequentList[indexPath.row]
        case 1:
            selectedContact = mamoList[indexPath.row]
        case 2:
            selectedContact = contacts[indexPath.row]
        default:
            break
        }
        viewModel.contactSelected.send(selectedContact)
        nextButton.isEnabled = true
    }
}
