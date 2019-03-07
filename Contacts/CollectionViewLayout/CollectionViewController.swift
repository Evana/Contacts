//
//  CollectionViewController.swift
//  Contacts
//
//  Created by Evana Islam on 2/3/19.
//  Copyright © 2019 Evana Islam. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {
    
    var collectionView: UICollectionView!
    
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
        if previousTraitCollection != nil {
            
            collectionView.reloadData()
        }
        super.traitCollectionDidChange(previousTraitCollection)
        
        if let currentIndexPath = currentIndexPath {
            collectionView.scrollToItem(at: currentIndexPath as IndexPath, at: .centeredVertically, animated: false)
            self.currentIndexPath = nil
        }
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
}
