//
//  CommentCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 13/03/21.
//

import UIKit
import SwipeCellKit

protocol CommentCellDelgate: AnyObject {
    func didTapLike(forComment comment: Comment, cell: CommentCell)
    func didTapReply(forComment comment: Comment, cell: CommentCell)
    func didTapDelete(forComment comment: Comment, cell: CommentCell)
    func didTapProfile(forComment comment: Comment, cell: CommentCell)
}

class CommentCell: SwipeCollectionViewCell {
    //MARK: - Properties
    weak var commentCelldelegate: CommentCellDelgate?
    
    var comment: Comment? {
        didSet{
            guard let comment = comment else { return }
            
            commentOwnerLabel.text = comment.owner.userName.lowercased()
            commentLabel.text = comment.text
            timeLabel.text = comment.createdAt.timeAgo().uppercased()
            profileImageView.setUserImageUsingUrl( comment.owner.image.url)
            likeButton.isSelected = comment.liked
            isVerifiedStore.isHidden = !comment.owner.isSeller
            isVerified.isHidden = !comment.owner.isVerified
            likeCountLabel.text = "\(comment.likeCount)"
        }
    }
    
    //MARK: - UI Elements
    
    lazy var profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        iv.setDimensions(height: 50, width: 50)
        iv.layer.cornerRadius = 50/2
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleUsernameTapped))
        iv.addGestureRecognizer(tap)

        return iv
    }()
    
    let commentOwnerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()

    let commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.darkGray.withAlphaComponent(0.7)
        return label
    }()
    
    lazy var replyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(appDele!.isForArabic ? Reply_ar : Reply_en , for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        
        button.addTarget(self, action: #selector(handleReplyTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "like").withRenderingMode(.alwaysTemplate), for: .normal)
        button.setImage(#imageLiteral(resourceName: "liked").withRenderingMode(.alwaysTemplate), for: .selected)
        
        button.tintColor = .red
        
        button.imageView?.contentMode = .scaleAspectFit
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    }()
    
    let likeCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .light)
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.textAlignment = .center
        return label
    }()

    lazy var isVerified: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "tick_verified")
        iv.contentMode = .scaleAspectFit
        
        iv.setDimensions(height: 15, width: 15)
        
        return iv
    }()
    
    lazy var isVerifiedStore: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "store_verified")
        iv.contentMode = .scaleAspectFit
        
        iv.setDimensions(height: 15, width: 15)
        
        return iv
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
    @objc func handleLikeTapped() {
        guard let comment = comment else { return }
        commentCelldelegate?.didTapLike(forComment: comment, cell: self)
    }
    
    @objc func handleDeleteTapped() {
        guard let comment = comment else { return }
        commentCelldelegate?.didTapDelete(forComment: comment, cell: self)
    }
    
    @objc func handleReplyTapped() {
        guard let comment = comment else { return }
        commentCelldelegate?.didTapReply(forComment: comment, cell: self)
    }
    
    @objc func handleUsernameTapped() {
        guard let comment = comment else { return }
        commentCelldelegate?.didTapProfile(forComment: comment, cell: self)
    }

    
    //MARK: - Helper Functions
    
    func configureUI() {
        let timeReplyStack = UIStackView(arrangedSubviews: [timeLabel, replyButton])
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
        likeCountLabel.setDimensions(height: 15, width: 15)
        
        let deleteLikeButtonStack = UIStackView(arrangedSubviews: [likeButton, likeCountLabel, UIView()])
        deleteLikeButtonStack.axis = .vertical
        deleteLikeButtonStack.alignment = .center
        deleteLikeButtonStack.distribution = .equalCentering
        deleteLikeButtonStack.setDimensions(height: 45, width: 15)
        
        let mainStack = UIStackView(arrangedSubviews: [profileImageView, commentTimeStack, deleteLikeButtonStack])
        mainStack.alignment = .leading
        mainStack.distribution = .fillProportionally
        mainStack.axis = .horizontal
        mainStack.spacing = 8
        
        contentView.addSubview(mainStack)
        mainStack.anchor(width: frame.width - 16)
        mainStack.fillSuperview(padding: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
}

