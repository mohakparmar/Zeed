//
//  BiddingLiveBiddersCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 05/04/21.
//
import UIKit

class BiddingLiveBiddersCell: UICollectionViewCell {
    //MARK: - Properties
    var bidder: BidMadeUser? {
        didSet {
            guard let bidder = bidder else { return }
            profileImageView.setUserImageUsingUrl( bidder.image.url)
            usernameLabel.text = bidder.userName
            bidAmountLabel.text = "\(bidder.bidAmount) KWD"
            
            isVerifiedStore.isHidden = !bidder.isSeller
            isVerified.isHidden = !bidder.isVerified
            
            if bidder.id == AppUser.shared.getDefaultUser()?.id {
                usernameLabel.textColor = .systemGreen
            } else {
                usernameLabel.textColor = .black
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
    
    private let bidAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
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

    
    //MARK: - Helper Functions
    
    func configureUI(){
        backgroundColor = .backgroundWhiteColor
        
        let stack = UIStackView(arrangedSubviews: [profileImageView, usernameLabel, isVerified, isVerifiedStore, bidAmountLabel])
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
    }
}

