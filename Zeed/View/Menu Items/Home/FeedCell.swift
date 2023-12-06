//
//  ItemCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 28/02/21.
//

import UIKit
import GMStepper

protocol FeedCellDelegate: AnyObject {
    func handleUsernameTapped(for cell: FeedCell)
    func handleStoreUserName(for cell: FeedCell)
    func handleOptionsTapped(for cell: FeedCell)
    func handleImageSingleTap(for cell: FeedCell)
    func handleLikeTapped(for cell: FeedCell)
    func handleCommentTapped(for cell: FeedCell)
    func handleMessageTapped(for cell: FeedCell)
    func handleAddToCartTapped(for cell: FeedCell, withVariant variantView: FeedExpandedVarientView?)
    func handleBuyTapped(for cell: FeedCell, withVariant variantView: FeedExpandedVarientView?)
    func handleDidUpdateVariation(withAttributes: [ItemAttribute], fromCell: FeedExpandedCell)
    func handleDidUpdateVariationSelected(withAttributes: ItemVariant, fromCell: FeedExpandedCell, index:Int)
}

class FeedCell: UICollectionViewCell {
    //MARK: - Properties
    weak var delegate: FeedCellDelegate?
    
    var imagePagingView: SGImagePagingView!
    var imagePagingDotsView: SGPageDotView!
    var index : IndexPath?
    
    var post: PostItem? {
        didSet {
            guard let post = post else { return }
            imagePagingView.medias = post.medias
            imagePagingDotsView.numberOfItems = post.medias.count
            imagePagingDotsView.selectedIndex = 0

            profileImageView.setUserImageUsingUrl(post.owner.image.url)
            locationLabel.text = "\(appDele!.isForArabic ? post.title_ar : post.title)"

            usernameButton.setTitle(post.owner.userName, for: .normal)
//            storeNameLabel.text = "\(post.owner.storeDetails.shopName)"
            storeNameLabel.setTitle("", for: .normal)

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
            
            postTimeLabel.text = post.creationDate.timeAgo()
            likeButton.isSelected = post.isLiked
            likeButton.tintColor = post.isLiked ? .red : .appPrimaryColor
            likeLabel.text = "\(post.likeCount) \(appDele!.isForArabic ? Likes_ar : Likes_en)"
            viewCommentsButton.setTitle("\(appDele!.isForArabic ? View_ar : View_en) \(appDele!.isForArabic ? Comments_ar : Comments_en) (\(post.commentCount))", for: .normal)
            itemPriceLabel.text = "\(post.price) \(appDele!.isForArabic ? KWD_ar : KWD_en)"
            itemPriceLabel.text = String(format: "%.3f %@", post.price,appDele!.isForArabic ? KWD_ar : KWD_en)

            numberOfItemsSoldLabel.text = "\(post.quantitySold) \(appDele!.isForArabic ? Sold_ar : Sold_en)"
            
        }
    }
    
    //MARK: - UI Elements
    lazy var likeHeartImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "liked").withRenderingMode(.alwaysTemplate)
        iv.contentMode = .scaleAspectFit
        iv.tintColor = UIColor.hex("C51104")
        iv.isUserInteractionEnabled = false
        iv.setDimensions(height: self.width * 0.15, width: self.width * 0.15)
        return iv
    }()
    
    lazy var profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        
        iv.setDimensions(height: 55, width: 55)
        iv.layer.cornerRadius = 55/2
        
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleUsernameTapped))
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    lazy var usernameButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleUsernameTapped), for: .touchUpInside)
        button.anchor(height: 18)
        return button
    }()
    
    
    lazy var storeNameLabel: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.setTitleColor(.appPrimaryColor, for: .normal)
        button.addTarget(self, action: #selector(handleStoreUserName), for: .touchUpInside)
        button.anchor(height: 18)
        return button
    }()
    
//    lazy var storeNameLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .appPrimaryColor
//        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
//        return label
//    }()
    
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
    
    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = UIColor.darkGray.withAlphaComponent(0.7)
        return label
    }()
    
    let postTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.textColor = UIColor.darkGray.withAlphaComponent(0.7)
        return label
    }()
    
    lazy var optionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "menu_options"), for: .normal)
        button.tintColor = .black
        button.imageView!.setDimensions(height: 5, width: 18)
        
        button.addTarget(self, action: #selector(handleOptionTapped), for: .touchUpInside)
        
        button.setDimensions(height: 30, width: 30)
        return button
    }()

    lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "like").withRenderingMode(.alwaysTemplate), for: .normal)
        button.setImage(#imageLiteral(resourceName: "liked").withRenderingMode(.alwaysTemplate), for: .selected)
        
        button.tintColor = .appPrimaryColor
        
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.setDimensions(height: 27, width: 27)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comments").withRenderingMode(.alwaysOriginal), for: .normal)
        button.tintColor = .black
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.setDimensions(height: 27, width: 27)

        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var messageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "message1"), for: .normal)
        button.tintColor = .appPrimaryColor
        
        button.imageView?.setDimensions(height: 27, width: 27)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFit
        
        button.addTarget(self, action: #selector(handleMessageTapped), for: .touchUpInside)
        
        return button
    }()
    
    lazy var addToCardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cart1").withRenderingMode(.alwaysOriginal), for: .normal)
        button.tintColor = .black
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.setDimensions(height: 30, width: 30)

        button.addTarget(self, action: #selector(handleAddToCartTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var likeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .appPrimaryColor
        return label
    }()
    
    lazy var viewCommentsButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(.darkGray, for: .normal)
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var buyNowButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .gradientSecondColor
        button.setTitle(appDele!.isForArabic ? Buy_Now_ar : Buy_Now_en, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.setDimensions(height: 40, width: 100)
        
        button.addTarget(self, action: #selector(handleBuyTapped), for: .touchUpInside)
        
        return button
    }()
    
    lazy var itemPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    lazy var numberOfItemsSoldLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = .darkGray
        return label
    }()
    
    lazy var quantityStepper: GMStepper = {
        let stepper = GMStepper()
        stepper.buttonsBackgroundColor = UIColor.appPrimaryColor.withAlphaComponent(0.6)
        stepper.buttonsTextColor = .white
        
        stepper.labelBackgroundColor = .white
        stepper.labelTextColor = UIColor.appPrimaryColor.withAlphaComponent(0.6)
        stepper.labelFont = UIFont(name: "AvenirNext-Bold", size: 19)!
        
        stepper.limitHitAnimationColor = .systemRed
        
        stepper.minimumValue = 1
//        stepper.maximumValue = 5
        
        stepper.setDimensions(height: 35, width: 120)
        return stepper
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        imagePagingView = SGImagePagingView(forMedias: [ItemMedia](), isZoomEnabled: false)
        imagePagingView.delegate = self
        imagePagingDotsView = SGPageDotView()

        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleImageTap))
        singleTapGesture.numberOfTapsRequired = 1
        imagePagingView.addGestureRecognizer(singleTapGesture)

        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLikeTapped))
        doubleTapGesture.numberOfTapsRequired = 2
        imagePagingView.addGestureRecognizer(doubleTapGesture)

        singleTapGesture.require(toFail: doubleTapGesture)
        
        imagePagingView.isUserInteractionEnabled = true
        imagePagingDotsView.isUserInteractionEnabled = false
        
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func handleUsernameTapped() {
        delegate?.handleUsernameTapped(for: self)
    }

    @objc func handleStoreUserName() {
        delegate?.handleStoreUserName(for: self)
    }
    
    
    @objc func handleOptionTapped() {
        delegate?.handleOptionsTapped(for: self)
    }
    
    @objc func handleImageTap() {
            delegate?.handleImageSingleTap(for: self)
    }
    
    @objc func handleLikeTapped() {
        delegate?.handleLikeTapped(for: self)
        if loggedInUser == nil {
            return
        }
        likeButton.showInOutAnimation({})
        if !likeButton.isSelected {
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.2, options: .allowUserInteraction, animations: {
                    self.likeHeartImageView.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
                    self.likeHeartImageView.alpha = 1.0
                }) { finished in
                    UIView.animate(withDuration: 0.2) {
                        self.likeHeartImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        self.likeHeartImageView.alpha = 0.0
                    }
                }
        }
    }
    
    @objc func handleCommentTapped(sender: UIButton) {
        sender.showInOutAnimation({})
        delegate?.handleCommentTapped(for: self)
    }
    
    @objc func handleMessageTapped(sender: UIButton) {
        sender.showInOutAnimation({})
        delegate?.handleMessageTapped(for: self)
    }
    
    @objc func handleAddToCartTapped() {
        if loggedInUser?.id ?? "" == post?.owner.id {
            Utility.showISMessage(str_title: appDele!.isForArabic ? You_cannot_purchase_your_own_product_ar : You_cannot_purchase_your_own_product_en, Message: "", msgtype: .warning)
        } else {
            delegate?.handleAddToCartTapped(for: self, withVariant: nil)
        }
    }
    
    @objc func handleBuyTapped() {
        if loggedInUser?.id ?? "" == post?.owner.id {
            Utility.showISMessage(str_title: appDele!.isForArabic ? You_cannot_purchase_your_own_product_ar : You_cannot_purchase_your_own_product_en, Message: "", msgtype: .warning)
        } else {
            delegate?.handleBuyTapped(for: self, withVariant: nil)
        }
    }
    
    //MARK: - Helper Functions
    func configureCell() {
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
        mainTopBarStack.spacing = 12
        mainTopBarStack.alignment = .center
        mainTopBarStack.distribution = .fill
        mainTopBarStack.anchor(width: frame.width - 30)
        
        imagePagingView.setDimensions(height: frame.width, width: frame.width)
        
        let buttonsStack = UIStackView(arrangedSubviews: [likeButton, commentButton, messageButton, addToCardButton])
        buttonsStack.axis = .horizontal
        buttonsStack.alignment = .center
        buttonsStack.distribution = .fillEqually
        buttonsStack.spacing = 10
        
        let buttonMainStack = UIStackView(arrangedSubviews: [buttonsStack, UIView()])
        buttonMainStack.axis = .horizontal
        buttonMainStack.spacing = 10
        buttonMainStack.alignment = .fill
        buttonMainStack.distribution = .fill
        buttonMainStack.anchor(width: frame.width - 30)
        
        let likesAndCommentsStack = UIStackView(arrangedSubviews: [likeLabel, viewCommentsButton])
        likesAndCommentsStack.axis = .vertical
        likesAndCommentsStack.alignment = .leading
        likesAndCommentsStack.distribution = .fillEqually
        
        let buyLikesCommentStack = UIStackView(arrangedSubviews: [likesAndCommentsStack, buyNowButton])
        buyLikesCommentStack.axis = .horizontal
        buyLikesCommentStack.alignment = .center
        buyLikesCommentStack.distribution = .fill
        buyLikesCommentStack.setDimensions(height: 50, width: frame.width - 30)
        
        let itemPriceStack = UIStackView(arrangedSubviews: [itemPriceLabel, numberOfItemsSoldLabel, UIView()])
        itemPriceStack.axis = .horizontal
        itemPriceStack.spacing = 10
        itemPriceStack.alignment = .fill
        itemPriceStack.distribution = .fill
        itemPriceStack.setDimensions(height: 20, width: frame.width - 30)
        
        imagePagingDotsView.setDimensions(height: 15, width: frame.width - 30)
        
        let mainStack = UIStackView(arrangedSubviews: [mainTopBarStack, imagePagingView, imagePagingDotsView, buttonMainStack, buyLikesCommentStack, itemPriceStack])
        mainStack.axis = .vertical
        mainStack.spacing = 6
        mainStack.alignment = .center
        
        addSubview(mainStack)
        mainStack.fillSuperview(padding: UIEdgeInsets(top: 7, left: 0, bottom: 7, right: 0))
        
        addSubview(postTimeLabel)
        postTimeLabel.centerY(inView: imagePagingDotsView)
        postTimeLabel.anchor(left: imagePagingDotsView.leftAnchor)
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
            imagePagingView.transform = trnForm_Ar
            
        }

    }
}

extension FeedCell: SGImagePagingViewDelegate {
    func currentlySelectedIndex(index: IndexPath) {
        imagePagingDotsView.selectedIndex = index.row
    }
}

