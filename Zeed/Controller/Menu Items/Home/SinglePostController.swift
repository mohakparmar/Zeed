//
//  SinglePostController.swift
//  Zeed
//
//  Created by Shrey Gupta on 17/04/21.
//

import UIKit
import JGProgressHUD

class SinglePostController: UIViewController {
    //MARK: - Properties
    
    var blackView = UIView()
    var forwardPicker: ForwardMessagePicker!
    
    var hud = JGProgressHUD(style: .dark)
    
    var collectionView: UICollectionView
    
    var post: PostItem
    let isForSingleItem: Bool
    var isForDetail : Bool = false
    
    //MARK: - API
    func getSinglePost() {
        Service.shared.fetchPostDetailNormal(postId: post.id, userId: "") { items, status, message in
            if status {
                guard let items = items else { return }
                if items.count > 0 {
                    self.post = items[0]
                    self.areVariantsAvailable = self.post.variants.count > 0
                    self.collectionView.reloadData()
                }
            }
        }
        
        
        //        Service.shared.fetchAllPost(postId:post.id) { (allPosts, status, message) in
        //            if status {
        //                guard let allPosts = allPosts else { return }
        ////                if allPosts.count > 0 {
        ////                    self.post = allPosts[0]
        ////                }
        //            } else {
        ////                guard let message = message else { return }
        ////                self.showAlert(withMsg: message)
        //            }
        //            self.hud.dismiss(animated: true)
        //        }
    }
    
    
    lazy var postAttributes: [ItemAttribute] = post.attributes {
        didSet {
            post.attributes = postAttributes
            validateAttributes()
        }
    }
    
    var selectedVariant: ItemVariant? {
        didSet {
            if let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? FeedExpandedCell {
                cell.selectedVariant = selectedVariant
            }
        }
    }
    
    var isVariantSelected: Bool = false
    lazy var areVariantsAvailable: Bool = post.variants.count > 0
    var ref = UIRefreshControl()
    
    //MARK: - UI Elements
    
    //MARK: - Lifecycle
    init(forPost post: PostItem, isForSingleItem: Bool) {
        self.post = post
        self.isForSingleItem = isForSingleItem
        
        Service.shared.fetchSinglePost(forPostId: post.id) { _, _, _ in }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(nibName: nil, bundle: nil)
        
        collectionView.register(FeedExpandedCell.self, forCellWithReuseIdentifier: FeedExpandedCell.reuseIdentifier)
        
    }
    
    
    @objc func refresh(_ sender: AnyObject) {
        self.getSinglePost()
        self.ref.endRefreshing()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = appDele!.isForArabic ? Detail_ar : Detail_en
        
        Utility.openScreenView(str_screen_name: "PostDetails", str_nib_name: self.nibName ?? "")

        collectionView.dataSource = self
        collectionView.delegate = self
        
        configureUI()
        
        ref.attributedTitle = NSAttributedString(string: "")
        ref.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        collectionView.addSubview(ref) // not required when using UITableViewController
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isForSingleItem {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
                self.tabBarController?.tabBar.frame.origin.y = UIScreen.main.bounds.size.height
            })
        }
        getSinglePost()
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
    @objc func handleCart() {
        let controller = UINavigationController(rootViewController: CartController(collectionViewLayout: UICollectionViewFlowLayout()))
        controller.modalPresentationStyle = .fullScreen
        
        present(controller, animated: true, completion: nil)
    }
    
    //MARK: - API
    
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
    
    func validateAttributes() {
        if checkIfAllAttributeSelected() {
            self.isVariantSelected = true
            self.selectedVariant =  checkVariantAvailbility()
            print("DEBUG:- SELECTED VARIANT QUANTITY: \(selectedVariant?.quantity)")
        }
    }
    
    func checkIfAllAttributeSelected() -> Bool {
        for postAttribute in postAttributes {
            guard postAttribute.selectedOption != nil else { return false }
        }
        return true
    }
    
    func checkVariantAvailbility() -> ItemVariant? {
        let availableVariants = post.variants
        
        for availableVariant in availableVariants {
            let availableVariantValueString = availableVariant.attributeValueString
            
            var selectedVariantValueArray = [String]()
            var selectedVariantValueString = String()
            
            for postAttribute in postAttributes {
                guard let selectedOption = postAttribute.selectedOption else { return nil }
                selectedVariantValueArray.append(selectedOption.id)
            }
            
            for index in 0 ..< selectedVariantValueArray.count {
                selectedVariantValueString += selectedVariantValueArray[index]
                
                if (index + 1) != selectedVariantValueArray.count {
                    selectedVariantValueString += ","
                }
            }
            
            
            var reversedSelectedVariantValueArray = selectedVariantValueString.split(separator: ",")
            reversedSelectedVariantValueArray.reverse()
            var reversedSelectedVariantValueString = String()
            
            for index in 0 ..< reversedSelectedVariantValueArray.count {
                reversedSelectedVariantValueString += reversedSelectedVariantValueArray[index]
                
                if (index + 1) != reversedSelectedVariantValueArray.count {
                    reversedSelectedVariantValueString += ","
                }
            }
            
            if (availableVariantValueString == selectedVariantValueString) == true || (availableVariantValueString == reversedSelectedVariantValueString) == true   {
                return availableVariant
            }
        }
        return nil
    }
}

//MARK: - DataSource UICollectionViewDataSource
extension SinglePostController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedExpandedCell.reuseIdentifier, for: indexPath) as! FeedExpandedCell
        //        cell.prepareForReuse()
        cell.areVariantsAvailable = areVariantsAvailable
        cell.delegate = self
        cell.post = post
        cell.selectedVariant = selectedVariant
        cell.isVariantSelected = isVariantSelected
        cell.commentReplyButton.isHidden = true
        
        cell.layoutIfNeeded()
        return cell
    }
}

//MARK: - Delegate UICollectionViewDelegate
extension SinglePostController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemDetailsHeight = 50
        //        let variantHeight = ((66 * CGFloat(post.attributes.count)))
        let heightSize = self.post.about.height(constraintedWidth: screenWidth - 150, font: UIFont.systemFont(ofSize: 14)) 
        print(heightSize)
        let variantHeight = 66
        let height = (7 + 80 + 6 + 10 + 6 + 27 + 6 + 50 + 6 + 20 + 7 + itemDetailsHeight)
        return CGSize(width: view.frame.width, height: view.frame.width + CGFloat(height) - 20 + 6 + 75 + 6 + 25 + 6 + CGFloat(height) + 6 + 63 + 20  + heightSize)
    }
}

//MARK: - Delegate FeedCellDelegate
extension SinglePostController: FeedCellDelegate {
    func handleDidUpdateVariationSelected(withAttributes: ItemVariant, fromCell: FeedExpandedCell, index: Int) {
        self.isVariantSelected = true
        self.selectedVariant =  withAttributes
    }
    
    func handleStoreUserName(for cell: FeedCell) {
        guard let post = cell.post else { return }
//        let controller = UserProfileController(forUserId: post.owner.id)
        let obj = OtherProfileVC()
        obj.userId = post.owner.id
        navigationController?.pushViewController(obj, animated: true)
    }
    
    func handleDidUpdateVariation(withAttributes: [ItemAttribute], fromCell: FeedExpandedCell) {
        postAttributes = withAttributes
        //        collectionView.reloadData()
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
            alert.addAction(UIAlertAction(title: appDele!.isForArabic ? Edit_ar : Edit_en, style: .default, handler: { _ in
                let obj = CreateController()
                obj.postItem = post
                self.navigationController?.pushViewController(obj, animated: true)
            }))
            
            alert.addAction(UIAlertAction(title: post.isActive ? appDele!.isForArabic ? Inactive_ar : Inactive_en : appDele!.isForArabic ? Active_ar : Active_en, style: .default, handler: { _ in
                Service.shared.updatePostActiveStatus(forPostId: post.id, status: post.isActive ? false : true) { status, massge in
                    self.showAlert(withMsg: appDele!.isForArabic ? Post_details_updated_successfully_ar : Post_details_updated_successfully_en)
                    cell.post?.isActive = post.isActive ? false : true
                }
            }))
            
//            alert.addAction(UIAlertAction(title: appDele!.isForArabic ? Delete_ar : Delete_en, style: .default, handler: { _ in
//                Service.shared.deletePost(forPostId:post.id) { status, massge in
//                    if cell.post?.isActive == true {
//                        cell.post?.isActive = false
//                        self.showAlert(withMsg: "Post deleted successfully.")
//                        self.navigationController?.popViewController(animated: true)
//                    }
//                }
//            }))
            
//            alert.addAction(UIAlertAction(title: post.purchaseStatus.hidden == "0" ? ( appDele!.isForArabic ? Hide_purchase_ar : Hide_purchase_en) : ( appDele!.isForArabic ? UnHide_purchase_ar : UnHide_purchase_en), style: .default, handler: { alert in
//                Service.shared.makeSinglePurchaseHidden(setHidden: post.purchaseStatus.hidden == "1" ? false : true, purchaseId: post.purchaseStatus.purchaseId) { status in
//                    if status {
//                        loggedInUser!.isPublic.toggle()
//                        defaults.set(nil, forKey: "USER")
//                        do {
//                            self.post.purchaseStatus.hidden = post.purchaseStatus.hidden == "1" ? "0" : "1"
//
//                            let encoder = JSONEncoder()
//                            let data = try encoder.encode(loggedInUser!)
//                            defaults.set(data, forKey: "USER")
//                            self.collectionView.reloadData()
//                        }catch{
//                            print("DEBUG:- ERROR OCCOURED WHILE CHANGING LANGUAGE: \(error.localizedDescription)")
//                        }
//                        self.collectionView.reloadData()
//                        self.showAlert(withMsg: appDele!.isForArabic ? Post_details_updated_successfully_ar : Post_details_updated_successfully_en)
//                    } else {
//
//                    }
//                }
//            }))
        } else {
            if post.isReported {
                alert.addAction(UIAlertAction(title: appDele!.isForArabic ? Reported_ar : Reported_en, style: .destructive, handler: { (action) in
                    self.showAlert(withMsg: appDele!.isForArabic ? You_have_already_reported_this_post_ar : You_have_already_reported_this_post_en)
                }))
            } else {
                alert.addAction(UIAlertAction(title: appDele!.isForArabic ? Report_ar : Report_en, style: .destructive, handler: { (action) in
                    if loggedInUser == nil {
                        appDele!.loginAlert(con: self)
                        return
                    }
                    Service.shared.reportPost(withId: post.id) { status in
                        if status {
                            self.showAlert(withMsg: appDele!.isForArabic ? Reported_ar : Reported_en)
                            self.post.isReported = true
                        } else {
                            self.showAlert(withMsg: appDele!.isForArabic ? Something_went_wrong_Please_check_your_internet_connection_and_retry_ar : Something_went_wrong_Please_check_your_internet_connection_and_retry_en)
                        }
                    }
                }))
            }
            
            alert.addAction(UIAlertAction(title:  "\(post.owner.followStatus ? appDele!.isForArabic ? Unfollow_ar : Unfollow_en : appDele!.isForArabic ? Follow_ar : Follow_en) \(post.owner.userName)", style: .default, handler: { _ in
                if loggedInUser == nil {
                    appDele!.loginAlert(con: self)
                    return
                }
                Service.shared.performAction(ofType: post.owner.followStatus ? .unfollow : .follow, onUser: post.owner) { status in
                    if status {
                        if post.owner.followStatus {
                            self.post.owner.followStatus = false
                            self.showAlert(withMsg: "\(appDele!.isForArabic ? Unfollow_ar : Unfollow_en) \(post.owner.userName) successfully!")
                        } else {
                            self.post.owner.followStatus = true
                            self.showAlert(withMsg: "\(appDele!.isForArabic ? Follow_ar : Follow_en) \(post.owner.userName) successfully!")
                        }
                        self.collectionView.reloadData()
                    } else {
                        if post.owner.followStatus {
                            self.showAlert(withMsg: "\(appDele!.isForArabic ? Unfollow_ar : Unfollow_en) \(post.owner.userName) failed!")
                        } else {
                            self.showAlert(withMsg: "\(appDele!.isForArabic ? Follow_ar : Follow_en) \(post.owner.userName) failed!")
                        }
                    }
                }
            }))
            
            alert.addAction(UIAlertAction(title: appDele!.isForArabic ? Message_ar : Message_en, style: .default, handler: { _ in
                if loggedInUser == nil {
                    appDele!.loginAlert(con: self)
                    return
                }
                //                self.openForwardPicker(post)
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
        let controller = UINavigationController(rootViewController: MediaViewerController(forMedias: cell.post!.medias))
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
    func handleLikeTapped(for cell: FeedCell) {
        if loggedInUser == nil {
            appDele!.loginAlert(con: self)
            return
        }
        guard let post = cell.post else { return }
        if cell.likeButton.isSelected {
            Service.shared.dislikePost(withPostId: post.id) { (status) in
                if status {
                    self.post.likeCount = self.post.likeCount - 1
                    self.post.isLiked = false
                    cell.likeButton.isSelected = false
                    cell.likeButton.tintColor = self.post.isLiked ? .red : .appPrimaryColor
                    cell.likeLabel.text = "\(self.post.likeCount) \(appDele!.isForArabic ? Likes_ar : Likes_en)"
                    
                    //                    self.collectionView.reloadData()
                }
            }
        } else {
            Service.shared.likePost(withPostId: post.id) { (status) in
                if status {
                    self.post.likeCount = self.post.likeCount + 1
                    self.post.isLiked = true
                    cell.likeButton.isSelected = true
                    cell.likeButton.tintColor = self.post.isLiked ? .red : .appPrimaryColor
                    cell.likeLabel.text = "\(self.post.likeCount) \(appDele!.isForArabic ? Likes_ar : Likes_en)"
                    //                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func handleCommentTapped(for cell: FeedCell) {
        if loggedInUser == nil {
            appDele!.loginAlert(con: self)
            return
        }
        let commentControler = CommentController(forPostWithId: post.id)
        navigationController?.pushViewController(commentControler, animated: true)
    }
    
    func handleMessageTapped(for cell: FeedCell) {
        if loggedInUser == nil {
            appDele!.loginAlert(con: self)
            return
        }
        forwardPicker = ForwardMessagePicker(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 340))
        guard let forwardPicker = forwardPicker else { return }
        
        forwardPicker.delegate = self
        
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
        if post.variants.count != 0 {
            guard let selectVariant = selectedVariant else {
                self.showAlert(withMsg: appDele!.isForArabic ? Select_Variant_ar : Select_Variant_en)
                return
            }
            
            if selectVariant.quantity < 1 {
                self.showAlert(withMsg: appDele!.isForArabic ? Selected_combination_is_not_available_at_the_moment_ar : Selected_combination_is_not_available_at_the_moment_en)
                return
            }
            
            let selectedQuantity = Int(cell.quantityStepper.value)
            Service.shared.addToCart(post: post, variant: selectVariant, quantity: selectedQuantity) { status, message in
                if status {
                    self.showAlert(withMsg: appDele!.isForArabic ? Item_added_to_cart_ar : Item_added_to_cart_en)
                    Utility.addToCartProduct(productId: self.post.id, productName: self.post.title, productPrice: self.post.price, productVariantId: selectVariant.id, productVariantName: selectVariant.ItemName)
                } else {
                    guard let message = message else { return }
                    self.showAlert(withMsg: "Failed: \(message)")
                }
            }
        } else {
            if post.quantity < 1 {
                self.showAlert(withMsg: appDele!.isForArabic ? Selected_combination_is_not_available_at_the_moment_ar : Selected_combination_is_not_available_at_the_moment_en)
                return
            }
            let selectedQuantity = Int(cell.quantityStepper.value)
            Service.shared.addToCart(post: post, quantity: selectedQuantity) { status, message in
                if status {
                    self.showAlert(withMsg: appDele!.isForArabic ? Item_added_to_cart_ar : Item_added_to_cart_en)
                    Utility.addToCartProduct(productId: self.post.id, productName: self.post.title, productPrice: self.post.price, productVariantId: "", productVariantName: "")
                } else {
                    guard let message = message else { return }
                    self.showAlert(withMsg: "Failed: \(message)")
                }
            }
        }
    }
    
    func handleBuyTapped(for cell: FeedCell, withVariant variantView: FeedExpandedVarientView?) {
        if loggedInUser == nil {
            appDele!.loginAlert(con: self)
            return
        }
        if loggedInUser?.id ?? "" == post.owner.id {
            Utility.showISMessage(str_title: appDele!.isForArabic ? You_cannot_purchase_your_own_product_ar : You_cannot_purchase_your_own_product_en, Message: "", msgtype: .warning)
            return
        }
        if post.variants.count != 0 {
            guard let selectVariant = selectedVariant else {
                self.showAlert(withMsg: appDele!.isForArabic ? Select_Variant_ar : Select_Variant_en)
                return
            }
            if selectVariant.quantity < 1 {
                self.showAlert(withMsg: appDele!.isForArabic ? Selected_combination_is_not_available_at_the_moment_ar : Selected_combination_is_not_available_at_the_moment_en)
                return
            }
            let controller = CartCheckoutController(forCartItems: [])
            controller.variantId = selectedVariant?.id ?? ""
            controller.postId = post.id
            controller.productDirectBuyAmount = "\(selectVariant.price)"
            controller.intDirectBuyQty = Int(cell.quantityStepper.value)
            controller.isDirectBuy = true
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
            controller.intDirectBuyQty = Int(cell.quantityStepper.value)
            navigationController?.pushViewController(controller, animated: true)
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
}

extension SinglePostController: ForwardMessagePickerDelegate {
    func forwardMessagePicker(_ forwardMessagePicker: ForwardMessagePicker, didSelectUser user: User, at indexPath: IndexPath) {
        dismissPicker()
        SocketService.shared.sharePost(toUser: user.id, postId: forwardMessagePicker.post?.id ?? "")
    }
}


extension String {
    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.font = font
        label.sizeToFit()
        
        return label.frame.height
    }
}
