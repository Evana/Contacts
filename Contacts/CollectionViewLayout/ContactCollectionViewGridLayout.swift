//
//  ContactCollectionViewGridLayout.swift
//  Contacts
//
//  Created by Evana Islam on 2/3/19.
//  Copyright © 2019 Evana Islam. All rights reserved.
//

import UIKit

struct ContactCollectionViewGridLayout {
    
    let spacingBetweenCells: CGFloat
    let cellSize: CGFloat
    let cellsPerRow: Int
    
    init(sizeClass: CollectionViewSizeClass, edgeInsets: UIEdgeInsets, gridWidth: CGFloat, desiredCellWidth: CGFloat) {
        spacingBetweenCells = 10.0
        let availableGridWidth = gridWidth - edgeInsets.left - edgeInsets.right
        cellsPerRow = sizeClass == .regular ? 2 : 1
        cellSize = floor(availableGridWidth / CGFloat(cellsPerRow) - spacingBetweenCells / 2)
    }
}
