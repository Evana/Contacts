//
//  CollectionViewSizeClass.swift
//  Contacts
//
//  Created by Evana Islam on 2/3/19.
//  Copyright © 2019 Evana Islam. All rights reserved.
//

import UIKit

enum CollectionViewSizeClass: String {
    case compact = "compact"
    case regular = "regular"
    
    init(traitCollection: UITraitCollection) {
        self = traitCollection.horizontalSizeClass == .regular
            ? .regular
            : .compact
    }
}
