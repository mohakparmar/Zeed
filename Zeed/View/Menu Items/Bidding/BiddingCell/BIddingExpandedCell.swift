//
//  BiddingExpandedCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 10/05/21.
//

import UIKit

class BiddingExpandedCell: BiddingCell {
    //MARK: - Properties
    override var item: BidItem? {
        didSet {
            guard let item = item else { return }
            
            profileImageView.setUserImageUsingUrl( item.owner.image.url)
            usernameButton.setTitle(item.owner.fullName, for: .normal)
            
            itemName.text = "\(item.title) - \(item.location)"
            isVerifiedStore.isHidden = !item.owner.isSeller
            isVerified.isHidden = !item.owner.isVerified
            
            timerLabel.text = "Live in NULL:00"
            
            imagePagingView.medias = item.medias
            imagePagingDotsView.numberOfItems = item.medias.count
            
            imagePagingView.delegate = self
            
            likeButton.isSelected = item.isLiked
            likeLabel.text = "\(item.likeCount) \(appDele!.isForArabic ? Likes_ar : Likes_en)"
            viewCommentsButton.setTitle("\(appDele!.isForArabic ? View_ar : View_en) \(item.commentCount) \(appDele!.isForArabic ? Comments_ar : Comments_en)", for: .normal)

            if let currentBid = item.currentBid {
                itemPriceLabel.text = "\(currentBid.price) \(appDele!.isForArabic ? KWD_ar : KWD_en)"
            } else {
                itemPriceLabel.text = "\(item.initialPrice) \(appDele!.isForArabic ? KWD_ar : KWD_en)"
            }
            numberOfParticipationLabel.text = "0 \(appDele!.isForArabic ? "مشاركون" : "Participants")"
            
            configureCellForIsLive()
            
            self.setUsernameAndComment(for: item)
            
            
            bidNowButton.setTitle(appDele!.isForArabic ? Bid_Now_ar : Bid_Now_en, for: .normal)
            if item.owner.id == loggedInUser?.id {
                bidNowButton.setTitle(appDele!.isForArabic ? "عرض الخيارات" : "View Options", for: .normal)
            }
        }
    }
    
    var liveUserCount: Int? {
        didSet {
            guard let count = liveUserCount else { return }
            self.numberOfParticipationLabel.text = "\(count) \(appDele!.isForArabic ? "مشاركون" : "Participants")"
        }
    }
    
    var maximumPrice: Double? {
        didSet {
            guard let price = maximumPrice else { return }
            itemPriceLabel.text = "\(price) \(appDele!.isForArabic ? KWD_ar : KWD_en)"
        }
    }
    
    //MARK: - UI Elements
    lazy var commentProfilePicture: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        iv.setDimensions(height: 50, width: 50)
        iv.layer.cornerRadius = 50/2
        return iv
    }()

    private lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var commentDetails: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
        return label
    }()

    
    private let commentTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = UIColor.darkGray.withAlphaComponent(0.7)
        return label
    }()
    
    lazy var commentReplyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(appDele!.isForArabic ? Reply_ar : Reply_en, for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return button
    }()
    
    private lazy var commentLikeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like").withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView!.setDimensions(height: 15, width: 15)
        return button
    }()
    
    //MARK: - Lifecycle
    override func prepareForReuse() {
        mainCellStack?.removeFromSuperview()
    }
    
    //MARK: - Helper Functions
    override func configureCellForIsLive() {
        backgroundColor = .white
        
        imagePagingDotsView.setDimensions(height: 15, width: frame.width - 15)
        imagePagingView.setDimensions(height: frame.width, width: frame.width)
        
        bidNowButton.setTitle("Bid Now", for: .normal)
        
        
        let ownerInfoStack = UIStackView(arrangedSubviews: [usernameButton, isVerified, isVerifiedStore])
        ownerInfoStack.axis = .horizontal
        ownerInfoStack.alignment = .center
        ownerInfoStack.spacing = 8
        ownerInfoStack.distribution = .fill
        
        let nameLocationStack = UIStackView(arrangedSubviews: [ownerInfoStack, itemName])
        nameLocationStack.axis = .vertical
        nameLocationStack.alignment = .leading
        nameLocationStack.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        let mainTopBarStack = UIStackView(arrangedSubviews: [profileImageView, nameLocationStack, optionButton])
        mainTopBarStack.axis = .horizontal
        mainTopBarStack.spacing = 7
        mainTopBarStack.alignment = .center
        mainTopBarStack.distribution = .fill
        mainTopBarStack.setDimensions(height: 45, width: frame.width - 15)
        
        let buttonsStack = UIStackView(arrangedSubviews: [likeButton, commentButton, messageButton])
        buttonsStack.axis = .horizontal
        buttonsStack.alignment = .center
        buttonsStack.distribution = .fillEqually
        buttonsStack.spacing = 18
        
        let buttonMainStack = UIStackView(arrangedSubviews: [buttonsStack, UIView()])
        buttonMainStack.axis = .horizontal
        buttonMainStack.spacing = 10
        buttonMainStack.alignment = .fill
        buttonMainStack.distribution = .fill
        buttonMainStack.anchor(width: frame.width - 15, height: 27)
        
        let itemPriceStack = UIStackView(arrangedSubviews: [itemPriceLabel, numberOfParticipationLabel, UIView()])
        itemPriceStack.axis = .horizontal
        itemPriceStack.spacing = 10
        itemPriceStack.alignment = .fill
        itemPriceStack.distribution = .fill
        itemPriceStack.anchor(height: 20)
        
        let likesAndPriceStack = UIStackView(arrangedSubviews: [likeLabel, itemPriceStack])
        likesAndPriceStack.axis = .vertical
        likesAndPriceStack.alignment = .leading
        likesAndPriceStack.distribution = .fillEqually
        
        let buyLikesCommentStack = UIStackView(arrangedSubviews: [likesAndPriceStack, bidNowButton])
        buyLikesCommentStack.axis = .horizontal
        buyLikesCommentStack.alignment = .center
        buyLikesCommentStack.distribution = .fill
        buyLikesCommentStack.setDimensions(height: 50, width: frame.width - 15)
        
        commentLikeButton.setDimensions(height: 45, width: 15)
        
        let timeReplyStack = UIStackView(arrangedSubviews: [commentTimeLabel, commentReplyButton])
        timeReplyStack.alignment = .center
        timeReplyStack.axis = .horizontal
        timeReplyStack.distribution = .fillProportionally
        timeReplyStack.spacing = 8
        timeReplyStack.anchor(height: 20)
        
        let commentTimeStack = UIStackView(arrangedSubviews: [commentLabel, commentDetails, timeReplyStack])
        commentTimeStack.axis = .vertical
        commentTimeStack.distribution = .fillProportionally
        commentTimeStack.alignment = .leading
        commentTimeStack.spacing = 3
        
        let commentMainStack = UIStackView(arrangedSubviews: [commentProfilePicture, commentTimeStack, commentLikeButton])
        commentMainStack.alignment = .leading
        //        commentMainStack.distribution = .fillProportionally
        commentMainStack.axis = .horizontal
        commentMainStack.spacing = 10
        
        commentMainStack.anchor(width: frame.width - 15)
        
        
        
        let viewCommentsStack = UIStackView(arrangedSubviews: [viewCommentsButton, UIView()])
        viewCommentsStack.axis = .horizontal
        viewCommentsStack.alignment = .fill
        viewCommentsStack.distribution = .fill
        viewCommentsStack.setDimensions(height: 25, width: frame.width - 15)
        
        let mainStack = UIStackView(arrangedSubviews: [mainTopBarStack, imagePagingView, imagePagingDotsView, imagePagingDotsView, buttonMainStack, buyLikesCommentStack, commentMainStack, viewCommentsStack])
        mainStack.axis = .vertical
        mainStack.spacing = 6
        mainStack.alignment = .center
        
        addSubview(mainStack)
        mainStack.fillSuperview(padding: UIEdgeInsets(top: 7, left: 0, bottom: 27, right: 0))
        
        self.mainCellStack = mainStack
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
            imagePagingView.transform = trnForm_Ar
        }

    }
    
    func setUsernameAndComment(for post: BidItem) {
        // SETTING CAPTION TEXT
        let attributedText = NSMutableAttributedString(string: "\(post.owner.fullName)", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .semibold), .foregroundColor: UIColor.black])
//        attributedText.append(NSMutableAttributedString(string: "  "))
//        attributedText.append(NSMutableAttributedString(string: "\(post.about)", attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .light), .foregroundColor: UIColor.black]))
        
        commentDetails.text = post.about
        
        commentLabel.attributedText = attributedText
        commentProfilePicture.loadImage(from: post.owner.image.url)
        commentTimeLabel.text = post.creationDate.timeAgo()
    }
}
