//
//  HomeController.swift
//  Zeed
//
//  Created by Shrey Gupta on 28/02/21.
//

import UIKit
import JGProgressHUD

class HomeController: UIViewController {
    //MARK: - Properties
    var blackView = UIView()
    var forwardPicker: ForwardMessagePicker!
    
    var hud = JGProgressHUD(style: .dark)
    
    var collectionView: UICollectionView
    
    var showFullItemIndexes = [IndexPath]()
    
    var post: PostItem?



    var arrForPostListMain = [PostItem]() {
        didSet {
            var arrTmp : [PostItem ] = []
            for item in arrForPostListMain {
                arrTmp.append(item)
                if item.arrPurchaseBy.count > 0 {
                    for objUser in item.arrPurchaseBy {
                        var objToAdd = item
                        objToAdd.purchasedBy = objUser
                        arrTmp.append(objToAdd)
                    }
                }
            }
            self.allPosts = arrTmp
        }
    }

    var allPosts = [PostItem]() {
        didSet {
            if allPosts.count == 0 {
                followNowButton.alpha = 1
                noPostsAvailableLabel.alpha = 1
            } else {
                followNowButton.alpha = 0
                noPostsAvailableLabel.alpha = 0
            }
            collectionView.reloadData()
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
        bagButton.addTarget(self, action: #selector(handleCart), for: .touchUpInside)
        bagButton.badge = itemvalue
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
        button.tintColor = .appPrimaryColor
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
    
    private let noPostsAvailableLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? No_posts_available_ar : No_posts_available_en
        label.textColor = .appPrimaryColor
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    
    private lazy var followNowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(appDele!.isForArabic ? follow_users_ar : follow_users_en, for: .normal)
        button.setDimensions(height: 30, width: 130)
        button.setBorder(colour: "007DA5", alpha: 1, radius: 15, borderWidth: 1)
        button.addTarget(self, action: #selector(followNowButtonClick), for: .touchUpInside)
        button.tintColor = .appPrimaryColor
        return button
    }()

    
    //MARK: - Lifecycle
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(nibName: nil, bundle: nil)
        
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.reuseIdentifier)
        collectionView.register(FeedExpandedCell.self, forCellWithReuseIdentifier: FeedExpandedCell.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        fetchAllPosts()
                
        Utility.openScreenView(str_screen_name: "HomePage", str_nib_name: self.nibName ?? "")

        collectionView.dataSource = self
        collectionView.delegate = self
        
        configureNavigationBar(largeTitleColor: .appPrimaryColor, backgoundColor: .appBackgroundColor, tintColor: .appPrimaryColor, title: "", preferredLargeTitle: false)
        
        configureUI()
    
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        collectionView.addSubview(refreshControl) // not required when using UITableViewController
                
        fetchAllPosts()
                
    }

    override func viewWillAppear(_ animated: Bool) {
        fetchCartItems()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        fetchAllPosts()
    }

    
    
    //MARK: - Selectors
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
    
    @objc func followNowButtonClick() {
        if loggedInUser == nil {
            appDele!.loginAlert(con: self)
            return
        }
        appDele?.isForSearch = true
        let tabController = appDele?.window?.rootViewController as? TabBarController
        tabController?.selectedIndex = 1
    }

    @objc func handleMessages() {
        if loggedInUser == nil {
            appDele!.loginAlert(con: self)
            return
        }
//        let controller = UINavigationController(rootViewController: MessagesContainer())
        let controller = UINavigationController(rootViewController: ChatListViewController())
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .coverVertical
        present(controller, animated: true, completion: nil)
    }
    
    @objc func dismissPicker() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.blackView.alpha = 0
            self.forwardPicker?.frame.origin.y = self.view.frame.height
        }, completion: { (_) in
            self.blackView.removeFromSuperview()
            self.forwardPicker?.removeFromSuperview()
            self.forwardPicker = nil
        })
    }
    
    //MARK: - API
    func fetchAllPosts() {
        hud.show(in: self.view, animated: true)
        Service.shared.fetchAllPost(type:"normalSelling") { (allPosts, status, message) in
            self.refreshControl.endRefreshing()
            if status {
                guard let allPosts = allPosts else { return }
                self.arrForPostListMain = allPosts
            } else {
                guard let message = message else { return }
                self.showAlert(withMsg: message)
            }
            self.hud.dismiss(animated: true)
        }
    }
    
    //MARK: - Helper Functions
    func configureUI() {
        view.backgroundColor = .backgroundWhiteColor
        
        let headerImage: UIImage = #imageLiteral(resourceName: "zeed_logo")
        let headerImageView = UIImageView()
        headerImageView.anchor(width: view.frame.width * 0.075)
        headerImageView.contentMode = .scaleAspectFit
        headerImageView.image = headerImage
        self.navigationItem.titleView = headerImageView
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: notificationButton)]
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: messageButton), UIBarButtonItem(customView: cartButton)]
        
        collectionView.backgroundColor = .appBackgroundColor
        
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
        
//        noPostsAvailableLabel.alpha = 0
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
}

//MARK: - DataSource UICollectionViewDataSource
extension HomeController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if showFullItemIndexes.contains(indexPath) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedExpandedCell.reuseIdentifier, for: indexPath) as! FeedExpandedCell
            cell.delegate = self
            cell.post = self.allPosts[indexPath.row]
            cell.index = indexPath
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.reuseIdentifier, for: indexPath) as! FeedCell
        cell.post = allPosts[indexPath.row]
        cell.delegate = self
        cell.index = indexPath
        return cell
    }
}

//MARK: - Delegate UICollectionViewDelegate
extension HomeController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (7 + 80 + 6 + 10 + 6 + 27 + 6 + 50 + 6 + 20 + 7)
        
        if showFullItemIndexes.contains(indexPath) {
            return CGSize(width: view.frame.width, height: view.frame.width + CGFloat(height) - 20 + 6 + 75 + 6 + 25 + 6 + (15 + (73 * 2)) + 6 + 63 + 20)
        }
        return CGSize(width: view.frame.width, height: view.frame.width + CGFloat(height))
    }
}

//MARK: - Delegate FeedCellDelegate
extension HomeController: FeedCellDelegate {
    func handleDidUpdateVariationSelected(withAttributes: ItemVariant, fromCell: FeedExpandedCell, index: Int) {
        
    }
    
    func handleStoreUserName(for cell: FeedCell) {
        guard let post = cell.post else { return }
//        let controller = UserProfileController(forUserId: post.owner.id)
        let obj = OtherProfileVC()
        obj.userId = post.owner.id
        navigationController?.pushViewController(obj, animated: true)
    }
    
    func handleDidUpdateVariation(withAttributes: [ItemAttribute], fromCell: FeedExpandedCell) {
///        handled in SinglePostController
    }
    
    func handleUsernameTapped(for cell: FeedCell) {
        guard let post = cell.post else { return }
//        let controller = UserProfileController(forUserId: post.purchasedBy.id == "" ? post.owner.id : post.purchasedBy.id)
        let obj = OtherProfileVC()
        obj.userId = post.purchasedBy.id == "" ? post.owner.id : post.purchasedBy.id
        navigationController?.pushViewController(obj, animated: true)
    }
    
    func handleOptionsTapped(for cell: FeedCell) {
        guard let post = cell.post else { return }
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if post.owner.id == AppUser.shared.getDefaultUser()?.id {
            alert.addAction(UIAlertAction(title: cell.post?.isActive == true ? (appDele!.isForArabic ? Inactive_ar : Inactive_en) : (appDele!.isForArabic ? Active_ar : Active_en), style: .default, handler: { _ in
                Service.shared.updatePostActiveStatus(forPostId: post.id, status: false) { status, massge in
                    if cell.post?.isActive == true {
                        cell.post?.isActive = false
                        self.showAlert(withMsg: appDele!.isForArabic ? Post_details_updated_successfully_en : Post_details_updated_successfully_en)
                    } else {
                        cell.post?.isActive = true
                        self.showAlert(withMsg: appDele!.isForArabic ? Post_details_updated_successfully_en : Post_details_updated_successfully_en)
                    }
                }
            }))
            
//            alert.addAction(UIAlertAction(title: appDele!.isForArabic ? Delete_ar : Delete_en, style: .default, handler: { _ in
//                Service.shared.deletePost(forPostId:post.id) { status, massge in
//                    if cell.post?.isActive == true {
//                        cell.post?.isActive = false
//                        self.showAlert(withMsg: "Post deleted successfully.")
//                        if let index = self.allPosts.firstIndex(where: {
//                            $0.id == post.id
//                        }) {
//                            self.allPosts.remove(at: index)
//                            self.collectionView.reloadData()
//                        }
//                    }
//                }
//            }))
        } else {
            if post.isReported {
                alert.addAction(UIAlertAction(title: appDele!.isForArabic ? Reported_ar : Reported_en, style: .destructive, handler: { (action) in
                    if loggedInUser == nil {
                        appDele!.loginAlert(con: self)
                        return
                    }
                    self.showAlert(withMsg: appDele!.isForArabic ?  You_have_already_reported_this_post_ar : You_have_already_reported_this_post_en)
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
                            self.allPosts[self.collectionView.indexPath(for: cell)!.row].isReported = true
                        } else {
                            self.showAlert(withMsg: appDele!.isForArabic ? Something_went_wrong_Please_check_your_internet_connection_and_retry_ar : Something_went_wrong_Please_check_your_internet_connection_and_retry_en)
                        }
                    }
                }))
            }
            
            
            alert.addAction(UIAlertAction(title: "\(post.owner.followStatus ? appDele!.isForArabic ? Unfollow_ar : Unfollow_en : appDele!.isForArabic ? Follow_ar : Follow_en) \(post.owner.userName)", style: .default, handler: { _ in
                if loggedInUser == nil {
                    appDele!.loginAlert(con: self)
                    return
                }
                Service.shared.performAction(ofType: post.owner.followStatus ? .unfollow : .follow , onUser: post.owner) { status in
                    if status {
                        if post.owner.followStatus {
                            self.allPosts[cell.index?.item ?? 0].owner.followStatus = false
                            cell.post?.owner.followStatus = false
                            self.showAlert(withMsg: "\(appDele!.isForArabic ? Unfollow_ar : Unfollow_en) \(post.owner.userName) successfully!")
                        } else {
                            self.allPosts[cell.index?.item ?? 0].owner.followStatus = true
                            cell.post?.owner.followStatus = true
                            self.showAlert(withMsg: "\(appDele!.isForArabic ? Follow_ar : Follow_en) \(post.owner.userName) successfully!")
                        }
                        self.collectionView.reloadData()
                    } else {
                        self.showAlert(withMsg: "Unfollowed \(post.owner.userName) failed!")
                    }
                }
            }))
        }

        if post.owner.id != AppUser.shared.getDefaultUser()?.id {
            alert.addAction(UIAlertAction(title: appDele!.isForArabic ? Message_ar : Message_en, style: .default, handler: { _ in
//                self.openForwardPicker(post)
                if loggedInUser == nil {
                    appDele!.loginAlert(con: self)
                    return
                }
                let objUser = UserObject()
                objUser.username = cell.post?.owner.userName
                objUser.id = cell.post?.owner.id
                objUser.objImage = UploadImageObject()
                objUser.objImage.url = cell.post?.owner.image.url

                let obj = ChatListViewController()
                obj.isForChatUser = true
                obj.user = objUser

                let controller = UINavigationController(rootViewController: obj)
                controller.modalPresentationStyle = .fullScreen
                controller.modalTransitionStyle = .coverVertical
                self.present(controller, animated: false, completion: nil)

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
    
    func handleImageSingleTap(for cell: FeedCell) {
        guard let post = cell.post else { return }
        let controller = SinglePostController(forPost: post, isForSingleItem: false)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func handleLikeTapped(for cell: FeedCell) {
        if loggedInUser == nil {
            appDele!.loginAlert(con: self)
            return
        }
        guard let post = cell.post else { return }
        guard let indexPath = self.collectionView.indexPath(for: cell) else {
            return
        }
        if cell.likeButton.isSelected {
            Service.shared.dislikePost(withPostId: post.id) { (status) in
                if status {
                    cell.likeButton.isSelected = false
                    cell.post?.isLiked = false
                    self.allPosts[indexPath.item].isLiked = false
                    self.allPosts[indexPath.item].likeCount = self.allPosts[indexPath.item].likeCount - 1
                }
            }
        } else {
            Service.shared.likePost(withPostId: post.id) { (status) in
                if status {
                    cell.likeButton.isSelected = true
                    cell.post?.isLiked = true
                    self.allPosts[indexPath.item].isLiked = true
                    self.allPosts[indexPath.item].likeCount = self.allPosts[indexPath.item].likeCount + 1
                }
            }
        }
    }
    
    func handleCommentTapped(for cell: FeedCell) {
        if loggedInUser == nil {
            appDele!.loginAlert(con: self)
            return
        }
        guard let post = cell.post else { return }
        let commentControler = CommentController(forPostWithId: post.id)
        navigationController?.pushViewController(commentControler, animated: true)
    }
    
    func handleMessageTapped(for cell: FeedCell) {
        if loggedInUser == nil {
            appDele!.loginAlert(con: self)
            return
        }
        guard let post = cell.post else { return }
        self.openForwardPicker(post)
    }
    
    func openForwardPicker(_ post : PostItem) {
        if loggedInUser == nil {
            appDele!.loginAlert(con: self)
            return
        }

        forwardPicker = ForwardMessagePicker(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 340))
        guard let forwardPicker = forwardPicker else { return }
        
        forwardPicker.delegate = self
        forwardPicker.post = post
        
        bringBlackView()
        
        UIApplication.shared.keyWindow!.addSubview(forwardPicker)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.blackView.alpha = 1
            let leftoverSpace = UIScreen.main.bounds.height - 340
            self.forwardPicker?.frame.origin.y = leftoverSpace
        })
    }
    
    func handleAddToCartTapped(for cell: FeedCell, withVariant variantView: FeedExpandedVarientView?) {
        if loggedInUser == nil {
            appDele!.loginAlert(con: self)
            return
        }
        guard let post = cell.post else { return }
        if post.variants.count != 0 {
            let controller = SinglePostController(forPost: post, isForSingleItem: false)
            navigationController?.pushViewController(controller, animated: true)
        } else {
            Service.shared.addToCart(post: post, quantity: 1) { (status, message) in
                self.hud.dismiss(animated: true)
                if status {
                    self.showAlert(withMsg: appDele!.isForArabic ? Item_added_to_cart_ar : Item_added_to_cart_en)
                    self.fetchCartItems()
                    Utility.addToCartProduct(productId: post.id, productName: post.title, productPrice: post.price, productVariantId: "", productVariantName: "")
                } else {
                    guard let message = message else { return }
//                    self.showAlert(withMsg: "Error: \(message)")
                }
            }
        }
    }
    
    func handleBuyTapped(for cell: FeedCell, withVariant variantView: FeedExpandedVarientView?) {
        if loggedInUser == nil {
            appDele!.loginAlert(con: self)
            return
        }
        guard let post = cell.post else { return }

        if loggedInUser?.id ?? "" == post.owner.id {
            Utility.showISMessage(str_title: appDele!.isForArabic ? You_cannot_purchase_your_own_product_ar : You_cannot_purchase_your_own_product_en, Message: "", msgtype: .warning)
            return
        }

        
        if post.variants.count != 0 {
            let controller = SinglePostController(forPost: post, isForSingleItem: false)
            navigationController?.pushViewController(controller, animated: true)
        } else {
            if post.quantity < 1 {
                self.showAlert(withMsg: appDele!.isForArabic ? Item_out_of_stock_ar : Item_out_of_stock_en)
                return
            }

            let controller = CartCheckoutController(forCartItems: [])
            controller.variantId = ""
            controller.postId = post.id
            controller.productDirectBuyAmount = "\(post.price)"
            controller.isDirectBuy = true
            controller.intDirectBuyQty = 1
            navigationController?.pushViewController(controller, animated: true)
//
//            Service.shared.addToCart(post: post, quantity: 1) { (status, message) in
//                self.hud.dismiss(animated: true)
//                if status {
//                    self.showAlert(withMsg: "Added Successfully!")
//                } else {
//                    guard let message = message else { return }
//                    self.showAlert(withMsg: "Error: \(message)")
//                }
//            }
            print("DEBUG:- handle direct checkout")
//            let controller = CartCheckoutController(forCartItems: <#[CartItem]#>)
//            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension HomeController: ForwardMessagePickerDelegate {
    func forwardMessagePicker(_ forwardMessagePicker: ForwardMessagePicker, didSelectUser user: User, at indexPath: IndexPath) {
        dismissPicker()
        SocketService.shared.sharePost(toUser: user.id, postId: forwardMessagePicker.post?.id ?? "")
            //        Utility.showISMessage(str_title: "To be fixed", Message: "handle forwared to \(user.userName)", msgtype: .warning)
    }
}
