//
//  UserProfileActionButtonsCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 04/03/21.
//

import UIKit

protocol UserProfileActionButtonsCellDelegate: AnyObject {
    func followTapped(cell: UserProfileActionButtonsCell)
    func messageTapped(cell: UserProfileActionButtonsCell)
    func editProfileTapped(cell: UserProfileActionButtonsCell)
}

class UserProfileActionButtonsCell: UITableViewCell {
    //MARK: - Properties
    weak var delegate: UserProfileActionButtonsCellDelegate?
    
    enum ActionButtonType {
        case editButton
        case followStack
    }
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            
            if user.id == loggedInUser?.id {
                configureCell(with: .editButton)
            } else {
                configureCell(with: .followStack)
            }
            
            followButton.isSelected = user.followStatus
            
            if user.requestStatus {
                followButton.isSelected = true
                followButton.backgroundColor = .white
                followButton.setTitle(appDele!.isForArabic ? Requested_ar : Requested_en, for: .selected)
            }
            
            if followButton.isSelected {
                followButton.backgroundColor = .white
            } else {
                followButton.backgroundColor = .gradientSecondColor
            }
            
        }
    }
    
    //MARK: - UI Elements
    private lazy var followButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .gradientSecondColor
        
        button.setTitle(appDele!.isForArabic ? Follow_ar : Follow_en, for: .normal)
        button.setTitle(appDele!.isForArabic ? Following_ar : Following_en, for: .selected)
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gradientSecondColor, for: .selected)
        
        button.layer.cornerRadius = 8
        
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gradientSecondColor.cgColor
        
        button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var messageButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .gradientSecondColor
        button.setTitle(appDele!.isForArabic ? Message_ar : Message_en, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        
        button.addTarget(self, action: #selector(handleMessageTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var editMyProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(appDele!.isForArabic ? Edit_Profile_ar : Edit_Profile_en, for: .normal)
        button.setTitleColor(.appPrimaryColor, for: .normal)
        button.layer.cornerRadius = 8
        
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gradientSecondColor.cgColor
        
        button.addTarget(self, action: #selector(handleEditMyProfileTapped), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func handleFollowTapped(sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            followButton.backgroundColor = .white
        } else {
            followButton.backgroundColor = .gradientSecondColor
        }
        
        delegate?.followTapped(cell: self)
    }
    
    @objc func handleMessageTapped() {
        delegate?.messageTapped(cell: self)
    }    
    
    @objc func handleEditMyProfileTapped() {
        delegate?.editProfileTapped(cell: self)
    }
    
    //MARK: - Helper Functions
    func configureCell(with type: ActionButtonType) {
        backgroundColor = .appBackgroundColor
        selectionStyle = .none
        
        let mainStack = UIStackView(arrangedSubviews: type == .editButton ? [editMyProfileButton] : [followButton, messageButton])
        mainStack.axis = .horizontal
        mainStack.distribution = .fillEqually
        mainStack.spacing = 8
        
        contentView.addSubview(mainStack)
        mainStack.fillSuperview(padding: UIEdgeInsets(top: 12, left: 25, bottom: 12, right: 25))
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
}
