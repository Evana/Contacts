//
//  ContactListViewController.swift
//  Contacts
//
//  Created by Evana Islam on 2/3/19.
//  Copyright © 2019 Evana Islam. All rights reserved.
//

import UIKit
import SnapKit

class ContactListViewController: CollectionViewController {
    
    let componentColor =  UIColor.init(red: 46.0/255.0, green: 172.0/255.0, blue: 246.0/255.0, alpha: 1.0)
    let buttonTitle = "Show More"
    let cellReuseIdentifier = "contactCell"
    
    lazy var segmentedControl: UISegmentedControl! = {
        let items = ["All" , "Favorites"]
        let segmentedControl = UISegmentedControl(items : items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.layer.cornerRadius = 5.0
        segmentedControl.frame = CGRect.zero
        segmentedControl.tintColor = componentColor
        return segmentedControl
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView! = {
        var indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.hidesWhenStopped = true
        indicator.color = .gray
        indicator.center = view.center
        return indicator
    }()
    
    var flowLayout: ContactCollectionViewFlowLayout!

    var contactListViewModel: ContactListViewModel = {
        return ContactListViewModel()
    }()
    
    var gridWith: CGFloat {
        return self.traitCollection.horizontalSizeClass == .regular ? UIScreen.main.bounds.size.width - 20 : (UIDevice.current.orientation == .portrait ? UIScreen.main.bounds.size.width - 20 : UIScreen.main.bounds.size.width/2 + 10)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Contacts"
        initialiseViewModel()
        setupView()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateSizeClassesLayout()
        collectionView.collectionViewLayout.invalidateLayout()
        view.layoutIfNeeded()
        
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        //ActivityIndicator
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints{ make in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view)
        }
        activityIndicator.startAnimating()
        
        //SegmentControl
        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(self.view).offset(0)
            make.width.equalTo(300)
            make.height.equalTo(35)
            make.centerX.equalTo(view.snp.centerX)
        }
        segmentedControl.addTarget(self, action: #selector(ContactListViewController.indexChanged(_:)), for: .valueChanged)

        
        //CollectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ContactCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.backgroundColor = .white
        view.addSubview(collectionView!)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo((segmentedControl?.snp.bottom)!)
            make.left.equalTo(view).offset(0)
            make.right.equalTo(view).offset(0)
            make.bottom.equalTo(view).offset(0)
        }
        
    }
    
    func updateSizeClassesLayout() {
        let sizeClass = CollectionViewSizeClass(traitCollection: self.traitCollection)
        flowLayout = ContactCollectionViewFlowLayout(gridWidth: gridWith, sizeClass: sizeClass)
        if let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionViewLayout.sectionInset = flowLayout.edgeInsets
        }
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
        case 1:
            contactListViewModel.isFavorite = true
        default:
            break
        }
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
