//
//  BiddingCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 12/03/21.
//

import UIKit
import MarqueeLabel

protocol BiddingCellDelegate: AnyObject {
    func openDetailView(for cell: BiddingCell)
    func handleUsernameTapped(for cell: BiddingCell)
    func handleOptionsTapped(for cell: BiddingCell)
    func handleLikeTapped(for cell: BiddingCell)
    func handleMessageTapped(for cell: BiddingCell)
    func handleCommentTapped(for cell: BiddingCell)
    func handleBidTapped(for cell: BiddingCell)
    func handleWatchLiveTapped(for cell: BiddingCell)
}

enum BiddingCellStatus {
    case liveAuction
    case live
    case goingToBeLiveIn
}

class BiddingCell: UICollectionViewCell {
    //MARK: - Properties
    weak var delegate: BiddingCellDelegate?
    
    var imagePagingView: SGImagePagingView
    var imagePagingDotsView: SGPageDotView!
    
    var item: BidItem? {
        didSet {
            guard let item = item else { return }
            
            profileImageView.setUserImageUsingUrl(item.owner.image.url)
            
            itemName.text = "\(item.title)"
            storeNameLabel.text = "\(item.owner.storeDetails.shopName)"
            isVerifiedStore.isHidden = !item.owner.isSeller
            isVerified.isHidden = !item.owner.isVerified
            
            usernameButton.setTitle(item.owner.userName, for: .normal)
            usernameButton.setTitle(item.owner.storeDetails.shopName, for: .normal)
            storeNameLabel.text = "\(item.owner.userName)"
            
            if item.purchasedBy.id != "" {
                profileImageView.setUserImageUsingUrl(item.purchasedBy.urlImage)
                usernameButton.setTitle(item.purchasedBy.userName, for: .normal)
                storeNameLabel.text = "\(item.owner.userName)"
            } else {
                profileImageView.setUserImageUsingUrl(item.owner.image.url)
                usernameButton.setTitle(item.owner.userName, for: .normal)
                storeNameLabel.text = ""
            }


            imagePagingView.medias = item.medias
            imagePagingDotsView.numberOfItems = item.medias.count
            
            imagePagingView.delegate = self
            imagePagingView.isUserInteractionEnabled = true
            
            likeButton.isSelected = item.isLiked
            likeButton.tintColor = item.isLiked ? .red : .appPrimaryColor

            likeLabel.text = "\(item.likeCount) \(appDele!.isForArabic ? Likes_ar : Likes_en)"
            viewCommentsButton.setTitle("\(appDele!.isForArabic ? View_ar : View_en) \(item.commentCount) \(appDele!.isForArabic ? Comments_ar : Comments_en)", for: .normal)
            
            if let currentBid = item.currentBid {
                itemPriceLabel.text = "\(currentBid.price) \(appDele!.isForArabic ? KWD_ar : KWD_en)"
                itemPriceLabel.text = String(format: "%.3f %@", currentBid.price, appDele!.isForArabic ? KWD_ar : KWD_en)

            } else {
                itemPriceLabel.text = "\(item.initialPrice) \(appDele!.isForArabic ? KWD_ar : KWD_en)"
                itemPriceLabel.text = String(format: "%.3f %@", item.initialPrice, appDele!.isForArabic ? KWD_ar : KWD_en)
            }
            
            if item.status == .upcoming && item.owner.id != loggedInUser?.id {
                numberOfParticipationLabel.text = ""
                timerLabel.text = getTimeDifference(fromTime: Date(), toTime: item.startDate)
                configureCellForGoingToBeLive()
            } else {
                numberOfParticipationLabel.text = "\(item.countRegistrationUsers) \(appDele!.isForArabic ? Participated_ar : Participated_en)"
                
                switch item.postBaseType {
                case .normalSelling:
                    break
                case .normalBidding:
                    configureCellForIsLive()
                case .liveBidding:
                    configureCellForIsLiveAuction()
                }
            }
        }
    }
    
    //MARK: - UI Elements
    lazy var profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .random
        
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
    
    lazy var itemName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = UIColor.darkGray.withAlphaComponent(0.7)
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
    
    lazy var storeNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appPrimaryColor
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
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
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.setDimensions(height: 27, width: 27)
        
        button.addTarget(self, action: #selector(handleMessageTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var timerButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "timer_icon").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .appPrimaryColor
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.setDimensions(height: 25, width: 25)
        return button
    }()
    
    let timerLabel: MarqueeLabel = {
        let label = MarqueeLabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .appPrimaryColor

        label.type = .continuous
        label.speed = .duration(15)
        label.animationCurve = .easeInOut
        label.fadeLength = 5
        label.trailingBuffer = 10
        return label
    }()
    
    lazy var watchLiveButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemRed
        button.setTitle(appDele!.isForArabic ? Watch_Live_ar : Watch_Live_en, for: .normal)
        button.layer.cornerRadius = 5
        button.tintColor = .white
        
        button.addTarget(self, action: #selector(handleWatchLiveTapped), for: .touchUpInside)
        return button
    }()
    
    let likeLabel: UILabel = {
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
    
    lazy var bidNowButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .gradientSecondColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.setDimensions(height: 40, width: 100)
        
        button.addTarget(self, action: #selector(handleBidTapped), for: .touchUpInside)
        
        return button
    }()
    
    let itemPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    let numberOfParticipationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = .darkGray
        return label
    }()
    
    var mainCellStack: UIStackView?
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        imagePagingView = SGImagePagingView(forMedias: [ItemMedia](), isZoomEnabled: false)
        imagePagingDotsView = SGPageDotView()
        super.init(frame: frame)
        
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleImageTap))
        singleTapGesture.numberOfTapsRequired = 1
        imagePagingView.addGestureRecognizer(singleTapGesture)

        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLikeTapped))
        doubleTapGesture.numberOfTapsRequired = 2
        imagePagingView.addGestureRecognizer(doubleTapGesture)

        singleTapGesture.require(toFail: doubleTapGesture)
        
        imagePagingView.isUserInteractionEnabled = true
        imagePagingView.delegate = self
        
        imagePagingDotsView.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.mainCellStack?.removeFromSuperview()
    }
    
    //MARK: - Selectors
    @objc func handleImageTap() {
        delegate?.openDetailView(for: self)
        
        print("DEBUG:- handle handleImageTap")
    }
    
    @objc func handleOptionTapped() {
        delegate?.handleOptionsTapped(for: self)
    }
    
    @objc func handleUsernameTapped() {
        delegate?.handleUsernameTapped(for: self)
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
    
    @objc func handleCommentTapped() {
        delegate?.handleCommentTapped(for: self)
    }
    
    @objc func handleMessageTapped() {
        delegate?.handleMessageTapped(for: self)
    }
    
    @objc func handleBidTapped() {
        delegate?.handleBidTapped(for: self)
    }
    
    @objc func handleWatchLiveTapped() {
        delegate?.handleWatchLiveTapped(for: self)
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

    //MARK: - Helper Functions
    func configureCellForGoingToBeLive() {
        backgroundColor = .white
        
        imagePagingDotsView.setDimensions(height: 15, width: frame.width - 15)
        imagePagingView.setDimensions(height: frame.width, width: frame.width)
        
        imagePagingView.addSubview(likeHeartImageView)
        likeHeartImageView.centerX(inView: imagePagingView)
        likeHeartImageView.centerY(inView: imagePagingView)
        likeHeartImageView.alpha = 0
        imagePagingView.bringSubviewToFront(likeHeartImageView)

        
        bidNowButton.setTitle(appDele!.isForArabic ? Notify_Me_ar : Notify_Me_en, for: .normal)
        
        let ownerInfoStack = UIStackView(arrangedSubviews: [usernameButton, isVerified, isVerifiedStore])
        ownerInfoStack.axis = .horizontal
        ownerInfoStack.alignment = .center
        ownerInfoStack.spacing = 8
        ownerInfoStack.distribution = .fill
        
        let nameLocationStack = UIStackView(arrangedSubviews: [ownerInfoStack, itemName, storeNameLabel])
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
        
        let buttonsStack = UIStackView(arrangedSubviews: [likeButton, commentButton, messageButton])
        buttonsStack.axis = .horizontal
        buttonsStack.alignment = .center
        buttonsStack.distribution = .fillEqually
        buttonsStack.spacing = 10
        
        let timerInfoStack = UIStackView(arrangedSubviews: [timerButton, timerLabel])
        timerInfoStack.axis = .horizontal
        timerInfoStack.alignment = .center
        timerInfoStack.distribution = .fillProportionally
        timerInfoStack.spacing = 8
        
        let buttonMainStack = UIStackView(arrangedSubviews: [buttonsStack, timerInfoStack, bidNowButton])
        buttonMainStack.axis = .horizontal
        buttonMainStack.spacing = 10
        buttonMainStack.alignment = .center
        buttonMainStack.distribution = .equalCentering
        buttonMainStack.anchor(width: frame.width - 30, height: 40)
        
        let likesAndCommentsStack = UIStackView(arrangedSubviews: [likeLabel, viewCommentsButton])
        likesAndCommentsStack.axis = .vertical
        likesAndCommentsStack.alignment = .leading
        likesAndCommentsStack.distribution = .fillEqually
        
        let buyLikesCommentStack = UIStackView(arrangedSubviews: [likesAndCommentsStack, UIView()])
        buyLikesCommentStack.axis = .horizontal
        buyLikesCommentStack.alignment = .fill
        buyLikesCommentStack.distribution = .fill
        buyLikesCommentStack.anchor(width: frame.width - 15)
        
        let itemPriceStack = UIStackView(arrangedSubviews: [itemPriceLabel, numberOfParticipationLabel, UIView()])
        itemPriceStack.axis = .horizontal
        itemPriceStack.spacing = 10
        itemPriceStack.alignment = .fill
        itemPriceStack.distribution = .fill
        itemPriceStack.setDimensions(height: 20, width: frame.width - 15)
        
        let mainStack = UIStackView(arrangedSubviews: [mainTopBarStack, imagePagingView, imagePagingDotsView, buttonMainStack, buyLikesCommentStack, itemPriceStack])
        mainStack.axis = .vertical
        mainStack.spacing = 10
        mainStack.alignment = .center
        
        addSubview(mainStack)
        mainStack.fillSuperview(padding: UIEdgeInsets(top: 7, left: 0, bottom: 7, right: 0))
        
        self.mainCellStack = mainStack
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
            imagePagingView.transform = trnForm_Ar
        }

    }
    
    func configureCellForIsLive() {
        backgroundColor = .white
        
        imagePagingDotsView.setDimensions(height: 15, width: frame.width - 15)
        imagePagingView.setDimensions(height: frame.width, width: frame.width)
        
        
        if item?.owner.id == loggedInUser?.id {
            bidNowButton.setTitle(appDele!.isForArabic ? View_ar : View_en, for: .normal)
        } else {
            if item?.hasPaidRegistrationPrice == true {
                bidNowButton.setTitle(appDele!.isForArabic ? Bid_Now_ar : Bid_Now_en, for: .normal)
            } else {
                bidNowButton.setTitle(appDele!.isForArabic ? Participate_ar : Participate_en, for: .normal)
            }
        }
        
        
        let ownerInfoStack = UIStackView(arrangedSubviews: [usernameButton, isVerified, isVerifiedStore])
        ownerInfoStack.axis = .horizontal
        ownerInfoStack.alignment = .center
        ownerInfoStack.spacing = 8
        ownerInfoStack.distribution = .fill
        
        let nameLocationStack = UIStackView(arrangedSubviews: [ownerInfoStack, itemName, storeNameLabel])
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
        
        
        let buttonsStack = UIStackView(arrangedSubviews: [likeButton, commentButton, messageButton])
        buttonsStack.axis = .horizontal
        buttonsStack.alignment = .center
        buttonsStack.distribution = .fillEqually
        buttonsStack.spacing = 10
        
        let buttonMainStack = UIStackView(arrangedSubviews: [buttonsStack,  bidNowButton])
        buttonMainStack.axis = .horizontal
        buttonMainStack.spacing = 10
        buttonMainStack.alignment = .center
        buttonMainStack.distribution = .equalCentering
        buttonMainStack.anchor(width: frame.width - 30, height: 40)
        
        let likesAndCommentsStack = UIStackView(arrangedSubviews: [likeLabel, viewCommentsButton])
        likesAndCommentsStack.axis = .vertical
        likesAndCommentsStack.alignment = .leading
        likesAndCommentsStack.distribution = .fillEqually
        
        let buyLikesCommentStack = UIStackView(arrangedSubviews: [likesAndCommentsStack, UIView()])
        buyLikesCommentStack.axis = .horizontal
        buyLikesCommentStack.alignment = .fill
        buyLikesCommentStack.distribution = .fill
        buyLikesCommentStack.setDimensions(height: 50, width: frame.width - 30)

        let itemPriceStack = UIStackView(arrangedSubviews: [itemPriceLabel, numberOfParticipationLabel, UIView()])
        itemPriceStack.axis = .horizontal
        itemPriceStack.spacing = 10
        itemPriceStack.alignment = .fill
        itemPriceStack.distribution = .fill
        itemPriceStack.setDimensions(height: 20, width: frame.width - 30)
        
        let mainStack = UIStackView(arrangedSubviews: [mainTopBarStack, imagePagingView, imagePagingDotsView, buttonMainStack, buyLikesCommentStack, itemPriceStack])
        mainStack.axis = .vertical
        mainStack.spacing = 6
        mainStack.alignment = .center
        
        addSubview(mainStack)
        mainStack.fillSuperview(padding: UIEdgeInsets(top: 7, left: 0, bottom: 7, right: 0))
        
        self.mainCellStack = mainStack
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
            imagePagingView.transform = trnForm_Ar

        }

    }
    
    func configureCellForIsLiveAuction() {
        backgroundColor = .white
        
        imagePagingDotsView.setDimensions(height: 15, width: frame.width - 15)
        imagePagingView.setDimensions(height: frame.width, width: frame.width)
        
        bidNowButton.setTitle(appDele!.isForArabic ? Participate_ar : Participate_en, for: .normal)
        watchLiveButton.setDimensions(height: 33, width: 100)
        
        let ownerInfoStack = UIStackView(arrangedSubviews: [usernameButton, isVerified, isVerifiedStore])
        ownerInfoStack.axis = .horizontal
        ownerInfoStack.alignment = .center
        ownerInfoStack.spacing = 8
        ownerInfoStack.distribution = .fill
        
        let nameLocationStack = UIStackView(arrangedSubviews: [ownerInfoStack, itemName, storeNameLabel])
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
        
        
        let buttonsStack = UIStackView(arrangedSubviews: [likeButton, commentButton, messageButton])
        buttonsStack.axis = .horizontal
        buttonsStack.alignment = .center
        buttonsStack.distribution = .fillEqually
        buttonsStack.spacing = 10
        
        var buttonMainStack = UIStackView(arrangedSubviews: [buttonsStack, watchLiveButton, bidNowButton])
        if item?.owner.id == loggedInUser?.id {
            buttonMainStack = UIStackView(arrangedSubviews: [buttonsStack, watchLiveButton])
            watchLiveButton.setTitle(appDele!.isForArabic ? Go_Live_ar : Go_Live_en, for: .normal)
        } else {
            watchLiveButton.setTitle(appDele!.isForArabic ? Watch_Live_ar : Watch_Live_en, for: .normal)
        }
        buttonMainStack.axis = .horizontal
        buttonMainStack.spacing = 10
        buttonMainStack.alignment = .center
        buttonMainStack.distribution = .equalCentering
        buttonMainStack.anchor(width: frame.width - 30, height: 40)
        
        let likesAndCommentsStack = UIStackView(arrangedSubviews: [likeLabel, viewCommentsButton])
        likesAndCommentsStack.axis = .vertical
        likesAndCommentsStack.alignment = .leading
        likesAndCommentsStack.distribution = .fillEqually
        
        let buyLikesCommentStack = UIStackView(arrangedSubviews: [likesAndCommentsStack, UIView()])
        buyLikesCommentStack.axis = .horizontal
        buyLikesCommentStack.alignment = .fill
        buyLikesCommentStack.distribution = .fill
        buyLikesCommentStack.setDimensions(height: 50, width: frame.width - 30)

        let itemPriceStack = UIStackView(arrangedSubviews: [itemPriceLabel, numberOfParticipationLabel, UIView()])
        itemPriceStack.axis = .horizontal
        itemPriceStack.spacing = 10
        itemPriceStack.alignment = .fill
        itemPriceStack.distribution = .fill
        itemPriceStack.setDimensions(height: 20, width: frame.width - 30)
        
        let mainStack = UIStackView(arrangedSubviews: [mainTopBarStack, imagePagingView, imagePagingDotsView, buttonMainStack, buyLikesCommentStack, itemPriceStack])
        mainStack.axis = .vertical
        mainStack.spacing = 6
        mainStack.alignment = .center
        
        addSubview(mainStack)
        mainStack.fillSuperview(padding: UIEdgeInsets(top: 7, left: 0, bottom: 7, right: 0))
        
        self.mainCellStack = mainStack
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: self)
        }

    }
    
    func getTimeDifference(fromTime: Date, toTime: Date) -> String {
        let timeDifference = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: fromTime, to: toTime)
        if !(timeDifference.day! < 0), !(timeDifference.hour! < 0), !(timeDifference.minute! < 0), !(timeDifference.second! < 0) {
            if timeDifference.day! == 0 {
                if timeDifference.hour! == 0 {
                     return "Live in 00 : \(String(format: "%02d", timeDifference.minute!)) : \(String(format: "%02d", timeDifference.second!)) :"
                }
                return "Live in \(String(format: "%02d", timeDifference.hour!)) : \(String(format: "%02d", timeDifference.minute!)) : 00"
            }
            return "Live in \(timeDifference.day!) Days"
        }
        return appDele!.isForArabic ? Auction_for_this_post_has_not_started_yet_You_will_be_notified_when_auction_has_started_ar : Auction_for_this_post_has_not_started_yet_You_will_be_notified_when_auction_has_started_en
        
    }
}


extension BiddingCell: SGImagePagingViewDelegate {
    func currentlySelectedIndex(index: IndexPath) {
        imagePagingDotsView.selectedIndex = index.row
    }
}
