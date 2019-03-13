//
//  UIColor+rgb.swift
//  Contacts
//
//  Created by Evana Islam on 13/3/19.
//  Copyright © 2019 Evana Islam. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(rgb rgbValue: Int, alpha: Float = 1) {
        let r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgbValue & 0xFF00) >> 8) / 255.0
        let b = CGFloat(rgbValue & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
