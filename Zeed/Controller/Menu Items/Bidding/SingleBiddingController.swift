//
//  SingleBiddingController.swift
//  Zeed
//
//  Created by Shrey Gupta on 10/05/21.
//

import UIKit
import JGProgressHUD

class SingleBiddingController: UIViewController {
    //MARK: - Properties
    var biddingItem: BidItem
    
    let socketService = SocketService.shared
    
    var hud = JGProgressHUD(style: .dark)
    
    var collectionView: UICollectionView
    var isForDetail : Bool = false
    
    var allBidders = [BidMadeUser]() {
        didSet {
            allBidders.sort { firstBidder, secondBidder in
                return firstBidder.bidAmount > secondBidder.bidAmount
            }
        }
    }
    
    var addBidView: BiddingCellAddBidView?
    var blackView = UIView()
    
    var numberOfLiveUser: Int = 0 {
        didSet {
            let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! BiddingExpandedCell
            cell.liveUserCount = numberOfLiveUser
        }
    }
    
    var maximumPrice: Double = 0 {
        didSet {
            let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! BiddingExpandedCell
            cell.maximumPrice = maximumPrice
            addBidView?.maxPrice = maximumPrice
        }
    }
    
    var currentMaxBid: CurrentBidItem?

    //MARK: - UI Elements
    
    //MARK: - Lifecycle
    init(forBidItem item: BidItem) {
        self.biddingItem = item
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(nibName: nil, bundle: nil)
        
        collectionView.register(BiddingExpandedCell.self, forCellWithReuseIdentifier: BiddingExpandedCell.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        socketService.delegate = self
        Utility.openScreenView(str_screen_name: "Bidding_Post_Details", str_nib_name: self.nibName ?? "")

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        
        configureUI()
        joinBiddingRoom()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let nav = self.navigationController {
            let isPopping = !nav.viewControllers.contains(self)
            if isPopping {
                socketService.leaveBidding(forPostId: biddingItem.id)
                print("DEBUG:- emitted leaveBidding")
            }
        }
    }

    
    //MARK: - Selectors
    @objc func dismissPicker() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.blackView.alpha = 0
            self.addBidView?.frame.origin.y = self.view.frame.height
        }, completion: { (_) in
            self.blackView.removeFromSuperview()
            self.addBidView?.removeFromSuperview()
            self.addBidView = nil
        })
    }
    
    //MARK: - API
    func joinBiddingRoom() {
        socketService.joinBiddingRoom(forPostId: biddingItem.id, type: .normalBidding)
    }

    //MARK: - Helper Functions
    func configureUI() {
        view.backgroundColor = .backgroundWhiteColor
 
        collectionView.backgroundColor = .appBackgroundColor
        
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        
        if appDele?.isForArabic == true {
            ConvertArabicViews.init().tranFormingView(toArabic: self.view)
        }

    }
    
    func bringBlackView() {
        blackView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        blackView.alpha = 0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
        blackView.gestureRecognizers = [tap]
        blackView.isUserInteractionEnabled = true
        
        UIApplication.shared.keyWindow!.addSubview(blackView)
        blackView.fillSuperview()
    }
    
    func bringAddBidPicker(forCell cell: BiddingCell) {
        addBidView = BiddingCellAddBidView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 340))
        guard let addBidView = addBidView else { return }
        addBidView.item = cell.item
        addBidView.maxPrice = maximumPrice
        
        addBidView.delegate = self
        
        bringBlackView()
        
        UIApplication.shared.keyWindow!.addSubview(addBidView)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.blackView.alpha = 1
            let leftoverSpace = UIScreen.main.bounds.height - 340
            self.addBidView?.frame.origin.y = leftoverSpace
        })
    }
}

//MARK: - DataSource UICollectionViewDataSource
extension SingleBiddingController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BiddingExpandedCell.reuseIdentifier, for: indexPath) as! BiddingExpandedCell
        cell.delegate = self
        cell.item = biddingItem
        
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        cell.liveUserCount = numberOfLiveUser
        cell.maximumPrice = maximumPrice
        cell.commentReplyButton.isHidden = true
        return cell
    }
}

//MARK: - Delegate UICollectionViewDelegate
extension SingleBiddingController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (7 + 45 + 6 + 15 + 6 + 40 + 6 + 50 + 6 + 80 + 6 + 20 + 27)
        return CGSize(width: view.frame.width, height: view.frame.width + CGFloat(height))
    }
}

//MARK: - Delegate BiddingCellDelegate
extension SingleBiddingController: BiddingCellDelegate {
    func openDetailView(for cell: BiddingCell) {
        
    }
    
    func handleBidTapped(for cell: BiddingCell) {
        guard let item = cell.item else { return }
        if item.owner.id == loggedInUser?.id {
            self.handleOptionsTapped(for: cell)
        } else {
            bringAddBidPicker(forCell: cell)
        }
    }
    
    func handleWatchLiveTapped(for cell: BiddingCell) {
        guard let item = cell.item else { return }
        if item.owner.id == loggedInUser?.id {
            let nav = UINavigationController(rootViewController: BiddingLiveController(forItem: item, isAllowedToBid: true))
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        } else {
            if item.hasPaidRegistrationPrice {
                let nav = UINavigationController(rootViewController: BiddingLiveController(forItem: item, isAllowedToBid: true))
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            } else {
                navigationController?.pushViewController(BiddingPayController(forBidItem: item), animated: true)
            }
        }
        
//        let nav = UINavigationController(rootViewController: BiddingLiveController(forItem: post, isAllowedToBid: false))
//        nav.modalPresentationStyle = .fullScreen
//        self.present(nav, animated: true, completion: nil)
    }
    
    func handleUsernameTapped(for cell: BiddingCell) {
        guard let item = cell.item else { return }
//        let controller = UserProfileController(forUserId: item.owner.id)
        let obj = OtherProfileVC()
        obj.userId = item.owner.id
        navigationController?.pushViewController(obj, animated: true)
    }
    
    func handleOptionsTapped(for cell: BiddingCell) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        guard let item = cell.item else { return }
        
        if biddingItem.owner.id == loggedInUser?.id {
            alert.addAction(UIAlertAction(title: "Mark as Sold", style: .default, handler: { _ in
                let soldAlert = UIAlertController(title: "Mark as Sold?", message: "Are you sure you want to mark this as sold?", preferredStyle: .alert)
                
                soldAlert.addAction(UIAlertAction(title: "Sold", style: .default, handler: { _ in
                    self.socketService.markAsSold(forPostId: item.id)
                    self.navigationController?.popViewController(animated: true)
                }))
                
                soldAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                
                self.present(soldAlert, animated: true, completion: nil)
            }))
            
            alert.addAction(UIAlertAction(title: "End Bidding", style: .default, handler: { _ in
                let endAlert = UIAlertController(title: "End Bidding", message: "Are you sure you want to end this bidding, all bids and users will be removed!", preferredStyle: .alert)
                endAlert.addAction(UIAlertAction(title: "End Bidding", style: .destructive, handler: { _ in
                    self.socketService.endBidding(forPostId: item.id)
                    self.navigationController?.popViewController(animated: true)
                }))
                
                endAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                self.present(endAlert, animated: true, completion: nil)
            }))
        } else {
            if item.isReported {
                alert.addAction(UIAlertAction(title: "Reported", style: .destructive, handler: { (action) in
                    self.showAlert(withMsg: "Post Already Reported!")
                }))
            } else {
                alert.addAction(UIAlertAction(title: "Report", style: .destructive, handler: { (action) in
                    Service.shared.reportPost(withId: item.id) { status in
                        if status {
                            self.showAlert(withMsg: "Post Reported!")
                            self.biddingItem.isReported = true
                        } else {
                            self.showAlert(withMsg: "Failed to Report Post!")
                        }
                    }
                }))
            }
            
            
            alert.addAction(UIAlertAction(title: "Unfollow \(item.owner.userName)", style: .default, handler: { _ in
                Service.shared.performAction(ofType: .unfollow, onUser: item.owner) { status in
                    if status {
                        self.showAlert(withMsg: "Unfollowed \(item.owner.userName) successfully!")
                    } else {
                        self.showAlert(withMsg: "Unfollowed \(item.owner.userName) failed!")
                    }
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Message", style: .default, handler: { _ in
                self.showAlert(withMsg: "handle MessageTapped")
            }))
        }
        
        
        
        alert.addAction(UIAlertAction(title: "View All Bidders", style: .default, handler: { _ in
            let controller = BiddingLiveBiddersController(allBidders: self.allBidders)
            self.navigationController?.pushViewController(controller, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Share", style: .default, handler: { (action) in
            guard let item = cell.item else { return }
            guard let image = item.medias.first?.url else { return }
            let text = "Hey, check out this \(item.title) at Zeed! \n\(item.about)"
            let link = URL(string: "zeed://post=\(item.id)")!
            let shareAll = [text, image, link] as [Any]
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func handleLikeTapped(for cell: BiddingCell) {
        guard let item = cell.item else { return }
        if cell.likeButton.isSelected {
            Service.shared.dislikePost(withPostId: item.id) { (status) in
                if status {
                    cell.likeButton.isSelected = false
                    cell.item?.isLiked = false
                    self.biddingItem.isLiked = false
                    self.biddingItem.likeCount = self.biddingItem.likeCount - 1
                    self.collectionView.reloadData()
                }
            }
        } else {
            Service.shared.likePost(withPostId: item.id) { (status) in
                if status {
                    cell.likeButton.isSelected = true
                    cell.item?.isLiked = true
                    self.biddingItem.isLiked = true
                    self.biddingItem.likeCount = self.biddingItem.likeCount + 1
                    self.collectionView.reloadData()
                }
            }
        }

        
    }
    
    func handleCommentTapped(for cell: BiddingCell) {
        guard let item = cell.item else { return }
        let commentControler = CommentController(forPostWithId: item.id)
        navigationController?.pushViewController(commentControler, animated: true)
    }
    
    func handleMessageTapped(for cell: BiddingCell) {
        let controller = UINavigationController(rootViewController: ChatViewController())
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .coverVertical
        
        present(controller, animated: true, completion: nil)
    }
    
    
}

extension SingleBiddingController: BiddingCellAddBidViewDelegate {
    func addBidView(_ addBidView: BiddingCellAddBidView, didBidWithAmount amount: Double, forItem item: BidItem) {
        socketService.addBid(amount: amount, toPostId: item.id)
        dismissPicker()
    }
}

extension SingleBiddingController: SocketServiceDelegate {
    func markAsUnSold(status: Bool, maxBidUser: CurrentBidItem?) {
        
    }
    
    func sendComment(objComment: CommentObject) {
        
    }
 
    func bidsMade(allBiders: [BidMadeUser]) {
        self.allBidders = allBiders
    }
    
    func markAsSold(status: Bool, maxBidUser: CurrentBidItem?) {
        if status {
            if currentMaxBid?.owner.id == loggedInUser?.id {
                let alert = UIAlertController(title: "Congratulations!", message: "This item has been marked as sold by the host to you.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
                    self.navigationController?.popToRootViewController(animated: true)
                }))
                present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Item Sold!", message: "This item has been marked as sold by the host!\n If you didn't win this auction, all amount will be refunded to your account soon.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
                    self.navigationController?.popToRootViewController(animated: true)
                }))
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func currentBid(maxBid: Double, maxBidUser: CurrentBidItem) {
        self.maximumPrice = maxBid
        self.currentMaxBid = maxBidUser
        self.showAlert(withMsg: "Current Bid Updated!")
    }
    
    func didJoinRoom(status: Bool, maxBid: Double?, uid: Int?, token: String?) {
        if status {
            guard let maxBid = maxBid else { return }
            self.maximumPrice = maxBid
        }
    }
    
    func liveUsers(count: Int) {
        self.numberOfLiveUser = count
    }
    
    func didAddBid(status: Bool, msg : String = "") {
        if status == true {
            self.showAlert(withMsg: "Bid added successfully.")
        } else if msg != "" {
            self.showAlert(withMsg: msg)
        }
    }
    
    func leaveBidding(status: Bool) {
        print("DEBUG:- LEFT ROOM: \(status)")
    }
    
    func endBidding(status: Bool) {
        if status {
            let alert = UIAlertController(title: "Bidding Ended", message: "This bidding has been ended by the host, now you cannot bid anymore!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { _ in
                self.navigationController?.popToRootViewController(animated: true)
            }))
            
            present(alert, animated: true)
        }
    }
}
