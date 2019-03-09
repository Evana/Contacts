//
//  CollectionViewController.swift
//  Contacts
//
//  Created by Evana Islam on 2/3/19.
//  Copyright © 2019 Evana Islam. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {
    
    lazy var collectionView: UICollectionView! = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        
        layout.itemSize =  self.traitCollection.horizontalSizeClass == .regular ?
            CGSize(width: UIScreen.main.bounds.size.width/2 - 20, height:  250)
            : CGSize(width: UIScreen.main.bounds.size.width - 20, height:  250)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private var currentIndexPath: IndexPath?
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let visibleIndexPaths = collectionView.indexPathsForVisibleItems
        if visibleIndexPaths.count > 0 {
            currentIndexPath = visibleIndexPaths[visibleIndexPaths.count / 2]
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
