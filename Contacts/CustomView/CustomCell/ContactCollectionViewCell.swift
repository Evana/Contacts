//
//  ContactCollectionViewCell.swift
//  TestCollectionView
//
//  Created by Evana Islam on 2/3/19.
//  Copyright © 2019 Evana Islam. All rights reserved.
//

import UIKit

class ContactCollectionViewCell: UICollectionViewCell {
    var avatarImageView: UIImageView!
    var nameLabel: UILabel!
    var emailLabel: UILabel!
    @objc var favoriteButton: UIButton!
    var btnTapAction : (() -> ())?
    
    var contactCellViewModel : ContactCellViewModel? {
        didSet {
            nameLabel.text = contactCellViewModel?.name
            emailLabel.text = contactCellViewModel?.email
            avatarImageView.image = UIImage(named: contactCellViewModel?.avatarImage ?? "")
            favoriteButton.tintColor = contactCellViewModel?.isFavorite ?? false ?  .red : .lightGray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateButtonColor (_ isHighlighted: Bool) {
        favoriteButton.tintColor = isHighlighted ?  .red : .lightGray
    }
    
    private func setupLayout() {
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.gray.cgColor
        let imageContainerView = UIView()
        let infoView = UIView()
        let stackView = UIStackView()
        
        self.contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        stackView.spacing = 5
        
        stackView.addArrangedSubview(imageContainerView)
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        imageContainerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 2/3).isActive = true
        avatarImageView = UIImageView(frame: CGRect.zero)
        imageContainerView.addSubview(avatarImageView)
        avatarImageView.backgroundColor = .gray
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        avatarImageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor, constant: 20.0).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor, constant: 20.0).isActive = true
        avatarImageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: -10.0).isActive = true
        
        avatarImageView.heightAnchor.constraint(equalTo: imageContainerView.heightAnchor, multiplier: 8.0/10.0).isActive = true
        avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor, multiplier: 1.0).isActive = true
        
        stackView.addArrangedSubview(infoView)
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 1/3).isActive = true
        setupInfoLayout(for: infoView)
    }
    
    private func setupInfoLayout(for view: UIView) {
        favoriteButton = UIButton()
        view.addSubview(favoriteButton)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 3/4).isActive = true
        favoriteButton.widthAnchor.constraint(equalTo: favoriteButton.heightAnchor, multiplier: 1.0).isActive = true
        favoriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        favoriteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        favoriteButton.setImage(UIImage(named: "favorite"), for: .normal)
        favoriteButton.addTarget(self, action: #selector(tappedOnFavorite), for: .touchUpInside)
        
        nameLabel = UILabel(frame: CGRect.zero)
        emailLabel = UILabel(frame: CGRect.zero)
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 7).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant:-10).isActive = true
        nameLabel.font = UIFont.preferredFont(forTextStyle: .body)
        nameLabel.numberOfLines = 0
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0).isActive = true
        emailLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        emailLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant:-10).isActive = true
        emailLabel.font = UIFont.preferredFont(forTextStyle: .body)
        emailLabel.numberOfLines = 0
    }
    
    @objc func tappedOnFavorite() {
        if let isFavorite = contactCellViewModel?.isFavorite {
            contactCellViewModel?.isFavorite = !isFavorite
            updateButtonColor(!isFavorite)
            btnTapAction?()
        }
    }
}
