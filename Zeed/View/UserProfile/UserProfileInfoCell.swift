//
//  UserProfileInfoCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 04/03/21.
//

import UIKit

protocol UserProfileInfoCellDelegate: AnyObject {
    func handleOptionsTapped()
}

class UserProfileInfoCell: UITableViewCell {
    //MARK: - Properties
    weak var delegate: UserProfileInfoCellDelegate?
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            
            userProfileImageView.setUserImageUsingUrl(user.image.url)
            if user.storeDetails.shopName == "" {
                storeNameLabel.text = user.fullName
            } else {
                storeNameLabel.text = user.storeDetails.shopName
            }
            
            storeDescriptionLabel.text = user.about
            
            isVerifiedStore.isHidden = !user.isSeller
            isVerified.isHidden = !user.isVerified
        }
    }
    
    //MARK: - UI Elements
    private let userProfileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        
        iv.backgroundColor = .random
        
        return iv
    }()
    
    private let storeNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        
        label.anchor(height: 22)
        
        return label
    }()
    
    private let storeDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "The App Store is a digital distribution platform, developed and maintained by Apple Inc., for mobile apps on its iOS & iPadOS operating systems. The store allows users to browse and download apps developed with Apple's iOS Software Development Kit."
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.textColor = UIColor.black.withAlphaComponent(0.8)
        return label
    }()
    
    lazy var optionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "menu_options"), for: .normal)
        button.tintColor = .black
        button.imageView!.contentMode = .scaleAspectFit
        button.imageView!.setDimensions(height: 33, width: 18)
        
        button.addTarget(self, action: #selector(handleOptionTapped), for: .touchUpInside)
        
        button.setDimensions(height: 33, width: 30)
        return button
    }()
    
    lazy var isVerified: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "tick_verified")
        iv.contentMode = .scaleAspectFit
        
        iv.setDimensions(height: 20, width: 20)
        
        return iv
    }()
    
    lazy var isVerifiedStore: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "store_verified")
        iv.contentMode = .scaleAspectFit
        
        iv.setDimensions(height: 20, width: 20)
        
        return iv
    }()
    
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func handleOptionTapped() {
        delegate?.handleOptionsTapped()
    }
    
    //MARK: - Helper Functions
    func configureCell() {
        backgroundColor = .appBackgroundColor
        selectionStyle = .none

        let ownerInfoStack = UIStackView(arrangedSubviews: [storeNameLabel, isVerified, isVerifiedStore])
        ownerInfoStack.axis = .horizontal
        ownerInfoStack.alignment = .center
        ownerInfoStack.spacing = 8
        ownerInfoStack.distribution = .fill
        
        let userDetailsStack = UIStackView(arrangedSubviews: [ownerInfoStack, storeDescriptionLabel])
        userDetailsStack.axis = .vertical
        userDetailsStack.spacing = 4
        userDetailsStack.distribution = .fillProportionally
        userDetailsStack.alignment = .leading

        let imageAndDetailsStack = UIStackView(arrangedSubviews: [userProfileImageView, userDetailsStack])
        imageAndDetailsStack.spacing = 15
        imageAndDetailsStack.alignment = .leading
        imageAndDetailsStack.distribution = .fill

        userProfileImageView.setDimensions(height: 55, width: 55)
        userProfileImageView.layer.cornerRadius = 55/2

        contentView.addSubview(imageAndDetailsStack)
        imageAndDetailsStack.fillSuperview(padding: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
        
        addSubview(optionButton)
        optionButton.anchor(top: topAnchor, right: imageAndDetailsStack.rightAnchor, paddingTop: 6)
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
}
