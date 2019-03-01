//
//  ApplicationWindowSize.swift
//  Contacts
//
//  Created by Evana Islam on 2/3/19.
//  Copyright © 2019 Evana Islam. All rights reserved.
//

import UIKit

class ApplicationWindowSize: NSObject {
    class var windowSize: CGSize {
        
        if let delegate = UIApplication.shared.delegate, let window = delegate.window {
            return window!.frame.size
        }
        return UIScreen.main.bounds.size
    }
}

