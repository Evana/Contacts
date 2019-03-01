//
//  ContactListViewController.swift
//  Contacts
//
//  Created by Evana Islam on 2/3/19.
//  Copyright © 2019 Evana Islam. All rights reserved.
//

import UIKit

class ContactListViewController: CollectionViewController {
    
    let componentColor =  UIColor.init(red: 46.0/255.0, green: 172.0/255.0, blue: 246.0/255.0, alpha: 1.0)
    let buttonTitle = "Show More"
    let cellReuseIdentifier = "contactCell"
    
    var segmentedControl: UISegmentedControl!
    var showMoreButton: CustomUIButton!
    var activityIndicator: UIActivityIndicatorView!
    
    var flowLayout: ContactCollectionViewFlowLayout!

    var contactListViewModel: ContactListViewModel = {
        return ContactListViewModel()
    }()
    
    var gridWith: CGFloat {
        return self.traitCollection.horizontalSizeClass == .regular ? ApplicationWindowSize.windowSize.width - 20 : (UIDevice.current.orientation == .portrait ? ApplicationWindowSize.windowSize.width - 20 : ApplicationWindowSize.windowSize.width/2 + 10)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSegmentControl()
        setupCollectionView()
        setupShowMoreButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateSizeClassesLayout()
        collectionView.collectionViewLayout.invalidateLayout()
        view.layoutIfNeeded()
        
    }
    
    func updateSizeClassesLayout() {
        let sizeClass = CollectionViewSizeClass(traitCollection: self.traitCollection)
        flowLayout = ContactCollectionViewFlowLayout(gridWidth: gridWith, sizeClass: sizeClass)
        if let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionViewLayout.sectionInset = flowLayout.edgeInsets
        }
    }
    
    private func setupSegmentControl() {
        view.backgroundColor = .white
        let items = ["All" , "Favorites"]
        segmentedControl = UISegmentedControl(items : items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.layer.cornerRadius = 5.0
        let frame = UIScreen.main.bounds
        segmentedControl.frame = CGRect(x: frame.minX + 10, y: 10,
                                        width: frame.width - 40, height: 50)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.tintColor = componentColor
        view.addSubview(segmentedControl)
        
        if #available(iOS 11.0, *) {
            let guide = self.view.safeAreaLayoutGuide
            segmentedControl.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -30).isActive = true
            segmentedControl.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 30).isActive = true
            segmentedControl.topAnchor.constraint(equalTo: guide.topAnchor, constant: 10).isActive = true
        } else {
            NSLayoutConstraint(item: segmentedControl,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: view, attribute: .top,
                               multiplier: 1.0, constant: 10).isActive = true
            NSLayoutConstraint(item: segmentedControl,
                               attribute: .leading,
                               relatedBy: .equal, toItem: view,
                               attribute: .leading,
                               multiplier: 1.0,
                               constant: 30).isActive = true
            NSLayoutConstraint(item: segmentedControl, attribute: .trailing,
                               relatedBy: .equal,
                               toItem: view,
                               attribute: .trailing,
                               multiplier: 1.0,
                               constant: -30).isActive = true
        }
        segmentedControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupShowMoreButton() {
        showMoreButton = CustomUIButton(buttonTitle, for: .normal)
        view.addSubview(showMoreButton)
        showMoreButton.translatesAutoresizingMaskIntoConstraints = false
        showMoreButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        showMoreButton.widthAnchor.constraint(equalToConstant: 260).isActive = true
        showMoreButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        showMoreButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        
        layout.itemSize =  self.traitCollection.horizontalSizeClass == .regular ?
            CGSize(width: ApplicationWindowSize.windowSize.width/2 - 20, height:  250)
            : CGSize(width: ApplicationWindowSize.windowSize.width - 20, height:  250)
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ContactCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.backgroundColor = .white
        self.view.addSubview(collectionView!)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 5).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
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

extension ContactListViewController:  UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath as IndexPath) as! ContactCollectionViewCell
       
        return cell
    }
    
}

extension ContactListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return flowLayout.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return flowLayout.collectionView(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return flowLayout.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: section)
    }
    
}