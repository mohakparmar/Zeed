//
//  BiddingController.swift
//  Zeed
//
//  Created by Shrey Gupta on 28/02/21.
//

import UIKit
import AVFoundation
import AVKit

class BiddingController: UIViewController {
    //MARK: - Properties
    var collectionView: UICollectionView
    
    var addBidView: BiddingCellAddBidView?
    var forwardPicker: ForwardMessagePicker!
    
    var blackView = UIView()
    
    var biddingStoriesModel: BiddingStories? {
        didSet {
            guard let _ = biddingStoriesModel else { return }
        }
    }
    
    var allBidItems = [BidItem]() {
        didSet {
            if allBidItems.count == 0 {
                followNowButton.alpha = 1
                noPostsAvailableLabel.alpha = 1
            } else {
                followNowButton.alpha = 0
                noPostsAvailableLabel.alpha = 0
            }
            collectionView.reloadData()
            
        }
    }
    
    var allStoriesItems = [User]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var isForSingleItem: Bool
    var isStoriesAvailable: Bool = false
    
    private let noPostsAvailableLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? No_posts_available_ar : No_posts_available_en
        label.textColor = .appPrimaryColor
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    
    private lazy var followNowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(appDele!.isForArabic ? Refresh_ar : Refresh_en, for: .normal)
        button.setDimensions(height: 30, width: 130)
        button.setBorder(colour: "007DA5", alpha: 1, radius: 15, borderWidth: 1)
        button.addTarget(self, action: #selector(followNowButtonClick), for: .touchUpInside)
        button.tintColor = .appPrimaryColor
        return button
    }()
    
    @objc func followNowButtonClick() {
        fetchBiddingItems()
        if loggedInUser != nil {
            fetchAllStories()
        }
    }
    
    
    //MARK: - UI Elements
    private lazy var cartButton: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(#imageLiteral(resourceName: "cartWithOutBadge"), for: .normal)
        button.setDimensions(height: 30, width: 30)
        button.addTarget(self, action: #selector(handleCart), for: .touchUpInside)
        button.tintColor = .appPrimaryColor
        return button
    }()
    
    
    func addBadge(itemvalue: String) -> BadgeButton {
        let bagButton = BadgeButton()
        bagButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        bagButton.tintColor = .appPrimaryColor
        bagButton.setImage(UIImage(named: "cartWithOutBadge")?.withRenderingMode(.alwaysTemplate), for: .normal)
        bagButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 15)
        bagButton.badge = itemvalue
        bagButton.addTarget(self, action: #selector(handleCart), for: .touchUpInside)
        return bagButton
    }
    
    //MARK: - API
    func fetchCartItems() {
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: messageButton), UIBarButtonItem(customView: self.addBadge(itemvalue: "0"))]
        Service.shared.getCartItems { (cartItems, status, message) in
            if status {
                guard let cartItems = cartItems else { return }
                appDele?.arrForCart = cartItems
                if cartItems.count > 0 {
                    self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: self.messageButton), UIBarButtonItem(customView: self.addBadge(itemvalue: "\(cartItems.count)"))]
                }
            }
        }
    }
    
    private lazy var messageButton: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(named: "message"), for: .normal)
        button.setDimensions(height: 30, width: 30)
        button.addTarget(self, action: #selector(handleMessages), for: .touchUpInside)
        button.tintColor = .appPrimaryColor
        return button
    }()
    
    private lazy var notificationButton: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(#imageLiteral(resourceName: "notification"), for: .normal)
        button.setDimensions(height: 30, width: 30)
        button.addTarget(self, action: #selector(handleNotification), for: .touchUpInside)
        button.tintColor = .appPrimaryColor
        return button
    }()
    
    //MARK: - Lifecycle
    init(isForSingleItem: Bool) {
        self.isForSingleItem = isForSingleItem
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.collectionView.alwaysBounceVertical = true
        super.init(nibName: nil, bundle: nil)
        
        self.collectionView.register(BiddingStories.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BiddingStories.reuseIdentifier)
        collectionView.register(BiddingCell.self, forCellWithReuseIdentifier: BiddingCell.reuseIdentifier)
    }
    
    var refresher:UIRefreshControl!
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        Utility.openScreenView(str_screen_name: "Bidding_Post_List", str_nib_name: self.nibName ?? "")

        
        if !isForSingleItem {
            fetchBiddingItems()
            if loggedInUser != nil {
                fetchAllStories()
            }
        }
        
        configureUI()
        
        self.refresher = UIRefreshControl()
        self.refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        self.collectionView.addSubview(refresher)
    }
    
    
    @objc func loadData() {
        fetchBiddingItems()
        if loggedInUser != nil {
            fetchAllStories()
        }
        
        refresher.endRefreshing()
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCartItems()
        fetchBiddingItems()

        if isForSingleItem {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
                self.tabBarController?.tabBar.frame.origin.y = UIScreen.main.bounds.size.height
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isForSingleItem {
            if let tabBarFrame = self.tabBarController?.tabBar.frame {
                UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
                    self.tabBarController?.tabBar.frame.origin.y = UIScreen.main.bounds.size.height - tabBarFrame.height
                })
            }
        }
    }
    //MARK: - Selectors
    @objc func dismissPicker() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.blackView.alpha = 0
            self.addBidView?.frame.origin.y = self.view.frame.height
            self.forwardPicker?.frame.origin.y = self.view.frame.height
        }, completion: { (_) in
            self.blackView.removeFromSuperview()
            self.addBidView?.removeFromSuperview()
            self.addBidView = nil
            self.forwardPicker?.removeFromSuperview()
            self.forwardPicker = nil
        })
    }
    
    @objc func handleCart() {
        if loggedInUser == nil {
            appDele!.loginAlert(con: self)
            return
        }
        let controller = UINavigationController(rootViewController: CartController(collectionViewLayout: UICollectionViewFlowLayout()))
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
    @objc func handleNotification() {
        if loggedInUser == nil {
            appDele!.loginAlert(con: self)
            return
        }
        let controller = UINavigationController(rootViewController: NotificationContainer())
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
    @objc func handleMessages() {
        if loggedInUser == nil {
            appDele!.loginAlert(con: self)
            return
        }
        let controller = UINavigationController(rootViewController: ChatListViewController())
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .coverVertical
        present(controller, animated: true, completion: nil)
    }
    
    //MARK: - API
    func fetchBiddingItems() {
        Service.shared.fetchAllBiddingPost { items, status, message in
            if status {
                guard let arrData = items else { return }
                var arrTmp : [BidItem ] = []
                for item in arrData {
                    arrTmp.append(item)
                    if item.arrPurchaseBy.count > 0 {
                        for objUser in item.arrPurchaseBy {
                            var objToAdd = item
                            objToAdd.purchasedBy = objUser
                            arrTmp.append(objToAdd)
                        }
                    }
                }
                self.allBidItems = arrTmp
            } else {
                
            }
        }
    }
    
    func fetchAllStories() {
        Service.shared.fetchRecentLiveSellers { status, allUsers, message in
            if status {
                guard let allUsers = allUsers else {
                    return
                }
                self.isStoriesAvailable = allUsers.count > 0 ? true : false
                self.allStoriesItems = allUsers
            }
        }
    }
    
    //MARK: - Helper Functions
    func configureUI() {
        collectionView.backgroundColor = .backgroundWhiteColor
        
        
        
        if isForSingleItem {
            self.navigationItem.title = appDele!.isForArabic ? Detail_ar : Detail_en
        } else {
            let headerImage: UIImage = #imageLiteral(resourceName: "zeed_logo")
            let headerImageView = UIImageView()
            headerImageView.anchor(width: view.frame.width * 0.085)
            headerImageView.contentMode = .scaleAspectFit
            headerImageView.image = headerImage
            self.navigationItem.titleView = headerImageView
            
            
            navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: notificationButton)]
            navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: messageButton), UIBarButtonItem(customView: cartButton)]
        }
        
        
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        
        view.addSubview(noPostsAvailableLabel)
        view.addSubview(followNowButton)
        noPostsAvailableLabel.centerY(inView: collectionView)
        noPostsAvailableLabel.centerX(inView: collectionView)
        
        followNowButton.centerY(inView: collectionView, constant: 40)
        followNowButton.centerX(inView: collectionView)
        
        
        
        if appDele!.isForArabic == true {
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
extension BiddingController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allBidItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if !isForSingleItem && isStoriesAvailable {
            //declare header
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BiddingStories.reuseIdentifier, for: indexPath) as! BiddingStories
            
            header.allStories = allStoriesItems
            //set delegate
            header.delegate = self
            //set global from header
            biddingStoriesModel = header
            // return header
            return header
        } else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BiddingCell.reuseIdentifier, for: indexPath) as! BiddingCell
        cell.delegate = self
        cell.item = allBidItems[indexPath.row]
        return cell
    }
}

//MARK: - Delegate UICollectionViewDelegate
extension BiddingController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return (isForSingleItem || !isStoriesAvailable) ? CGSize(width: collectionView.frame.width, height: 0) : CGSize(width: collectionView.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (7 + 65 + 6 + 15 + 6 + 40 + 6 + 50 + 6 + 20 + 7)
        return CGSize(width: view.frame.width, height: view.frame.width + CGFloat(height))
    }
}

//MARK: - Delegate HomeStoriesDelegate
extension BiddingController: BiddingStoriesDelegate {
    func presentStory(forUser user: User) {
        if user.liveDetails.isPurchased {
            if user.liveDetails.isLive {
                guard let item = allBidItems.first(where: {$0.id == user.liveDetails.postId}) else { return }
                let nav = UINavigationController(rootViewController: BiddingLiveController(forItem: item, isAllowedToBid: true))
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            } else {
                guard let item = allBidItems.first(where: {$0.id == user.liveDetails.postId}) else { return }
                let nav = UINavigationController(rootViewController: BiddingOldLiveController(forItem: item, ofSeller: user))
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "", message: appDele!.isForArabic ? You_have_not_registered_to_participate_in_this_auction_Please_register_to_participate_in_the_auction_by_tapping_on_the_post_ar : You_have_not_registered_to_participate_in_this_auction_Please_register_to_participate_in_the_auction_by_tapping_on_the_post_en, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: appDele!.isForArabic ? Pay_ar : Pay_en, style: .default, handler: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    guard let item = self.allBidItems.first(where: {$0.id == user.liveDetails.postId}) else { return }
                    self.navigationController?.pushViewController(BiddingPayController(forBidItem: item), animated: true)
                }
            }))
            alert.addAction(UIAlertAction(title: appDele!.isForArabic ? Cancel_ar : Cancel_en, style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func presentStory1(forUser user: User) {
        
        if let videoURL = URL(string: user.liveDetails.recording) {
            let player = AVPlayer(url: videoURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        } else {
            self.showAlert(withMsg: "Video will available soon.")
        }
        return
        //        guard let item = allBidItems.first(where: {$0.id == user.liveDetails.postId}) else { return }
        //        let nav = UINavigationController(rootViewController: BiddingLiveController(forItem: item, isAllowedToBid: true))
        //        nav.modalPresentationStyle = .fullScreen
        //        self.present(nav, animated: true, completion: nil)
        //        return
        
        //        if user.liveDetails.isPurchased {
        //            if user.liveDetails.isLive {
        //                guard let item = allBidItems.first(where: {$0.id == user.liveDetails.postId}) else { return }
        //                let nav = UINavigationController(rootViewController: BiddingLiveController(forItem: item, isAllowedToBid: true))
        //                nav.modalPresentationStyle = .fullScreen
        //                self.present(nav, animated: true, completion: nil)
        //            } else {
        //                guard let item = allBidItems.first(where: {$0.id == user.liveDetails.postId}) else { return }
        //                let nav = UINavigationController(rootViewController: BiddingOldLiveController(forItem: item, ofSeller: user))
        //                nav.modalPresentationStyle = .fullScreen
        //                self.present(nav, animated: true, completion: nil)
        //            }
        //        } else {
        //            let alert = UIAlertController(title: "", message: appDele!.isForArabic ? You_have_not_registered_to_participate_in_this_auction_Please_register_to_participate_in_the_auction_by_tapping_on_the_post_ar : You_have_not_registered_to_participate_in_this_auction_Please_register_to_participate_in_the_auction_by_tapping_on_the_post_en, preferredStyle: .alert)
        //            alert.addAction(UIAlertAction(title: appDele!.isForArabic ? Pay_ar : Pay_en, style: .default, handler: { _ in
        //                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        //                    guard let item = self.allBidItems.first(where: {$0.id == user.liveDetails.postId}) else { return }
        //                    self.navigationController?.pushViewController(BiddingPayController(forBidItem: item), animated: true)
        //                }
        //            }))
        //            alert.addAction(UIAlertAction(title: appDele!.isForArabic ? Cancel_ar : Cancel_en, style: .default))
        //            self.present(alert, animated: true, completion: nil)
        //        }
    }
    
    
    
    func presentLive(controller: BiddingLiveController, animated: Bool) {
        
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    func presentStory(controller: BiddingStoryController, animated: Bool) {
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
}

extension BiddingController: BiddingCellDelegate {
    func openDetailView(for cell: BiddingCell) {
        if loggedInUser == nil {
            appDele!.loginAlert(con: self)
            return
        }
        guard let item = cell.item else { return }
        switch item.postBaseType {
        case .normalSelling:
            break
        case .normalBidding:
            if item.owner.id == loggedInUser?.id {
                navigationController?.pushViewController(SingleBiddingController(forBidItem: item), animated: true)
            } else {
                if item.hasPaidRegistrationPrice {
                    navigationController?.pushViewController(SingleBiddingController(forBidItem: item), animated: true)
                } else {
                    navigationController?.pushViewController(BiddingPayController(forBidItem: item), animated: true)
                }
            }
        case .liveBidding:
            break
        }
    }
    
    func handleWatchLiveTapped(for cell: BiddingCell) {
        
    }
    
    func handleWatchLiveTappedhandleWatchLiveTapped(for cell: BiddingCell) {
        if loggedInUser == nil {
            appDele!.loginAlert(con: self)
            return
        }
        guard let item = cell.item else { return }
        if item.owner.id == loggedInUser?.id {
            let nav = UINavigationController(rootViewController: BiddingLiveController(forItem: item, isAllowedToBid: true))
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        } else {
            let nav = UINavigationController(rootViewController: BiddingLiveController(forItem: item, isAllowedToBid: true))
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
            return
            //            if item.hasPaidRegistrationPrice {
            //                let nav = UINavigationController(rootViewController: BiddingLiveController(forItem: item, isAllowedToBid: true))
            //                nav.modalPresentationStyle = .fullScreen
            //                self.present(nav, animated: true, completion: nil)
            //            } else {
            //                let obj = BiddingPayController(forBidItem: item)
            //                navigationController?.pushViewController(obj, animated: true)
            //            }
        }
    }
    
    func handleUsernameTapped(for cell: BiddingCell) {
        if loggedInUser == nil {
            appDele!.loginAlert(con: self)
            return
        }
        guard let item = cell.item else { return }
        //        let controller = UserProfileController(forUserId: item.owner.id)
        let obj = OtherProfileVC()
        obj.userId = item.owner.id
        navigationController?.pushViewController(obj, animated: true)
    }
    
    func getPostItem(objBid : BidItem) -> PostItem {
        var objPost = PostItem(dict: [:])
        objPost.id = objBid.id
        objPost.title = objBid.title
        objPost.title_ar = objBid.title_ar
        objPost.about = objBid.about
        objPost.type = objBid.type
        objPost.postBaseType = objBid.postBaseType
        objPost.price = objBid.initialPrice
        objPost.category = objBid.category
        objPost.subCategory = objBid.subCategory
        objPost.medias = objBid.medias
        return objPost
    }
    
    func handleOptionsTapped(for cell: BiddingCell) {
        guard let post = cell.item else { return }
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if post.owner.id == AppUser.shared.getDefaultUser()?.id {
            alert.addAction(UIAlertAction(title: appDele!.isForArabic ? Edit_ar : Edit_en, style: .default, handler: { _ in
                let obj = CreateController()
                obj.postItem = self.getPostItem(objBid: post)
                self.navigationController?.pushViewController(obj, animated: true)
            }))
            
            alert.addAction(UIAlertAction(title: appDele!.isForArabic ? Inactive_ar : Inactive_en, style: .default, handler: { _ in
                Service.shared.updatePostActiveStatus(forPostId: post.id, status: false) { status, massge in
                    self.showAlert(withMsg: "Post inactivated successfully.")
                }
            }))
            
            //            alert.addAction(UIAlertAction(title: appDele!.isForArabic ? Delete_ar : Delete_en, style: .default, handler: { _ in
            //                Service.shared.deletePost(forPostId:post.id) { status, massge in
            //                    self.showAlert(withMsg: "Post deleted successfully.")
            //                    self.navigationController?.popViewController(animated: true)
            //                }
            //            }))
        } else {
            if post.isReported {
                alert.addAction(UIAlertAction(title: appDele!.isForArabic ? Reported_ar : Reported_en, style: .destructive, handler: { (action) in
                    self.showAlert(withMsg: "Post Already Reported!")
                }))
            } else {
                alert.addAction(UIAlertAction(title: appDele!.isForArabic ? Report_ar : Report_en, style: .destructive, handler: { (action) in
                    if loggedInUser == nil {
                        appDele!.loginAlert(con: self)
                        return
                    }
                    Service.shared.reportPost(withId: post.id) { status in
                        if status {
                            self.showAlert(withMsg: "Post Reported!")
                            self.allBidItems[self.collectionView.indexPath(for: cell)!.row].isReported = true
                        } else {
                            self.showAlert(withMsg: "Failed to Report Post!")
                        }
                    }
                }))
            }
            
            
            alert.addAction(UIAlertAction(title: "\(appDele!.isForArabic ? Unfollow_ar : Unfollow_en) \(post.owner.userName)", style: .default, handler: { _ in
                if loggedInUser == nil {
                    appDele!.loginAlert(con: self)
                    return
                }
                Service.shared.performAction(ofType: .unfollow, onUser: post.owner) { status in
                    if status {
                        self.showAlert(withMsg: "Unfollowed \(post.owner.userName) successfully!")
                    } else {
                        self.showAlert(withMsg: "Unfollowed \(post.owner.userName) failed!")
                    }
                }
            }))
            
            alert.addAction(UIAlertAction(title: appDele!.isForArabic ? Message_ar : Message_en, style: .default, handler: { _ in
                if loggedInUser == nil {
                    appDele!.loginAlert(con: self)
                    return
                }
                self.showAlert(withMsg: "handle MessageTapped")
            }))
        }
        
        alert.addAction(UIAlertAction(title: appDele!.isForArabic ? Share_ar : Share_en, style: .default, handler: { (action) in
            guard let image = post.medias.first?.url else { return }
            let text = "Hey, check out this \(post.title) at Zeed! \n\(post.about)"
            let link = URL(string: "zeed://post=\(post.id)")!
            let shareAll = [text, image, link] as [Any]
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: appDele!.isForArabic ? Cancel_ar : Cancel_en, style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func handleLikeTapped(for cell: BiddingCell) {
        if loggedInUser == nil {
            appDele!.loginAlert(con: self)
            return
        }
        //        guard let item = cell.item else { return }
        //        if cell.likeButton.isSelected {
        //            Service.shared.dislikePost(withPostId: item.id) { (status) in
        //                if status {
        //                    cell.likeButton.isSelected = false
        //
        //                }
        //            }
        //        } else {
        //            Service.shared.likePost(withPostId: item.id) { (status) in
        //                if status {
        //                    cell.likeButton.isSelected = true
        //                }
        //            }
        //        }
        
        guard let post = cell.item else { return }
        guard let indexPath = self.collectionView.indexPath(for: cell) else {
            return
        }
        if cell.likeButton.isSelected {
            Service.shared.dislikePost(withPostId: post.id) { (status) in
                if status {
                    cell.likeButton.isSelected = false
                    cell.item?.isLiked = false
                    self.allBidItems[indexPath.item].isLiked = false
                    self.allBidItems[indexPath.item].likeCount = self.allBidItems[indexPath.item].likeCount - 1
                }
            }
        } else {
            Service.shared.likePost(withPostId: post.id) { (status) in
                if status {
                    cell.likeButton.isSelected = true
                    cell.item?.isLiked = true
                    self.allBidItems[indexPath.item].isLiked = true
                    self.allBidItems[indexPath.item].likeCount = self.allBidItems[indexPath.item].likeCount + 1
                }
            }
        }
        
        
    }
    
    func handleCommentTapped(for cell: BiddingCell) {
        if loggedInUser == nil {
            appDele!.loginAlert(con: self)
            return
        }
        guard let item = cell.item else { return }
        let commentControler = CommentController(forPostWithId: item.id)
        navigationController?.pushViewController(commentControler, animated: true)
    }
    
    func handleMessageTapped(for cell: BiddingCell) {
        
        if loggedInUser == nil {
            appDele!.loginAlert(con: self)
            return
        }
        
        guard let item = cell.item else { return }
        
        forwardPicker = ForwardMessagePicker(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 340))
        guard let forwardPicker = forwardPicker else { return }
        
        forwardPicker.delegate = self
        //        forwardPicker.post = item
        
        bringBlackView()
        
        UIApplication.shared.keyWindow!.addSubview(forwardPicker)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.blackView.alpha = 1
            let leftoverSpace = UIScreen.main.bounds.height - 340
            self.forwardPicker?.frame.origin.y = leftoverSpace
        })
        
        
        
        
        //        if loggedInUser == nil {
        //            appDele!.loginAlert(con: self)
        //            return
        //        }
        //        let controller = UINavigationController(rootViewController: ChatViewController())
        //        controller.modalPresentationStyle = .fullScreen
        //        controller.modalTransitionStyle = .coverVertical
        //
        //        present(controller, animated: true, completion: nil)
    }
    
    func handleBidTapped(for cell: BiddingCell) {
        if loggedInUser == nil {
            appDele!.loginAlert(con: self)
            return
        }
        guard let item = cell.item else { return }
        if item.status == .upcoming && item.owner.id != loggedInUser?.id {
            let alert = UIAlertController(title: "", message: appDele!.isForArabic ? Auction_for_this_post_has_not_started_yet_You_will_be_notified_when_auction_has_started_ar : Auction_for_this_post_has_not_started_yet_You_will_be_notified_when_auction_has_started_en , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: appDele!.isForArabic ? Ok_ar : Ok_en, style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            switch item.postBaseType {
            case .normalSelling:
                break
            case .normalBidding:
                if item.owner.id == loggedInUser?.id {
                    navigationController?.pushViewController(SingleBiddingController(forBidItem: item), animated: true)
                } else {
                    if item.hasPaidRegistrationPrice {
                        navigationController?.pushViewController(SingleBiddingController(forBidItem: item), animated: true)
                    } else {
                        navigationController?.pushViewController(BiddingPayController(forBidItem: item), animated: true)
                    }
                }
            case .liveBidding:
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
            }
        }
    }
}

extension BiddingController: BiddingCellAddBidViewDelegate {
    func addBidView(_ addBidView: BiddingCellAddBidView, didBidWithAmount amount: Double, forItem item: BidItem) {
        if loggedInUser == nil {
            appDele!.loginAlert(con: self)
            return
        }
        let controller = BiddingPayController(forBidItem: item)
        navigationController?.pushViewController(controller, animated: true)
        dismissPicker()
    }
}


extension BiddingController : ForwardMessagePickerDelegate {
    func forwardMessagePicker(_ forwardMessagePicker: ForwardMessagePicker, didSelectUser user: User, at indexPath: IndexPath) {
        dismissPicker()
        SocketService.shared.sharePost(toUser: user.id, postId: forwardMessagePicker.post?.id ?? "")
    }
}
