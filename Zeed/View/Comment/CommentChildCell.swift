//
//  CommentChildCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 19/04/21.
//

import UIKit

class CommentChildCell: CommentCell {
    //MARK: - Properties
    
    override var comment: Comment? {
        didSet{
            guard let comment = comment else { return }
            
            commentOwnerLabel.text = comment.owner.userName.lowercased()
            commentLabel.text = comment.text
            timeLabel.text = comment.createdAt.timeAgo().uppercased()
            childProfileImageView.setUserImageUsingUrl( comment.owner.image.url)
            
            isVerifiedStore.isHidden = !comment.owner.isSeller
            isVerified.isHidden = !comment.owner.isVerified
            
            likeButton.isSelected = comment.liked
        }
    }
    
    //MARK: - UI Elements
    private lazy var childProfileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        iv.setDimensions(height: 35, width: 35)
        iv.layer.cornerRadius = 35/2
        
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleUsernameTapped))
        iv.addGestureRecognizer(tap)

        
        return iv
    }()
    
    //MARK: - Helper Functions
    override func configureUI() {
        let timeReplyStack = UIStackView(arrangedSubviews: [timeLabel])
        timeReplyStack.alignment = .center
        timeReplyStack.axis = .horizontal
        timeReplyStack.distribution = .fillProportionally
        timeReplyStack.spacing = 8
        timeReplyStack.anchor(height: 20)
        
        let ownerInfoStack = UIStackView(arrangedSubviews: [commentOwnerLabel, isVerified, isVerifiedStore])
        ownerInfoStack.axis = .horizontal
        ownerInfoStack.alignment = .center
        ownerInfoStack.spacing = 8
        ownerInfoStack.distribution = .fill
        
        let commentTimeStack = UIStackView(arrangedSubviews: [ownerInfoStack, commentLabel, timeReplyStack])
        commentTimeStack.axis = .vertical
        commentTimeStack.distribution = .fillProportionally
        commentTimeStack.alignment = .leading
        commentTimeStack.spacing = 3
        
        likeButton.setDimensions(height: 15, width: 15)
        
        let mainStack = UIStackView(arrangedSubviews: [childProfileImageView, commentTimeStack])
        mainStack.alignment = .leading
        mainStack.distribution = .fillProportionally
        mainStack.axis = .horizontal
        mainStack.spacing = 10
        
        contentView.addSubview(mainStack)
        mainStack.anchor(width: frame.width - 45 - 8)
        mainStack.fillSuperview(padding: UIEdgeInsets(top: 8, left: 45, bottom: 8, right: 8))
    }
}
