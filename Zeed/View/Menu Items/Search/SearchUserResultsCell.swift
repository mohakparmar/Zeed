//
//  SearchUserResultsCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 04/03/21.
//
import UIKit

protocol SearchUserResultsCellDelegate: AnyObject {
    func didTapFollowButton(button: UIButton, cell: SearchUserResultsCell)
}

class SearchUserResultsCell: UICollectionViewCell {
    //MARK: - Properties
    weak var delegate: SearchUserResultsCellDelegate?
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            usernameLabel.text = user.userName
            profileImageView.setUserImageUsingUrl(user.image.url)
            
            isVerifiedStore.isHidden = !user.isSeller
            isVerified.isHidden = !user.isVerified
            
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
    lazy var profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.image = #imageLiteral(resourceName: "ic_retry")
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .random
        
        iv.setDimensions(height: 45, width: 45)
        iv.layer.cornerRadius = 45/2
        return iv
    }()
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    lazy var followButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .gradientSecondColor
        
        button.setTitle(appDele!.isForArabic ? Follow_ar : Follow_en, for: .normal)
        button.setTitle(appDele!.isForArabic ? Following_ar : Following_en, for: .selected)
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gradientSecondColor, for: .selected)
        
        button.layer.cornerRadius = 8
        button.setDimensions(height: 40, width: 100)
        
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gradientSecondColor.cgColor
        
        button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var isVerified: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "tick_verified")
        iv.contentMode = .scaleAspectFit
        
        iv.setDimensions(height: 20, width: 20)
        
        return iv
    }()
    
    private lazy var isVerifiedStore: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "store_verified")
        iv.contentMode = .scaleAspectFit
        
        iv.setDimensions(height: 20, width: 20)
        
        return iv
    }()
    
    private let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        return view
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selector
    @objc func handleFollowTapped(sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            followButton.backgroundColor = .white
        } else {
            followButton.backgroundColor = .gradientSecondColor
        }
        
        delegate?.didTapFollowButton(button: sender, cell: self)
    }
    
    //MARK: - Helper Functions
    
    func configureUI(){
        backgroundColor = .backgroundWhiteColor
        
        let stack = UIStackView(arrangedSubviews: [profileImageView, usernameLabel, isVerified, isVerifiedStore, followButton])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 8
        stack.distribution = .fill
        stack.setCustomSpacing(18, after: isVerifiedStore)
        stack.setDimensions(height: 50, width: frame.width - 15)
        
        addSubview(stack)
        stack.centerX(inView: self)
        stack.centerY(inView: self)
        
        addSubview(seperatorView)
        seperatorView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 55, height: 1)
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }


    }
}
