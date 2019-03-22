//
//  UIViewController+Alert.swift
//  Contacts
//
//  Created by Evana Islam on 13/3/19.
//  Copyright © 2019 Evana Islam. All rights reserved.
//

import UIKit

protocol Alertable {
    func showAlert( _ message: String )
}

extension Alertable where Self: UIViewController {
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
