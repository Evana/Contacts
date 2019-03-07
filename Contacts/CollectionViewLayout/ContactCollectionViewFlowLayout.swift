//
//  ContactCollectionViewFlowLayout.swift
//  Contacts
//
//  Created by Evana Islam on 2/3/19.
//  Copyright © 2019 Evana Islam. All rights reserved.
//

import UIKit

class ContactCollectionViewFlowLayout: NSObject, UICollectionViewDelegateFlowLayout {
    
    let sizeClass: CollectionViewSizeClass
    let edgeInsets: UIEdgeInsets
    let contactGridLayout: ContactCollectionViewGridLayout
    
    init(gridWidth: CGFloat, sizeClass: CollectionViewSizeClass) {
        self.sizeClass = sizeClass
        self.edgeInsets = sizeClass == .regular ? UIEdgeInsets(top: 15, left: 25, bottom: 10, right: 10) : UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let desiredCellSize: CGFloat = sizeClass == .regular ? gridWidth/2 : gridWidth
        contactGridLayout = ContactCollectionViewGridLayout(sizeClass: sizeClass, edgeInsets: edgeInsets, gridWidth: gridWidth, desiredCellSize: desiredCellSize)
    }
    
    // MARK: Grid Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: contactGridLayout.cellSize, height: contactGridLayout.cellSize * 1/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return contactGridLayout.spacingBetweenCells
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}
