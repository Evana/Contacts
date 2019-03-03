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
        self.title = "Contacts"
        initialiseViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSegmentControl()
        setupCollectionView()
        setupShowMoreButton()
        setupActivityIndicator()
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
    
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .gray
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
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
        segmentedControl.addTarget(self, action: #selector(ContactListViewController.indexChanged(_:)), for: .valueChanged)
    }
    
    func setupShowMoreButton() {
        showMoreButton = CustomUIButton(buttonTitle, for: .normal)
        view.addSubview(showMoreButton)
        showMoreButton.translatesAutoresizingMaskIntoConstraints = false
        showMoreButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        showMoreButton.widthAnchor.constraint(equalToConstant: 260).isActive = true
        showMoreButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        showMoreButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        showMoreButton.addTarget(self, action: #selector(showMore(_:)), for: .touchUpInside)
        showMoreButton.isHidden = true
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
                self.showMoreButton.isHidden = false
            }
        }
        contactListViewModel.fetchContact()
    }
    
    private func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            contactListViewModel.isFavorite = false
            showMoreButton.isEnabled = true
        case 1:
            contactListViewModel.isFavorite = true
            showMoreButton.isEnabled = false
        default:
            break
        }
    }
    
    @IBAction func showMore(_ sender: UIButton) {
        sender.isEnabled = contactListViewModel.loadMoreCell()
    }
    
}

extension ContactListViewController:  UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contactListViewModel.numberOfCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath as IndexPath) as! ContactCollectionViewCell
        let cellVm = contactListViewModel.getCellViewModel( at: indexPath )
        cell.contactCellViewModel = cellVm
        cell.btnTapAction = { [weak self]  in
            self?.contactListViewModel.updateFavorite(for: indexPath)
        }
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
