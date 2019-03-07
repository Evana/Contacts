//
//  CustomUIButton.swift
//  TestCollectionView
//
//  Created by Evana Islam on 2/3/19.
//  Copyright © 2019 Evana Islam. All rights reserved.
//

import UIKit

class CustomUIButton: UIButton {
    
    let color =  UIColor.init(red: 46.0/255.0, green: 172.0/255.0, blue: 246.0/255.0, alpha: 1.0)
    
    override var isEnabled: Bool {
        didSet {
            setBackgroundForEnabled(isEnabled)
            setAlphaForEnabled(isEnabled)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init (_ title: String, for state: UIControl.State) {
        self.init()
        setTitle(title, for: state)
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        setup()
    }
    
    private func setup() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
        titleLabel?.lineBreakMode = .byTruncatingTail
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        backgroundColor = color
    }
    
    private func setBackgroundForEnabled(_ isEnabled: Bool) {
        self.backgroundColor = isEnabled ? color : .gray
    }
    
    private func setAlphaForEnabled(_ isEnabled: Bool) {
        self.alpha = isEnabled ? 1.0 : 0.3
    }
}
