//
//  ContactListViewController.swift
//  Contacts
//
//  Created by Evana Islam on 2/3/19.
//  Copyright © 2019 Evana Islam. All rights reserved.
//

import UIKit

class ContactListViewController: CollectionViewController {
    var segmentedControl: UISegmentedControl!
    var showMoreButton: UIButton!
    var activityIndicator: UIActivityIndicatorView!
    
    var contactListViewModel: ContactListViewModel = {
        return ContactListViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initialiseViewModel() {
        
        // Naive binding
        contactListViewModel.showAlertClosure = { [weak self]  in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let message = self.contactListViewModel.alertMessage {
                    self.showAlert( message )
                }
            }
        }
        
        contactListViewModel.updateLoadingStatus = { [weak self]  in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if self.contactListViewModel.isLoading {
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                }
            }
        }
        
        contactListViewModel.reloadCollectionViewClosure = { [weak self]  in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        contactListViewModel.fetchContact()
    }
    
    private func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
