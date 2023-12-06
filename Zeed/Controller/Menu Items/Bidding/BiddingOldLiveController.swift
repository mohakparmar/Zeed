//
//  BiddingOldLiveController.swift
//  Zeed
//
//  Created by Shrey Gupta on 31/10/21.
//

import UIKit
import EZYGradientView
import AVFoundation
import SwiftUI

class BiddingOldLiveController: UIViewController, UIGestureRecognizerDelegate {
    //MARK: - Properties
    var socketService = SocketService.shared
    
    var player: AVPlayer?
    
    let biddingItem: BidItem
    let liveSellerDetails: User
    
    var addBidView: BiddingCellAddBidView?
    var productInfoView: BiddingLiveProductInfoView?
    
    var blackView = UIView()
    
    var highestBidderInfoView = BiddingLiveHighestBidderInfoView()
    
    lazy var itemInfoButton = createButton(withImage: #imageLiteral(resourceName: "box"))
    lazy var bidderInfoButton = createButton(withImage: #imageLiteral(resourceName: "people"))
    
    private let dismissGesture: UISwipeGestureRecognizer = {
        let gesture = UISwipeGestureRecognizer()
        gesture.direction = .down
        return gesture
    }()
    
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
    
    private lazy var broadcastersView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var placeholderView: UIImageView = {
        let iv =  UIImageView()
        iv.image = #imageLiteral(resourceName: "timer_icon")
        return iv
    }()

    //MARK: - UI Elements
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
    init(forItem item: BidItem, ofSeller seller: User) {
        self.biddingItem = item
        self.liveSellerDetails = seller
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        socketService.delegate = self
        
        view.insertSubview(broadcastersView, at: 0)
        broadcastersView.fillSuperview()
        
        Utility.openScreenView(str_screen_name: "Bidding_Live", str_nib_name: self.nibName ?? "")

        itemInfoButton.addTarget(self, action: #selector(handleItemInfoTapped), for: .touchUpInside)
        bidderInfoButton.addTarget(self, action: #selector(handleBidderInfoButton), for: .touchUpInside)

        configureUI()
        
        dismissGesture.delegate = self
        dismissGesture.addTarget(self, action: #selector(didSwipeDown))
        view.addGestureRecognizer(dismissGesture)
        
        joinBiddingRoom()
        playBackgoundVideo()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func playBackgoundVideo() {
        let videoURL = URL(string: liveSellerDetails.liveDetails.recording)
        player = AVPlayer(url: videoURL!)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: nil) { (_) in
            self.player?.seek(to: CMTime.zero)
            self.player?.play()
        }
        self.broadcastersView.layer.addSublayer(playerLayer)
        player?.play()
    }
    
    //MARK: - Selectors
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
    
    @objc private func tapGestureHandler() {
        view.endEditing(true)
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
        
        self.dismiss(animated: true) {
            self.socketService.leaveBidding(forPostId: self.biddingItem.id)
        }
    }
    //MARK: - API
    func joinBiddingRoom() {
        socketService.joinBiddingRoom(forPostId: biddingItem.id, type: loggedInUser?.id == biddingItem.owner.id ? .publisher : .subscriber)
    }
    
    //MARK: - Helper Functions
    func configureUI() {
        view.backgroundColor = .darkGray
        
        configureNavigationBar(largeTitleColor: .appPrimaryColor, backgoundColor: .appBackgroundColor, tintColor: .appPrimaryColor, title: "Auction", preferredLargeTitle: false)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        
        view.addSubview(highestBidderInfoView)
        highestBidderInfoView.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 12, paddingRight: 12)
        
        
        itemInfoButton.setDimensions(height: 55, width: 55)
        itemInfoButton.layer.cornerRadius = 55/2
        
        bidderInfoButton.setDimensions(height: 55, width: 55)
        bidderInfoButton.layer.cornerRadius = 55/2
        
        let bidderInfoAndItemInfoStack = UIStackView(arrangedSubviews: [itemInfoButton, bidderInfoButton])
        bidderInfoAndItemInfoStack.axis = .vertical
        bidderInfoAndItemInfoStack.alignment = .center
        bidderInfoAndItemInfoStack.distribution = .fillProportionally
        bidderInfoAndItemInfoStack.spacing = 8
        
        view.addSubview(bidderInfoAndItemInfoStack)
        bidderInfoAndItemInfoStack.anchor(top: highestBidderInfoView.bottomAnchor, right: highestBidderInfoView.rightAnchor, paddingTop: 19)
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



//MARK: - Delegate SocketService
extension BiddingOldLiveController: SocketServiceDelegate {
    func markAsUnSold(status: Bool, maxBidUser: CurrentBidItem?) {
        
    }
    
    func sendComment(objComment: CommentObject) {
    }
    
    
    func bidsMade(allBiders: [BidMadeUser]) {
        self.allBidders = allBiders
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
        self.showAlert(withMsg: appDele!.isForArabic ? Bid_incremental_price_for_this_post_was_updated_ar : Bid_incremental_price_for_this_post_was_updated_en )
    }
    
    func didJoinRoom(status: Bool, maxBid: Double?, uid: Int?, token: String?) {}
    
    func liveUsers(count: Int) {}
    
    
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
