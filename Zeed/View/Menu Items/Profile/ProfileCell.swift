//
//  ProfileCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 15/03/21.
//

import UIKit

class ProfileCell: UICollectionViewCell {
    //MARK: - Properties
    var profileCellType: ProfileBuyerItems? {
        didSet {
            guard let type = profileCellType else { return }
            profileItemImage.image = type.image
            subCategoryName.text = type.description
        }
    }
    
    var settingsCellType: SettingsItems? {
        didSet {
            guard let type = settingsCellType else { return }
            profileItemImage.image = type.image
            subCategoryName.text = type.description
        }
    }
    var privacyCellType: PrivacyItems? {
        didSet {
            guard let type = privacyCellType else { return }
            profileItemImage.image = type.image
            subCategoryName.text = type.description
        }
    }

    var supportCellType: SupportItem? {
        didSet {
            guard let type = supportCellType else { return }
            profileItemImage.image = type.image
            subCategoryName.text = type.description
        }
    }

    let profileItemImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .appPrimaryColor
        return iv
    }()
    
    let subCategoryName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        return label
    }()

    
    let swich: UISwitch = {
        let swich = UISwitch()
        swich.isUserInteractionEnabled = false
        return swich
    }()

    //MARK: - UI Elements
    
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helper Functions
    
    func configureCell() {
        backgroundColor = .white
        layer.cornerRadius = frame.height/2
        addShadow()
        
        addSubview(profileItemImage)
        profileItemImage.anchor(left: leftAnchor, paddingLeft: (frame.height/2) - (22/2))
        profileItemImage.centerY(inView: self)
        
        profileItemImage.setDimensions(height: 22, width: 22)
        profileItemImage.layer.cornerRadius = 22/2

        addSubview(subCategoryName)
        subCategoryName.anchor(left: profileItemImage.rightAnchor, right: contentView.rightAnchor, paddingLeft: (frame.height/2) - 15, paddingRight: (frame.height/2) - 20)
        subCategoryName.centerY(inView: self)
        
        
        addSubview(swich)
        swich.isHidden = true
        swich.anchor(right: self.rightAnchor, paddingRight: 20)
        swich.centerY(inView: self)


        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

        
    }
}



