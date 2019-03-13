//
//  UIViewController+Alert.swift
//  Contacts
//
//  Created by Evana Islam on 13/3/19.
//  Copyright © 2019 Evana Islam. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
