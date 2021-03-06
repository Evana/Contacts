//
//  ContactCollectionViewCell.swift
//  TestCollectionView
//
//  Created by Evana Islam on 2/3/19.
//  Copyright © 2019 Evana Islam. All rights reserved.
//

import UIKit
import SnapKit

class ContactCollectionViewCell: UICollectionViewCell {
    private lazy var avatarImageView: UIImageView! = {
        let avatarImageView = UIImageView()
        avatarImageView.backgroundColor = .gray
        contentView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.left.equalTo(20)
            make.height.equalTo(contentView).multipliedBy(1.0/2.0)
            make.width.equalTo(contentView.snp.height).multipliedBy(1.0/2.0)
        }
        return avatarImageView
    }()
    
    private lazy var favoriteButton: UIButton! = {
        let favoriteButton = UIButton()
        contentView.addSubview(favoriteButton)
        favoriteButton.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
            make.height.width.equalTo(50)
        }
        favoriteButton.setImage(UIImage(named: "favorite"), for: .normal)
        favoriteButton.addTarget(self, action: #selector(tappedOnFavorite), for: .touchUpInside)
        return favoriteButton
    }()
    
    private lazy var nameLabel: UILabel! = {
        let label = UILabel()
        contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(avatarImageView.snp.bottom).offset(10).priority(.medium)
            make.left.equalTo(20)
            make.height.equalTo(20)
            make.right.equalTo(favoriteButton.snp.left).offset(-10)
        }
        return label
    }()
    
    private lazy var emailLabel: UILabel! = {
        let label = UILabel()
        contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalTo(20)
            make.height.equalTo(20)
            make.right.equalTo(favoriteButton.snp.left).offset(-10)
            make.bottom.equalTo(contentView).offset(-10)
        }
        return label
    }()
    
    var btnTapAction : (() -> ())?
    
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    var email: String? {
        didSet {
            emailLabel.text = email
        }
    }
    
    var isFavorite: Bool? {
        didSet {
            favoriteButton.tintColor = isFavorite ?? false ?  .red : .lightGray
        }
    }
    
    var avatarImage: String? {
        didSet {
            avatarImageView.image = UIImage(named: avatarImage ?? "")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateButtonColor (_ isHighlighted: Bool) {
        favoriteButton.tintColor = isHighlighted ?  .red : .lightGray
    }
    
    private func setupView() {
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.gray.cgColor
    }
    
    @objc func tappedOnFavorite() {
        btnTapAction?()
    }
}
