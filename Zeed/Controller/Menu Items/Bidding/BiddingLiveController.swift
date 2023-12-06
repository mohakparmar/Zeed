//
//  BiddingLiveController.swift
//  Zeed
//
//  Created by Shrey Gupta on 05/04/21.
//
import UIKit
import GrowingTextView
import EZYGradientView
import AgoraRtcKit

class BiddingLiveController: UIViewController, UIGestureRecognizerDelegate {
    //MARK: - Properties
    var socketService = SocketService.shared
    
    let biddingItem: BidItem
    var isAllowedToBid: Bool
    
    var addBidView: BiddingCellAddBidView?
    var productInfoView: BiddingLiveProductInfoView?
    
    var blackView = UIView()
    
    var numberOfViewersView = BiddingLiveNumberOfViewersView()
    var highestBidderInfoView = BiddingLiveHighestBidderInfoView()
    
    lazy var itemInfoButton = createButton(withImage: #imageLiteral(resourceName: "box"))
    lazy var bidderInfoButton = createButton(withImage: #imageLiteral(resourceName: "people"))
    
    private var inputToolbar: UIView!
    private var textView: GrowingTextView!
    private var textViewBottomConstraint: NSLayoutConstraint!
    
    var commentCollectionView: UICollectionView
    
    private let dismissGesture: UISwipeGestureRecognizer = {
        let gesture = UISwipeGestureRecognizer()
        gesture.direction = .down
        return gesture
    }()
    
    var comments = [CommentObject]()
    
    
    private lazy var markAsSold: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Mark As Sold", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appPrimaryColor
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(markAsSoldClick), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var markAsUnsold: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Mark As Unsold", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appPrimaryColor
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(markAsUnsoldClick), for: .touchUpInside)
        return button
    }()
    
    
    @objc func markAsSoldClick() {
        socketService.markAsSold(forPostId: self.biddingItem.id)
    }
    
    @objc func markAsUnsoldClick() {
        socketService.markAsUnSold(forPostId: self.biddingItem.id)
    }
    
    
    var allBidders = [BidMadeUser]() {
        didSet {
            allBidders.sort { firstBidder, secondBidder in
                return firstBidder.bidAmount > secondBidder.bidAmount
            }
            
            if allBidders.count == 0 {
                maximumBidderName = "Initial Bid"
                maximumBidAmount = Double(biddingItem.initialPrice)
            } else {
                let topBidder = allBidders.first!
                maximumBidAmount = topBidder.bidAmount
                maximumBidderName = topBidder.fullName
            }
        }
    }
    
    var numberOfUsersLive: Int = 0 {
        didSet {
            numberOfViewersView.numberOfViewers = numberOfUsersLive
        }
    }
    
    lazy var maximumBidAmount: Double = Double(biddingItem.initialPrice) {
        didSet {
            highestBidderInfoView.highestBid = maximumBidAmount
            addBidView?.maxPrice = maximumBidAmount
        }
    }
    
    var maximumBidderName: String = "" {
        didSet {
            highestBidderInfoView.bidderName = maximumBidderName
        }
    }
    
    var currentBid: CurrentBidItem? {
        didSet {
            guard let bid = currentBid else { return }
            maximumBidAmount = Double(bid.price)
            maximumBidderName = bid.owner.fullName
        }
    }
    
    private lazy var broadcastersView: AGEVideoContainer = {
        let view = AGEVideoContainer()
        return view
    }()
    
    lazy var videoMuteButton = createButton(withImage: #imageLiteral(resourceName: "video-on"), selectedImage: #imageLiteral(resourceName: "video-off"))
    lazy var audioMuteButton = createButton(withImage: #imageLiteral(resourceName: "mic-on"), selectedImage: #imageLiteral(resourceName: "mic-off"))
    lazy var switchCameraButton = createButton(withImage: #imageLiteral(resourceName: "switch-camera"))
    
    lazy var sessionButtons = [videoMuteButton, audioMuteButton]
    
    private struct HeartAttributes {
        static let heartSize: CGFloat = 36
        static let burstDelay: TimeInterval = 0.1
    }
    
    
    private let beautyOptions: AgoraBeautyOptions = {
        let options = AgoraBeautyOptions()
        options.lighteningContrastLevel = .normal
        options.lighteningLevel = 0.7
        options.smoothnessLevel = 0.5
        options.rednessLevel = 0.1
        return options
    }()
    
    private lazy var agoraKit: AgoraRtcEngineKit = {
        let engine = AgoraRtcEngineKit.sharedEngine(withAppId: KeyCenter.AppId, delegate: self)
        engine.setLogFilter(AgoraLogFilter.info.rawValue)
        engine.setLogFile(FileCenter.logFilePath())
        return engine
    }()
    
    private lazy var placeholderView: UIImageView = {
        let iv =  UIImageView()
        iv.image = #imageLiteral(resourceName: "timer_icon")
        return iv
    }()
    
    var settings: Settings = Settings()
    
    private var isMutedVideo = false {
        didSet {
            // mute local video
            agoraKit.muteLocalVideoStream(isMutedVideo)
            videoMuteButton.isSelected = isMutedVideo
        }
    }
    
    private var isMutedAudio = false {
        didSet {
            // mute local audio
            agoraKit.muteLocalAudioStream(isMutedAudio)
            audioMuteButton.isSelected = isMutedAudio
        }
    }
    
    private var isSwitchCamera = false {
        didSet {
            agoraKit.switchCamera()
        }
    }
    
    private var videoSessions = [VideoSession]() {
        didSet {
            placeholderView.isHidden = (videoSessions.count == 0 ? false : true)
            // update render view layout
            updateBroadcastersView()
        }
    }
    
    private let maxVideoSession = 4
    
    //MARK: - UI Elements
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send_button").withRenderingMode(.alwaysOriginal), for: .normal)
        
        let gradientView = EZYGradientView()
        gradientView.frame = .init(x: 0, y: 0, width: 35, height: 35)
        gradientView.firstColor = .gradientFirstColor
        gradientView.secondColor = .gradientSecondColor
        gradientView.colorRatio = 0.5
        gradientView.fadeIntensity = 0.5
        
        gradientView.isUserInteractionEnabled = false
        
        button.insertSubview(gradientView, at: 0)
        button.bringSubviewToFront(button.imageView!)
        
        button.clipsToBounds = true
        gradientView.clipsToBounds = true
        
        button.addTarget(self, action: #selector(handleSendTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var makeBidButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "hammer_button").withRenderingMode(.alwaysOriginal), for: .normal)
        
        let gradientView = EZYGradientView()
        gradientView.frame = .init(x: 0, y: 0, width: 45, height: 45)
        gradientView.firstColor = .gradientFirstColor
        gradientView.secondColor = .gradientSecondColor
        gradientView.colorRatio = 0.5
        gradientView.fadeIntensity = 0.5
        
        gradientView.isUserInteractionEnabled = false
        
        button.insertSubview(gradientView, at: 0)
        button.bringSubviewToFront(button.imageView!)
        
        button.clipsToBounds = true
        gradientView.clipsToBounds = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(handleBidTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var liveView: SGLiveView = {
        let view = SGLiveView()
        
        view.blinkInterval = 0.8
        
        view.liveLabel.text = biddingItem.owner.id == loggedInUser?.id ? "End Live" : "Live"
        view.liveLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        view.liveLabel.textColor = .white
        
        view.addSubview(view.liveLabel)
        view.liveLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        view.liveLabel.contentMode = .center
        view.liveLabel.textAlignment = .center
        
        view.layer.cornerRadius = 5
        
        view.backgroundColor = .red
        view.setDimensions(height: 30, width: 75)
        
        view.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleLiveTapped))
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(#imageLiteral(resourceName: "cross"), for: .normal)
        button.setDimensions(height: 19, width: 19)
        button.addTarget(self, action: #selector(didSwipeDown), for: .touchUpInside)
        button.tintColor = .appPrimaryColor
        return button
    }()
    
    //MARK: - Lifecycle
    init(forItem item: BidItem, isAllowedToBid: Bool) {
        self.biddingItem = item
        self.isAllowedToBid = isAllowedToBid
        
        commentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        super.init(nibName: nil, bundle: nil)
        
        commentCollectionView.delegate = self
        commentCollectionView.dataSource = self
        
        commentCollectionView.register(BiddingLiveCommentCell.self, forCellWithReuseIdentifier: BiddingLiveCommentCell.reuseIdentifier)
        commentCollectionView.isScrollEnabled = true
        commentCollectionView.alwaysBounceVertical = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        socketService.delegate = self
        
        Utility.openScreenView(str_screen_name: "Bidding_Live", str_nib_name: self.nibName ?? "")

        view.insertSubview(broadcastersView, at: 0)
        broadcastersView.fillSuperview()
        
        itemInfoButton.addTarget(self, action: #selector(handleItemInfoTapped), for: .touchUpInside)
        bidderInfoButton.addTarget(self, action: #selector(handleBidderInfoButton), for: .touchUpInside)
        
        switchCameraButton.addTarget(self, action: #selector(handleSwitchCamera), for: .touchUpInside)
        videoMuteButton.addTarget(self, action: #selector(handleVideoMute), for: .touchUpInside)
        audioMuteButton.addTarget(self, action: #selector(handleAudioMute), for: .touchUpInside)
        
        fetchComments()
        configureUI()
        
        //        dismissGesture.delegate = self
        //        dismissGesture.addTarget(self, action: #selector(didSwipeDown))
        //        view.addGestureRecognizer(dismissGesture)
        
        
        settings = Settings()
        settings.role = loggedInUser?.id == biddingItem.owner.id ? .broadcaster : .audience
        settings.roomName = self.biddingItem.id
        settings.frameRate = .fps30
        
        joinBiddingRoom()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.layer.cornerRadius = (textView.frame.height)/2
        if self.currentBid == nil {
            self.currentBid = self.biddingItem.currentBid
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func sendChat() {
        self.socketService.sendComment(forRoomId: self.biddingItem.id, comment: textView.text!)
        textView.text = ""
    }
    
    //MARK: - Selectors
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        if let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
            if #available(iOS 11, *) {
                if keyboardHeight > 0 {
                    keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom
                }
            }
            textViewBottomConstraint.constant = -keyboardHeight - 8
            view.layoutIfNeeded()
        }
    }
    
    @objc func handleItemInfoTapped() {
        productInfoView = BiddingLiveProductInfoView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 300))
        guard let productInfoView = productInfoView else { return }
        productInfoView.item = biddingItem
        
        bringBlackView()
        
        UIApplication.shared.keyWindow?.addSubview(productInfoView)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.blackView.alpha = 1
            let leftoverSpace = UIScreen.main.bounds.height - 300
            self.productInfoView?.frame.origin.y = leftoverSpace
        })
    }
    
    @objc func handleBidderInfoButton() {
        let controller = BiddingLiveBiddersController(allBidders: allBidders)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleSwitchCamera() {
        isSwitchCamera.toggle()
    }
    
    @objc func handleAudioMute() {
        audioMuteButton.isSelected.toggle()
        isMutedAudio = audioMuteButton.isSelected
    }
    
    @objc func handleVideoMute() {
        videoMuteButton.isSelected.toggle()
        isMutedVideo = videoMuteButton.isSelected
    }
    
    @objc private func tapGestureHandler() {
        view.endEditing(true)
    }
    
    @objc func handleSendTapped() {
        sendChat()
        print("DEBUG:- handleSendTapped")
    }
    
    @objc func handleBidTapped() {
        if self.biddingItem.hasPaidRegistrationPrice {
            addBidView = BiddingCellAddBidView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 340))
            guard let addBidView = addBidView else { return }
            addBidView.item = biddingItem
            
            addBidView.maxPrice = maximumBidAmount
            
            addBidView.delegate = self
            
            bringBlackView()
            
            UIApplication.shared.keyWindow!.addSubview(addBidView)
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.blackView.alpha = 1
                let leftoverSpace = UIScreen.main.bounds.height - 340
                self.addBidView?.frame.origin.y = leftoverSpace
            })
        } else {
            self.present(Utility.showAlertWithTitleAndMessage(title: "", Msg: "Post registraion is pending, you can bid only after registraion."), animated: true)
        }
    }
    
    @objc func dismissPicker() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.blackView.alpha = 0
            self.addBidView?.frame.origin.y = UIScreen.main.bounds.height
            self.productInfoView?.frame.origin.y = UIScreen.main.bounds.height
        }, completion: { (_) in
            self.blackView.removeFromSuperview()
            self.addBidView?.removeFromSuperview()
            self.productInfoView?.removeFromSuperview()
            self.addBidView = nil
            self.productInfoView = nil
        })
    }
    
    @objc func didSwipeDown() {
        if biddingItem.owner.id == loggedInUser?.id {
            handleLiveTapped()
        } else {
            self.dismiss(animated: true) {
                self.socketService.leaveBidding(forPostId: self.biddingItem.id)
                self.leaveChannel()
            }
        }
    }
    
    @objc func handleLiveTapped() {
        if biddingItem.owner.id == loggedInUser?.id {
            let endAlert = UIAlertController(title: "End Live?", message: "Are you sure you want to end this bidding, all bids and users will be removed!", preferredStyle: .alert)
            endAlert.addAction(UIAlertAction(title: "End Bidding", style: .destructive, handler: { _ in
                self.socketService.endBidding(forPostId: self.biddingItem.id)
                self.leaveChannel()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.dismiss(animated: true)
                }
            }))
            
            endAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(endAlert, animated: true, completion: nil)
        }
    }
    
    //MARK: - API
    func fetchComments() {
        
    }
    
    func joinBiddingRoom() {
        socketService.joinBiddingRoom(forPostId: biddingItem.id, type: loggedInUser?.id == biddingItem.owner.id ? .publisher : .subscriber)
    }
    
    //MARK: - Helper Functions
    func configureUI() {
        view.backgroundColor = .darkGray
        commentCollectionView.backgroundColor = .clear
        
        configureNavigationBar(largeTitleColor: .appPrimaryColor, backgoundColor: .appBackgroundColor, tintColor: .appPrimaryColor, title: "Auction", preferredLargeTitle: false)
        liveView.start()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: liveView)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        
        configureBottomTextBar()
        
        
        view.addSubview(numberOfViewersView)
        numberOfViewersView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 12, paddingLeft: 12, width: 100)
        
        
        view.addSubview(highestBidderInfoView)
        highestBidderInfoView.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 12, paddingRight: 12)
        
        
        itemInfoButton.setDimensions(height: 55, width: 55)
        itemInfoButton.layer.cornerRadius = 55/2
        
        bidderInfoButton.setDimensions(height: 55, width: 55)
        bidderInfoButton.layer.cornerRadius = 55/2
        
        switchCameraButton.setDimensions(height: 55, width: 55)
        switchCameraButton.layer.cornerRadius = 55/2
        
        videoMuteButton.setDimensions(height: 55, width: 55)
        videoMuteButton.layer.cornerRadius = 55/2
        
        audioMuteButton.setDimensions(height: 55, width: 55)
        audioMuteButton.layer.cornerRadius = 55/2
        
        
        let bidderInfoAndItemInfoStack = UIStackView(arrangedSubviews: [itemInfoButton, bidderInfoButton])
        bidderInfoAndItemInfoStack.axis = .vertical
        bidderInfoAndItemInfoStack.alignment = .center
        bidderInfoAndItemInfoStack.distribution = .fillProportionally
        bidderInfoAndItemInfoStack.spacing = 8
        
        view.addSubview(bidderInfoAndItemInfoStack)
        bidderInfoAndItemInfoStack.anchor(top: highestBidderInfoView.bottomAnchor, right: highestBidderInfoView.rightAnchor, paddingTop: 19)
        
        if biddingItem.owner.id == loggedInUser?.id {
            let broadcasterButtonsStack = UIStackView(arrangedSubviews: [switchCameraButton, videoMuteButton, audioMuteButton])
            broadcasterButtonsStack.axis = .vertical
            broadcasterButtonsStack.alignment = .center
            broadcasterButtonsStack.distribution = .fillProportionally
            broadcasterButtonsStack.spacing = 8
            
            view.addSubview(broadcasterButtonsStack)
            broadcasterButtonsStack.anchor(top: numberOfViewersView.bottomAnchor, left: numberOfViewersView.leftAnchor, paddingTop: 19)
            
            
        }
    }
    
    func configureBottomTextBar() {
        // *** Create Toolbar
        inputToolbar = UIView()
        inputToolbar.backgroundColor = .clear
        inputToolbar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inputToolbar)
        
        
        
        // *** Create GrowingTextView ***
        textView = GrowingTextView()
        textView.delegate = self
        textView.tintColor = UIColor.white.withAlphaComponent(0.65)
        textView.textColor = .white
        textView.backgroundColor = UIColor.appPrimaryColor.withAlphaComponent(0.75)
        textView.maxLength = 200
        textView.maxHeight = 70
        textView.trimWhiteSpaceWhenEndEditing = true
        textView.placeholder = "Add a comment..."
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        inputToolbar.addSubview(textView)
        textView.layer.cornerRadius = (textView.height + 12 + 12)/2
        textView.textContainerInset = UIEdgeInsets(top: 13.5, left: 10, bottom: 13.5, right: 43)
        
        // *** Autolayout ***
        let topConstraint = textView.topAnchor.constraint(equalTo: inputToolbar.topAnchor, constant: 13)
        topConstraint.priority = UILayoutPriority(999)
        NSLayoutConstraint.activate([
            inputToolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputToolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputToolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            topConstraint
        ])
        
        
        if #available(iOS 11, *) {
            textViewBottomConstraint = textView.bottomAnchor.constraint(equalTo: inputToolbar.safeAreaLayoutGuide.bottomAnchor, constant: -38)
            NSLayoutConstraint.activate([
                textView.leadingAnchor.constraint(equalTo: inputToolbar.safeAreaLayoutGuide.leadingAnchor, constant: 8),
                textView.trailingAnchor.constraint(equalTo: inputToolbar.safeAreaLayoutGuide.trailingAnchor, constant: isAllowedToBid == true ? -63 : -8),
                textViewBottomConstraint
            ])
        } else {
            textViewBottomConstraint = textView.bottomAnchor.constraint(equalTo: inputToolbar.bottomAnchor, constant: -38)
            NSLayoutConstraint.activate([
                textView.leadingAnchor.constraint(equalTo: inputToolbar.leadingAnchor, constant: 8),
                textView.trailingAnchor.constraint(equalTo: inputToolbar.trailingAnchor, constant: isAllowedToBid == true ? -63 : -8),
                textViewBottomConstraint
            ])
        }
        
        inputToolbar.addSubview(sendButton)
        sendButton.anchor(right: textView.rightAnchor, paddingRight: 8)
        sendButton.centerY(inView: textView)
        sendButton.setDimensions(height: 35, width: 35)
        sendButton.layer.cornerRadius = 35/2
        
        if isAllowedToBid {
            if loggedInUser?.id != biddingItem.owner.id {
                view.addSubview(makeBidButton)
                makeBidButton.anchor(right: inputToolbar.rightAnchor, paddingRight: 8)
                makeBidButton.centerY(inView: textView)
                makeBidButton.imageView?.contentMode = .scaleAspectFit
                makeBidButton.setDimensions(height: 45, width: 45)
                makeBidButton.layer.cornerRadius = 45/2
                makeBidButton.imageView!.setDimensions(height: 27, width: 27)
            }
        }
        
        
        
        view.addSubview(commentCollectionView)
        commentCollectionView.anchor(left: view.leftAnchor, bottom: inputToolbar.topAnchor, right: view.rightAnchor, height: view.frame.height/3.5)
        
        if biddingItem.owner.id == loggedInUser?.id {
            let mainTopBarStack = UIStackView(arrangedSubviews: [markAsSold, markAsUnsold])
            mainTopBarStack.axis = .horizontal
            mainTopBarStack.spacing = 7
            mainTopBarStack.alignment = .center
            mainTopBarStack.distribution = .fillEqually
            mainTopBarStack.frame = CGRect(x: 20, y: view.height - 150, width: screenWidth - 40, height: 50)
            view.addSubview(mainTopBarStack)
        }
        
        // *** Listen to keyboard show / hide ***
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // *** Hide keyboard when tapping outside ***
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        view.addGestureRecognizer(tapGesture)
    }
    
    func createButton(withImage image: UIImage, selectedImage: UIImage? = nil) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        
        if let selectedImage = selectedImage {
            button.setImage(selectedImage.withRenderingMode(.alwaysTemplate), for: .selected)
        }
        
        button.tintColor = .white
        
        button.imageView!.setDimensions(height: 35, width: 35)
        
        button.imageView!.contentMode = .scaleAspectFit
        
        let blurView = UIVisualEffectView()
        blurView.setDimensions(height: 55, width: 55)
        blurView.effect = UIBlurEffect(style: .regular)
        blurView.layer.cornerRadius = 55/2
        blurView.isUserInteractionEnabled = false
        
        button.insertSubview(blurView, at: 0)
        
        button.clipsToBounds = true
        
        return button
    }
    
    func bringBlackView() {
        blackView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        blackView.alpha = 0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
        blackView.gestureRecognizers = [tap]
        blackView.isUserInteractionEnabled = true
        
        UIApplication.shared.keyWindow?.addSubview(blackView)
        blackView.fillSuperview()
    }
}

//MARK: - Delegate GrowingTextViewDelegate
extension BiddingLiveController: GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveLinear], animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

//MARK: - DataSource UICollectionViewDataSource
extension BiddingLiveController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BiddingLiveCommentCell.reuseIdentifier, for: indexPath) as! BiddingLiveCommentCell
        cell.comment =  comments[indexPath.row]
        cell.backgroundColor = .clear
        return cell
    }

}




//MARK: - Delegate UICollectionViewDelegate
extension BiddingLiveController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let msgHeight = self.heightForLabel(text: comments[indexPath.row].text, width: screenWidth - 70)
        return CGSize(width: view.frame.width - 30, height: msgHeight + 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func heightForLabel(text: String, width: CGFloat) -> CGFloat {

       let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
       label.numberOfLines = 0
       label.lineBreakMode = NSLineBreakMode.byWordWrapping
       label.text = text
       label.sizeToFit()

       return label.frame.height
    }

}

//MARK: - Delegate BiddingCellAddBidViewDelegate
extension BiddingLiveController: BiddingCellAddBidViewDelegate {
    func addBidView(_ addBidView: BiddingCellAddBidView, didBidWithAmount amount: Double, forItem item: BidItem) {
        socketService.addBid(amount: amount, toPostId: item.id)
        dismissPicker()
    }
}

//MARK: - Delegate SocketService
extension BiddingLiveController: SocketServiceDelegate {
    func sendComment(objComment: CommentObject) {
        if objComment.roomId == self.biddingItem.id {
            comments.append(objComment)
            self.commentCollectionView.reloadData()
            let lastItemIndex = self.commentCollectionView.numberOfItems(inSection: 0) - 1
            let indexPath:IndexPath = IndexPath(item: lastItemIndex, section: 0)
            self.commentCollectionView.scrollToItem(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    
    func bidsMade(allBiders: [BidMadeUser]) {
        self.allBidders = allBiders
    }
    
    
    
    func markAsUnSold(status: Bool, maxBidUser: CurrentBidItem?) {
        if status {
            if biddingItem.owner.id == loggedInUser?.id {
                self.socketService.endBidding(forPostId: self.biddingItem.id)
                self.leaveChannel()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.dismiss(animated: true)
                }
            } else {
                let alert = UIAlertController(title: "Item Sold!", message: "This item has been marked as sold by the host!\n If you didn't win this auction, all amount will be refunded to your account soon.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
                    self.didSwipeDown()
                }))
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    
    
    func markAsSold(status: Bool, maxBidUser: CurrentBidItem?) {
        if status {
            if currentBid?.owner.id == loggedInUser?.id {
                let alert = UIAlertController(title: "Congratulations!", message: "This item has been marked as sold by the host to you.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
                    self.didSwipeDown()
                }))
                present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Item Sold!", message: "This item has been marked as sold by the host!\n If you didn't win this auction, all amount will be refunded to your account soon.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
                    self.didSwipeDown()
                }))
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func currentBid(maxBid: Double, maxBidUser: CurrentBidItem) {
        self.currentBid = maxBidUser
        self.maximumBidAmount = maxBid
        self.showAlert(withMsg: "Current Bid Updated!")
    }
    
    func didJoinRoom(status: Bool, maxBid: Double?, uid: Int?, token: String?) {
        if status {
            guard let uid = uid else { return }
            guard let token = token else { return }
            
            loadAgoraKit(forToken: token, uid: uid)
        }
    }
    
    func liveUsers(count: Int) {
        self.numberOfUsersLive = count
    }
    
    func didAddBid(status: Bool, msg: String) {
        if status == true {
            self.showAlert(withMsg: "Bid added successfully.")
        } else if msg != "" {
            self.showAlert(withMsg: msg)
        }
    }
    
    
    func leaveBidding(status: Bool) {}
    
    func endBidding(status: Bool) {
        if status {
            let alert = UIAlertController(title: "Bidding Ended", message: "This bidding has been ended by the host, now you cannot bid anymore!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { _ in
                self.didSwipeDown()
            }))
            
            present(alert, animated: true)
        }
    }
}

//MARK: - Agora Media SDK Helper Functions
extension BiddingLiveController {
    func loadAgoraKit(forToken token: String, uid: Int) {
        print("DEBUG:- loading kit")
        let channelId = self.biddingItem.id
        
        setIdleTimerActive(false)
        
        // Step 1, set delegate to inform the app on AgoraRtcEngineKit events
        agoraKit.delegate = self
        
        // Step 2, set live broadcasting mode
        // for details: https://docs.agora.io/cn/Video/API%20Reference/oc/Classes/AgoraRtcEngineKit.html#//api/name/setChannelProfile:
        agoraKit.setChannelProfile(.liveBroadcasting)
        
        // set client role
        agoraKit.setClientRole(settings.role)
        
        // Step 3, Warning: only enable dual stream mode if there will be more than one broadcaster in the channel
        agoraKit.enableDualStreamMode(true)
        
        // Step 4, enable the video module
        agoraKit.enableVideo()
        
        // set video configuration
        agoraKit.setVideoEncoderConfiguration(
            AgoraVideoEncoderConfiguration(
                size: settings.dimension,
                frameRate: settings.frameRate,
                bitrate: AgoraVideoBitrateStandard,
                orientationMode: .adaptative
            )
        )
        
        // if current role is broadcaster, add local render view and start preview
        if settings.role == .broadcaster {
            addLocalSession()
            agoraKit.startPreview()
        }
        
        // Step 5, join channel and start group chat
        // If join  channel success, agoraKit triggers it's delegate function
        // 'rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int)'
        agoraKit.joinChannel(
            byToken: token, channelId: channelId, info: nil, uid: UInt(uid)) { channed, uid, elapsed in
                print("DEBUG:- CHANNEL: \(channed) | UID: \(uid) | ELAPSED: \(elapsed)")
            }
        
        // Step 6, set speaker audio route
        agoraKit.setEnableSpeakerphone(true)
    }
    
    func addLocalSession() {
        let localSession = VideoSession.localSession()
        localSession.updateInfo(fps: settings.frameRate.rawValue)
        videoSessions.append(localSession)
        agoraKit.setupLocalVideo(localSession.canvas)
    }
    
    func leaveChannel() {
        // Step 1, release local AgoraRtcVideoCanvas instance
        agoraKit.setupLocalVideo(nil)
        // Step 2, leave channel and end group chat
        agoraKit.leaveChannel(nil)
        
        // Step 3, if current role is broadcaster,  stop preview after leave channel
        if settings.role == .broadcaster {
            agoraKit.stopPreview()
        }
        
        setIdleTimerActive(true)
        
        navigationController?.popViewController(animated: true)
    }
    
    func updateBroadcastersView() {
        // video views layout
        if videoSessions.count == maxVideoSession {
            broadcastersView.reload(level: 0, animated: true)
        } else {
            var rank: Int
            var row: Int
            
            if videoSessions.count == 0 {
                return
            } else if videoSessions.count == 1 {
                rank = 1
                row = 1
            } else if videoSessions.count == 2 {
                rank = 1
                row = 2
            } else {
                rank = 2
                row = Int(ceil(Double(videoSessions.count) / Double(rank)))
            }
            
            let itemWidth = CGFloat(1.0) / CGFloat(rank)
            let itemHeight = CGFloat(1.0) / CGFloat(row)
            let itemSize = CGSize(width: itemWidth, height: itemHeight)
            let layout = AGEVideoLayout(level: 0)
                .itemSize(.scale(itemSize))
            
            broadcastersView
                .listCount { [unowned self] (_) -> Int in
                    return self.videoSessions.count
                }.listItem { [unowned self] (index) -> UIView in
                    return self.videoSessions[index.item].hostingView
                }
            
            broadcastersView.setLayouts([layout], animated: true)
        }
    }
    
    func updateButtonsVisiablity() {
        let isHidden = settings.role == .audience
        
        for item in sessionButtons {
            item.isHidden = isHidden
        }
    }
    
    func setIdleTimerActive(_ active: Bool) {
        UIApplication.shared.isIdleTimerDisabled = !active
    }
    
    func getSession(of uid: UInt) -> VideoSession? {
        for session in videoSessions {
            if session.uid == uid {
                return session
            }
        }
        return nil
    }
    
    func videoSession(of uid: UInt) -> VideoSession {
        if let fetchedSession = getSession(of: uid) {
            return fetchedSession
        } else {
            let newSession = VideoSession(uid: uid)
            videoSessions.append(newSession)
            return newSession
        }
    }
}

// MARK: - Delegate AgoraRtcEngineDelegate
extension BiddingLiveController: AgoraRtcEngineDelegate {
    // first local video frame
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstLocalVideoFrameWith size: CGSize, elapsed: Int) {
        if let selfSession = videoSessions.first {
            selfSession.updateInfo(resolution: size)
        }
    }
    
    // local stats
    func rtcEngine(_ engine: AgoraRtcEngineKit, reportRtcStats stats: AgoraChannelStats) {
        if let selfSession = videoSessions.first {
            selfSession.updateChannelStats(stats)
        }
    }
    
    // first remote video frame
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int) {
        guard videoSessions.count <= maxVideoSession else {
            return
        }
        
        let userSession = videoSession(of: uid)
        userSession.updateInfo(resolution: size)
        agoraKit.setupRemoteVideo(userSession.canvas)
    }
    
    // user offline
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        var indexToDelete: Int?
        for (index, session) in videoSessions.enumerated() where session.uid == uid {
            indexToDelete = index
            break
        }
        
        if let indexToDelete = indexToDelete {
            let deletedSession = videoSessions.remove(at: indexToDelete)
            deletedSession.hostingView.removeFromSuperview()
            deletedSession.canvas.view = nil
        }
    }
    
    // remote video stats
    func rtcEngine(_ engine: AgoraRtcEngineKit, remoteVideoStats stats: AgoraRtcRemoteVideoStats) {
        if let session = getSession(of: stats.uid) {
            session.updateVideoStats(stats)
        }
    }
    
    // remote audio stats
    func rtcEngine(_ engine: AgoraRtcEngineKit, remoteAudioStats stats: AgoraRtcRemoteAudioStats) {
        if let session = getSession(of: stats.uid) {
            session.updateAudioStats(stats)
        }
    }
    
    // warning code
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurWarning warningCode: AgoraWarningCode) {
        print("Warning code: \(warningCode.description)")
        // Utility.showISMessage(str_title: "warning code: \(warningCode.description)", Message: "", msgtype: 2)
    }
    
    // error code
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        print("Error code: \(errorCode.description)")
        //   Utility.showISMessage(str_title: "Error code: \(errorCode.description)", Message: "", msgtype: 2)
    }
}
