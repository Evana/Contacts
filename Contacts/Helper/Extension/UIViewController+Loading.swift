//
//  UIViewController+Loading.swift
//  Contacts
//
//  Created by Evana Islam on 13/3/19.
//  Copyright © 2019 Evana Islam. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showLoader() {
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.startAnimating()
        let barButtonItem = UIBarButtonItem(customView: activityIndicatorView)
        navigationItem.setRightBarButton(barButtonItem, animated: true)
    }
    
    func hideLoader() {
        navigationItem.rightBarButtonItem = nil
    }
}
