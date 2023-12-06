//
//  FeedExpandedCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 16/04/21.
//

import UIKit

class FeedExpandedCell: FeedCell {
    //MARK: - Properties
    
    var varientsView = FeedExpandedVarientView()
    var commentTimeStack : UIStackView?
    override var post: PostItem? {
        didSet {
            guard let post = post else { return }
            imagePagingView.medias = post.medias
            imagePagingDotsView.numberOfItems = post.medias.count
            
            locationLabel.text = "\(appDele!.isForArabic ? post.title_ar : post.title)"

            if post.purchasedBy.id != "" {
                profileImageView.setUserImageUsingUrl(post.purchasedBy.urlImage)
                usernameButton.setTitle(post.purchasedBy.userName, for: .normal)
                storeNameLabel.setTitle(post.owner.userName, for: .normal)
            } else {
                profileImageView.setUserImageUsingUrl(post.owner.image.url)
                usernameButton.setTitle(post.owner.userName, for: .normal)
                storeNameLabel.setTitle("", for: .normal)
            }
            
            
            isVerifiedStore.isHidden = !post.owner.isSeller
            isVerified.isHidden = !post.owner.isVerified
            itemDetailLabel.text = appDele!.isForArabic ? post.location : post.about
            postTimeLabel.text = post.creationDate.timeAgo()
            likeButton.isSelected = post.isLiked
            likeButton.tintColor = post.isLiked ? .red : .appPrimaryColor
            quantityStepper.maximumValue = Double(post.quantity)
            likeLabel.text = "\(post.likeCount) \(appDele!.isForArabic ? Likes_ar : Likes_en)"
            if appDele!.isForArabic {
                viewCommentsButton.setTitle("عرض التعليقات (\(post.commentCount))", for: .normal)
            } else {
                viewCommentsButton.setTitle("\(appDele!.isForArabic ? View_ar : View_en) \(post.commentCount) \(appDele!.isForArabic ? Comments_ar : Comments_en)", for: .normal)
            }
            itemPriceLabel.text = String(format: "%.3f %@", post.price,appDele!.isForArabic ? KWD_ar : KWD_en)
            numberOfItemsSoldLabel.text = "\(post.quantitySold) \(appDele!.isForArabic ? Sold_ar : Sold_en)"
            
            self.setUsernameAndComment(for: post)
            
            varientsView.delegate = self
            if post.variants.count != 0 {
                varientsView.setDimensions(height: CGFloat((100 * post.attributes.count) + 15), width: frame.width - 30)
                varientsView.setDimensions(height: CGFloat((100) + 15), width: frame.width - 30)
                varientsView.post = post
                varientsView.backgroundColor = .random
            } else {
//                let heightSize = post.about.height(constraintedWidth: screenWidth - 110, font: UIFont.systemFont(ofSize: 14))
//                commentTimeStack?.layoutIfNeeded()
//                commentTimeStack?.anchor(height: commentTimeStack?.frame.height)
                varientsView.removeFromSuperview()
            }
        }
    }
    
    var selectedVariant: ItemVariant? = nil {
        didSet {
            notAvailableLabel.alpha = 0
            buyNowButton.alpha = 1
            
            guard let areVariantsAvailable = areVariantsAvailable else { return }
            if !areVariantsAvailable {
                return
            }
            
            guard let selectedVariant = selectedVariant else {
                // handle not available
//                notAvailableLabel.alpha = 1
//                buyNowButton.alpha = 0
                return
            }
            
            quantityStepper.maximumValue = Double(selectedVariant.quantity)
            itemPriceLabel.text = "\(selectedVariant.price) \(appDele!.isForArabic ? KWD_ar : KWD_en)"
            itemPriceLabel.text = String(format: "%.3f %@", selectedVariant.price, appDele!.isForArabic ? KWD_ar : KWD_en)
        }
    }
    
    var isVariantSelected: Bool? {
        didSet {
            guard let isVariantSelected = isVariantSelected else { return }
            if !isVariantSelected {
                notAvailableLabel.text = appDele!.isForArabic ? Select_Variant_ar : Select_Variant_en
            } else {
                notAvailableLabel.text = appDele!.isForArabic ? Not_Available_ar : Not_Available_en
            }
        }
    }
    
    var areVariantsAvailable: Bool?
    
    var mainStack: UIStackView?
    
    //MARK: - UI Elements
    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Detail_ar : Detail_en
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let itemDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "This are the details of the item to be sold."
        label.numberOfLines = 0
        return label
    }()
    
    lazy var commentProfilePicture: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        iv.setDimensions(height: 50, width: 50)
        iv.layer.cornerRadius = 50/2
        return iv
    }()

    private let commentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    private let commentDetails: UILabel = {
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
        return button
    }()
    
    private lazy var selectQuantityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .darkGray
        label.text = appDele!.isForArabic ? Select_Quantity_ar : Select_Quantity_en
        label.anchor(height: 28)
        return label
    }()
    
    private lazy var quantityStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [selectQuantityLabel, quantityStepper])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 3
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private lazy var notAvailableLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Not_Available_ar : Not_Available_en
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .systemRed
        return label
    }()
    
    //MARK: - Lifecycle
    
    override func prepareForReuse() {
        mainStack?.removeFromSuperview()
        postTimeLabel.removeFromSuperview()
        configureCell()
    }
    
    //MARK: - Selectors
    override func handleOptionTapped() {
        delegate?.handleOptionsTapped(for: self)
    }
    
    override func handleBuyTapped() {
        delegate?.handleBuyTapped(for: self, withVariant: varientsView)
    }
    
    override func handleAddToCartTapped() {
        delegate?.handleAddToCartTapped(for: self, withVariant: varientsView)
    }
    
    //MARK: - Helper Functions
    override func configureCell() {
        backgroundColor = .white
        
        imagePagingView.addSubview(likeHeartImageView)
        likeHeartImageView.centerX(inView: imagePagingView)
        likeHeartImageView.centerY(inView: imagePagingView)
        likeHeartImageView.alpha = 0
        
        let ownerInfoStack = UIStackView(arrangedSubviews: [usernameButton, isVerified, isVerifiedStore])
        ownerInfoStack.axis = .horizontal
        ownerInfoStack.alignment = .center
        ownerInfoStack.spacing = 8
        ownerInfoStack.distribution = .fill
        
        let nameLocationStack = UIStackView(arrangedSubviews: [ownerInfoStack, locationLabel, storeNameLabel])
        nameLocationStack.axis = .vertical
        nameLocationStack.alignment = .leading
        nameLocationStack.distribution = .fillProportionally
        nameLocationStack.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        let mainTopBarStack = UIStackView(arrangedSubviews: [profileImageView, nameLocationStack, optionButton])
        mainTopBarStack.axis = .horizontal
        mainTopBarStack.spacing = 7
        mainTopBarStack.alignment = .center
        mainTopBarStack.distribution = .fill
        mainTopBarStack.anchor(width: frame.width - 30)
        
        imagePagingView.setDimensions(height: frame.width, width: frame.width)
        imagePagingDotsView.setDimensions(height: 15, width: frame.width - 30)
        
        let buttonsStack = UIStackView(arrangedSubviews: [likeButton, commentButton, messageButton, addToCardButton])
        buttonsStack.axis = .horizontal
        buttonsStack.alignment = .center
        buttonsStack.distribution = .fillEqually
        let buttonSpacing = ((frame.width/2) - (27*4))/4
        buttonsStack.spacing = buttonSpacing
        buttonsStack.spacing = 10
        
        let buttonMainStack = UIStackView(arrangedSubviews: [buttonsStack, UIView()])
        buttonMainStack.axis = .horizontal
        buttonMainStack.spacing = 10
        buttonMainStack.alignment = .fill
        buttonMainStack.distribution = .fill
        buttonMainStack.anchor(width: frame.width - 30)
        
        let itemPriceStack = UIStackView(arrangedSubviews: [itemPriceLabel, numberOfItemsSoldLabel, UIView()])
        itemPriceStack.axis = .horizontal
        itemPriceStack.spacing = 10
        itemPriceStack.alignment = .fill
        itemPriceStack.distribution = .fill
        itemPriceStack.anchor(height: 20)
        
        let likesAndPriceStack = UIStackView(arrangedSubviews: [likeLabel, itemPriceStack])
        likesAndPriceStack.axis = .vertical
        likesAndPriceStack.alignment = .leading
        likesAndPriceStack.distribution = .fillEqually
        
        let buyLikesCommentStack = UIStackView(arrangedSubviews: [likesAndPriceStack, buyNowButton])
        buyLikesCommentStack.axis = .horizontal
        buyLikesCommentStack.alignment = .center
        buyLikesCommentStack.distribution = .fill
        buyLikesCommentStack.setDimensions(height: 50, width: frame.width - 30)
        
        
        detailsLabel.anchor(height: 25)
        let itemDetailStack = UIStackView(arrangedSubviews: [detailsLabel, itemDetailLabel])
        itemDetailStack.axis = .vertical
        itemDetailStack.alignment = .leading
        itemDetailStack.spacing = 3
        itemDetailStack.distribution = .fillProportionally
        itemDetailStack.anchor(width: frame.width - 30)
        
        let timeReplyStack = UIStackView(arrangedSubviews: [commentTimeLabel, commentReplyButton])
        timeReplyStack.alignment = .center
        timeReplyStack.axis = .horizontal
        timeReplyStack.distribution = .fillProportionally
        timeReplyStack.spacing = 8
        timeReplyStack.anchor(height: 20)


        commentLikeButton.setDimensions(height: 15, width: 15)

        let commentLikeButtonStack = UIStackView(arrangedSubviews: [commentLikeButton, UIView()])
        commentLikeButtonStack.alignment = .center
        commentLikeButtonStack.distribution = .equalCentering
        commentLikeButtonStack.setDimensions(height: 45, width: 15)

        commentTimeStack = UIStackView(arrangedSubviews: [commentLabel, commentDetails, timeReplyStack])
        commentTimeStack?.axis = .vertical
//        commentTimeStack?.distribution = .fillProportionally
        commentTimeStack?.alignment = .leading
        commentTimeStack?.spacing = 3
        
        let commentMainStack = UIStackView(arrangedSubviews: [commentProfilePicture, commentTimeStack!, commentLikeButtonStack])
        commentMainStack.alignment = .leading
        commentMainStack.distribution = .fillProportionally
        commentMainStack.axis = .horizontal
        commentMainStack.spacing = 10

        commentMainStack.anchor(width: frame.width - 30)
        
        let viewCommentsStack = UIStackView(arrangedSubviews: [viewCommentsButton, UIView()])
        viewCommentsStack.axis = .horizontal
        viewCommentsStack.alignment = .fill
        viewCommentsStack.distribution = .fill
        viewCommentsStack.setDimensions(height: 25, width: frame.width - 30)
        
        let quantityStackStack = UIStackView(arrangedSubviews: [quantityStack, UIView()])
        quantityStackStack.axis = .horizontal
        quantityStackStack.alignment = .fill
        quantityStackStack.distribution = .fill
        quantityStackStack.anchor(width: frame.width - 30)
        
        let mainStack = UIStackView(arrangedSubviews: [mainTopBarStack, imagePagingView, imagePagingDotsView, buttonMainStack, buyLikesCommentStack, commentMainStack, viewCommentsStack, varientsView, quantityStackStack,  UIView()])
        
        mainStack.axis = .vertical
        mainStack.spacing = 15
        mainStack.alignment = .center
        
        contentView.addSubview(mainStack)
        mainStack.fillSuperview(padding: UIEdgeInsets(top: 7, left: 0, bottom: 27, right: 0))
        self.mainStack = mainStack
        
        contentView.addSubview(postTimeLabel)
        postTimeLabel.centerY(inView: imagePagingDotsView)
        postTimeLabel.anchor(left: imagePagingDotsView.leftAnchor)
        
        contentView.addSubview(notAvailableLabel)
        notAvailableLabel.anchor(right: mainStack.rightAnchor, paddingRight: 15/2)
        notAvailableLabel.centerY(inView: buyNowButton)
        notAvailableLabel.alpha = 0
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
            imagePagingView.transform = trnForm_Ar
        }
    }
    
    func setUsernameAndComment(for post: PostItem) {
        // SETTING CAPTION TEXT
        let attributedText = NSMutableAttributedString(string: "\(post.owner.storeDetails.shopName)", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .semibold), .foregroundColor: UIColor.black])
//        attributedText.append(NSMutableAttributedString(string: "  "))
//        attributedText.append(NSMutableAttributedString(string: "\(post.about)", attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .light), .foregroundColor: UIColor.black]))
        
        commentLabel.attributedText = attributedText
        
        commentDetails.text = appDele!.isForArabic ? post.location : post.about
        commentProfilePicture.loadImage(from: post.owner.image.url)
        commentTimeLabel.text = post.creationDate.timeAgo()
    }
}

extension FeedExpandedCell: FeedExpandedVarientViewDelegate {
    func didUpdateSelectedVariantIndex(itemAttributes: ItemVariant, index: Int) {
        delegate?.handleDidUpdateVariationSelected(withAttributes: itemAttributes, fromCell: self, index: index)
    }
    
    
    func didUpdateSelectedVariant(itemAttributes: [ItemAttribute]) {
        delegate?.handleDidUpdateVariation(withAttributes: itemAttributes, fromCell: self)
    }
}
