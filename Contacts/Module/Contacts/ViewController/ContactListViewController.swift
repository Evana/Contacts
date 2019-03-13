//
//  ContactListViewController.swift
//  Contacts
//
//  Created by Evana Islam on 2/3/19.
//  Copyright © 2019 Evana Islam. All rights reserved.
//

import UIKit
import SnapKit

class ContactListViewController: UIViewController {
    
    let componentColor =  UIColor(rgb: 0x2EACF6)
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
    
    lazy var collectionView: UICollectionView! = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize =  self.traitCollection.horizontalSizeClass == .regular ?
            CGSize(width: UIScreen.main.bounds.size.width/2 - 20, height:  250)
            : CGSize(width: UIScreen.main.bounds.size.width - 20, height:  250)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(ContactCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        return collectionView
    }()
    
    private var currentIndexPath: IndexPath?
    
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
        
        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(self.view).offset(0)
            make.width.equalTo(300)
            make.height.equalTo(35)
            make.centerX.equalTo(view.snp.centerX)
        }
        segmentedControl.addTarget(self, action: #selector(ContactListViewController.indexChanged(_:)), for: .valueChanged)
        
        view.addSubview(collectionView)
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
                    self.showLoader()
                } else {
                    self.hideLoader()
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
            guard let self = self else { return }
            self.contactListViewModel.updateFavorite(for: indexPath)
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

extension ContactListViewController {
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let visibleIndexPaths = collectionView.indexPathsForVisibleItems
        if visibleIndexPaths.count > 0 {
            currentIndexPath = visibleIndexPaths[visibleIndexPaths.count-1]
        }
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection != nil {
            collectionView.reloadData()
        }
        if let currentIndexPath = currentIndexPath {
            collectionView.scrollToItem(at: currentIndexPath as IndexPath, at: .centeredVertically, animated: false)
            self.currentIndexPath = nil
        }
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
}
