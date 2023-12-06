//
//  OtherProfileVC.swift
//  Zeed
//
//  Created by Mohak Parmar on 24/12/22.
//

import UIKit
import JGProgressHUD

class OtherProfileVC: UIViewController {
    
    var userId: String = ""
    var user: User? {
        didSet {
            self.setUpUserDetails()
        }
    }
    
    @IBOutlet weak var viewProductMain: UIView!
    @IBOutlet weak var scrView: UIScrollView!
    var shouldShowFullBio: Bool = true
    var progressHud = JGProgressHUD(style: .dark)
    var ref = UIRefreshControl()
    
    @IBOutlet weak var viewPurchaseMain: UIView!
    @IBOutlet weak var userProfileImageView: CustomImageView!
    @IBOutlet weak var lblStoreName: UILabel!
    @IBOutlet weak var lblAbout: UILabel!
    @IBOutlet weak var imgStore: UIImageView!
    
    @IBOutlet weak var collectionStatusData: UICollectionView!
    
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var btnMessage: UIButton!
    
    @IBOutlet weak var viewProductSeprator: UIView!
    @IBOutlet weak var lblProduct: UILabel!
    @IBOutlet weak var viewPurchaseSeprator: UIView!
    @IBOutlet weak var lblPurchase: UILabel!
    
    @IBOutlet weak var collectionCategories: UICollectionView!
    
    var selectedCategory: ItemSubCategory?
    var allCategories: [ItemSubCategory] = []
    
    var userPosts: [PostItem] = []
    var allPurchases: [PurchasedPostItem] = []
    
    @IBOutlet weak var collectionItems: UICollectionView!
    @IBOutlet weak var btnMenu: UIButton!
    
    @IBOutlet weak var btnEditProfile: UIButton!
    @IBOutlet weak var constCollectionHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar(largeTitleColor: .appPrimaryColor, backgoundColor: .appBackgroundColor, tintColor: .appPrimaryColor, title: "Store", preferredLargeTitle: false)
        Utility.openScreenView(str_screen_name: "OtherUserProfile", str_nib_name: self.nibName ?? "")
        
        collectionStatusData.registerNib(nibName: "UserStatusCCell", reUse: "UserStatusCCell")
        collectionCategories.registerNib(nibName: "CategoryCCell", reUse: "CategoryCCell")
        collectionItems.register(ExploreCell.self, forCellWithReuseIdentifier: ExploreCell.reuseIdentifier)
        btnMenu.imageView?.contentMode = .scaleAspectFit

        if appDele!.isForArabic == true {
            ConvertArabicViews.init().tranFormingView(toArabic: self.view)
        }

        if AppUser.shared.getDefaultUser()?.id == self.userId {
            if appDele!.isForArabic == true {
                btnEditProfile.setTitle("تعديل الملف الشخصي", for: .normal)
            }
            btnEditProfile.isHidden = false
            btnMessage.isHidden = true
            followButton.isHidden = true
            btnMenu.setImage(UIImage(named: "extra_menu"), for: .normal)
            navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: notificationButton), UIBarButtonItem(customView: searchIcon)]
        } else {
            navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: backButton), UIBarButtonItem(customView: searchIcon)]
        }
        
            ref.attributedTitle = NSAttributedString(string: "")
        ref.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        scrView.addSubview(ref) // not required when using UITableViewController

        fetchUser()
    }
    
    
    
    @objc func refresh(_ sender: AnyObject) {
        fetchUser()
    }

    override func viewWillAppear(_ animated: Bool) {
        fetchCartItems()
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
    
    private lazy var notificationButton: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(#imageLiteral(resourceName: "notification"), for: .normal)
        button.setDimensions(height: 30, width: 30)
        button.addTarget(self, action: #selector(handleNotification), for: .touchUpInside)
        button.tintColor = .appPrimaryColor
        return button
    }()

    private lazy var plusIcon: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(named: "plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.setDimensions(height: 25, width: 25)
        button.addTarget(self, action: #selector(addItemClick), for: .touchUpInside)
        button.tintColor = .appPrimaryColor
        return button
    }()

    private lazy var searchIcon: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(named: "search")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.setDimensions(height: 25, width: 25)
        button.addTarget(self, action: #selector(searchButtonClick), for: .touchUpInside)
        button.tintColor = .appPrimaryColor
        return button
    }()

    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(named: "backarrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.setDimensions(height: 25, width: 25)
        button.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        button.tintColor = .appPrimaryColor
        return button
    }()

    //MARK: - Selectors
    @objc func searchButtonClick() {
        let obj = SearchUserProductsVC()
        obj.uId = self.user?.id ?? ""
        self.navigationController?.pushViewController(obj, animated: true)
    }
    //MARK: - Selectors
    @objc func backButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }

    //MARK: - Selectors
    @objc func addItemClick() {
        let currentUser = AppUser.shared.getDefaultUser()
        if currentUser?.isSeller ?? false == true && self.userId == currentUser?.id ?? "" {
            let obj = CreateController()
            obj.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(obj, animated: true)
        } else {
            let controller = UINavigationController(rootViewController: CartController(collectionViewLayout: UICollectionViewFlowLayout()))
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: true, completion: nil)
        }
    }

    @objc func handleNotification() {
        let controller = UINavigationController(rootViewController: NotificationContainer())
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    

    //MARK: - API
    func fetchCartItems() {
        let currentUser = AppUser.shared.getDefaultUser()
        if currentUser?.isSeller ?? false == true && self.userId == currentUser?.id ?? "" {
            navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: messageButton), UIBarButtonItem(customView: plusIcon)]
        } else {
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
    
    //MARK: - Selectors
    @objc func handleCart() {
        print("DEBUG:- handleCart")
        let controller = UINavigationController(rootViewController: CartController(collectionViewLayout: UICollectionViewFlowLayout()))
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
    @objc func handleMessages() {
        print("DEBUG:- handleMessages")
        let obj = ChatViewController()
        obj.objUser.id = self.user?.id
        obj.objUser.username = self.user?.userName
        obj.objUser.objImage.url = self.user?.image.url
        obj.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(obj, animated: true)
        
    }
    
    var isRefreshUser : Bool = true
    //MARK: - API
    func fetchUser() {
        progressHud.show(in: self.view)
        Service.shared.getUserData(forUserId: userId) { (user, status, message) in
            self.progressHud.dismiss(animated: true)
            if status {
                self.ref.endRefreshing()
                guard let user = user else { return }
                self.user = user
                self.navigationItem.title = self.user?.userName ?? ""
                //                self.tableView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    self.isRefreshUser = false
                })
                //                self.fetchUserPosts(forUser: user)
                //                self.fetchPurchasedPosts(forUser: user)
            } else {
                guard let message = message else { return }
                self.showAlert(withMsg: message)
            }
        }
    }
    
    func setUpUserDetails() {
        btnEditProfile.layer.borderWidth = 1
        btnEditProfile.layer.borderColor = UIColor.gradientSecondColor.cgColor
        btnEditProfile.layer.cornerRadius = 10;

        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor.gradientSecondColor.cgColor
        followButton.layer.cornerRadius = 10;
        btnMessage.layer.cornerRadius = 10;
        followButton.setTitle(appDele!.isForArabic ? Follow_ar : Follow_en, for: .normal)
        followButton.setTitle(appDele!.isForArabic ? Following_ar : Following_en, for: .selected)
        followButton.setTitleColor(.white, for: .normal)
        followButton.setTitleColor(.gradientSecondColor, for: .selected)
        followButton.isSelected = user?.followStatus ?? false
        followButton.backgroundColor = followButton.isSelected ? .white : .gradientSecondColor
        followButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        userProfileImageView.setUserImageUsingUrl(user?.image.url)
        if user?.storeDetails.shopName == "" {
            lblStoreName.text = user?.fullName
        } else {
            lblStoreName.text = user?.storeDetails.shopName
        }
        lblStoreName.text = user?.fullName
        lblAbout.text = user?.about
        userProfileImageView.layer.cornerRadius = userProfileImageView.height / 2
        imgStore.isHidden = !(user?.isSeller ?? false)
        self.collectionStatusData.reloadData()
        if self.user?.isPublic == true {
            viewPurchaseMain.isHidden = false
        } else if self.user?.isPublic == false || self.user?.followStatus == true {
            viewPurchaseMain.isHidden = false
        } else {
            viewPurchaseMain.isHidden = true
        }

        if self.user?.isSeller == true {
            self.fetchCategories(true)
            viewProductSeprator.isHidden = false
            viewPurchaseSeprator.isHidden = true
            viewProductMain.isHidden = false
        } else {
            viewProductMain.isHidden = true
            self.fetchCategories(false)
            viewProductSeprator.isHidden = true
            viewPurchaseSeprator.isHidden = false
        }
        
        
        
        lblProduct.text = appDele!.isForArabic == true ? Products_ar : Products_en
        lblPurchase.text = appDele!.isForArabic == true ? Purchase_ar : Purchase_en
    }
    
    @IBAction func btnMessageClick(_ sender: Any) {
        let obj = ChatViewController()
        obj.objUser.id = self.user?.id
        obj.objUser.username = self.user?.userName
        obj.objUser.objImage.url = self.user?.image.url
        obj.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnFollowClick(_ sender: Any) {
        followButton.isSelected.toggle()
        followButton.backgroundColor = followButton.isSelected ? .white : .gradientSecondColor
        guard let user = user else { return }
        if user.followStatus {
            Service.shared.performAction(ofType: .unfollow, onUser: user) {_ in }
        } else {
            Service.shared.performAction(ofType: .follow, onUser: user) {_ in }
        }
    }
    
    
    @IBAction func btnEditProfileClick(_ sender: Any) {
        let controller = UINavigationController(rootViewController: EditMyProfileController1())
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
    
    @IBAction func btnProductClick(_ sender: Any) {
        viewProductSeprator.isHidden = false
        viewPurchaseSeprator.isHidden = true
        self.fetchCategories(true)
        
    }
    
    @IBAction func btnPurchaseClick(_ sender: Any) {
        viewProductSeprator.isHidden = true
        viewPurchaseSeprator.isHidden = false
        self.fetchCategories(false)
    }
    
    //MARK: - API
    func fetchCategories(_ isMyProduct : Bool) {
        Service.shared.getAllSubCategories(isPurchaseItem:!isMyProduct, isMyProduct:isMyProduct,  userId: user?.id ?? "") { (allCategories, status, message) in
            if status {
                guard let allCategories = allCategories else { return }
                self.allCategories  = []
                var dict : [String:Any] = [:]
                dict["id"] = ""
                dict["nameEn"] = " All "
                dict["nameAr"] = " الجميع "
                let objCate = ItemSubCategory(dict: dict)
                self.allCategories.append(objCate)
                self.allCategories.append(contentsOf: allCategories)
                if self.allCategories.count > 0 {
                    self.selectedCategory = self.allCategories[0]
                    self.getProduct()
                }
                self.collectionCategories.reloadData()
            }
        }
    }
    
    func getProduct() {
        guard let user = user else { return }
        if viewProductSeprator.isHidden {
            self.fetchPurchasedPosts(forUser: user, cateId: selectedCategory?.id ?? "")
        } else {
            self.fetchUserPosts(forUser: user, cateId: selectedCategory?.id ?? "")
        }
    }
    
    @IBAction func btnMenuClick(_ sender: Any) {
        
        if AppUser.shared.getDefaultUser()?.id == self.userId {
            navigationController?.pushViewController(ProfileContainer(), animated: true)
            return
        }
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Share", style: .default, handler: { (action) in
            //            guard let post = cell.post else { return }
            //            guard let image = post.medias.first?.url else { return }
            //            let text = "Hey, check out this \(post.title) at Zeed! \n\(post.about)"
            //            let link = URL(string: "www.google.com")!
            //            let shareAll = [text, image, link] as [Any]
            //            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            //            activityViewController.popoverPresentationController?.sourceView = self.view
            //            self.present(activityViewController, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Report", style: .destructive, handler: { (action) in
            self.showAlert(withMsg: "This account has been Reported by you!")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }

    func fetchUserPosts(forUser user: User, cateId:String) {
        Service.shared.fetchAllPost(userId: user.id, cID: cateId, isRandom: false) { items, status, message in
            if status {
                guard let allItems = items else { return }
                self.userPosts = allItems
                self.collectionItems.reloadData()
                let width = self.collectionItems.frame.size.width / 3
                self.constCollectionHeight.constant = CGFloat(((self.userPosts.count / 3) + 1)) * width
            } else {
                self.constCollectionHeight.constant = 0
                self.userPosts = []
                self.collectionItems.reloadData()
                self.showAlert(withMsg: "Error occoured while fetching posts.")
            }
        }
    }
    
    func fetchPurchasedPosts(forUser user: User, cateId:String) {
        Service.shared.fetchAllMyPurchases(forUserId: user.id, cID: cateId) { allPurchases, status, message in
            if status {
                guard let allPurchases = allPurchases else { return }
                self.allPurchases = allPurchases
                self.collectionItems.reloadData()
                let width = self.collectionItems.frame.size.width / 3
                self.constCollectionHeight.constant = CGFloat(((self.allPurchases.count / 3) + 1)) * width
            } else {
                self.constCollectionHeight.constant = 0
                self.allPurchases = []
                self.collectionItems.reloadData()
                self.showAlert(withMsg: "Error occoured while fetching purchases.")
            }
        }
    }

}


extension OtherProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionStatusData {
            return UserProfileStatsCellTypes.allCases.count
        } else if collectionView == collectionCategories {
            return allCategories.count
        } else if collectionView == collectionItems {
            return viewProductSeprator.isHidden ? self.allPurchases.count : self.userPosts.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionCategories {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCCell.reuseIdentifier, for: indexPath) as! CategoryCCell
            cell.lblTitle.text = allCategories[indexPath.row].nameEn
            cell.viewMain.setRadius(radius: 5)
            if allCategories[indexPath.row].id == selectedCategory?.id {
                cell.viewMain.backgroundColor = .gradientSecondColor
                cell.lblTitle.textColor = .white
            } else {
                cell.viewMain.backgroundColor = .white
                cell.lblTitle.textColor = UIColor.hex("#807F7F")
            }
            cell.viewMain.layer.borderColor = UIColor.gradientSecondColor.cgColor
            cell.viewMain.layer.borderWidth = 1
            if appDele!.isForArabic == true {
                ConvertArabicViews.init().convertSingleView(toAr: cell.contentView)
                cell.lblTitle.text = allCategories[indexPath.row].nameAr
            }
            return cell
        } else if collectionView == collectionItems {
            if viewProductSeprator.isHidden {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreCell.reuseIdentifier, for: indexPath) as! ExploreCell
                cell.galleryImageView.image = UIImage(named: "logo")
                cell.galleryImageView.loadImage(from: allPurchases[indexPath.row].medias.last?.url ?? "")
                cell.galleryImageView.isUserInteractionEnabled = true
                cell.galleryImageView.tag = indexPath.item
                cell.purchaseImg.isHidden = false
                cell.hiddenImg.isHidden = false
                if loggedInUser?.id == user?.id {
                    cell.hiddenImg.image = UIImage(named: allPurchases[indexPath.row].purchaseStatus.hidden == "1" ? "hidden" : "")
                } else {
                    cell.hiddenImg.isHidden = true
                }
                cell.galleryImageView.backgroundColor = .random
                if allPurchases[indexPath.row].postBaseType == .normalSelling {
                    cell.purchaseImg.isHidden = true
                } else {
                    cell.purchaseImg.isHidden = false
                }
                let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(UserProfilePurchasedItems.longPress(longPressGestureRecognizer:)))
                cell.galleryImageView.addGestureRecognizer(longPressRecognizer)
                if appDele!.isForArabic == true {
                    ConvertArabicViews.init().convertSingleView(toAr: cell)
                }
                return cell
            } else {
                let cell = collectionItems.dequeueReusableCell(withReuseIdentifier: ExploreCell.reuseIdentifier, for: indexPath) as! ExploreCell
                cell.post = userPosts[indexPath.row]
                cell.hiddenImg.isHidden = true
                cell.purchaseImg.isHidden = true
                if appDele!.isForArabic == true {
                    ConvertArabicViews.init().convertSingleView(toAr: cell)
                }
                return cell
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserStatusCCell", for: indexPath) as! UserStatusCCell
            cell.lblTitle.text = UserProfileStatsCellTypes.allCases[indexPath.item].description
            switch indexPath.row {
            case 0:
                cell.lblNumber.text = "\(user?.followers ?? 0)"
            case 1:
                cell.lblNumber.text = "\(user?.following ?? 0)"
            case 2:
                cell.lblNumber.text = "\(user?.numberOfProducts ?? 0)"
            case 3:
                cell.lblNumber.text = "\(user?.numberOfAuctions ?? 0)"
            default:
                break
            }
            if appDele!.isForArabic == true {
                ConvertArabicViews.init().convertSingleView(toAr: cell.contentView)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionCategories {
            let Str = appDele!.isForArabic ?  allCategories[indexPath.row].nameAr : allCategories[indexPath.row].nameEn
            let Font =  UIFont.systemFont(ofSize: 20)
            let SizeOfString = Str.SizeOf_String(font: Font).width
            return CGSize(width: (SizeOfString + 15), height: 50)
        } else if collectionView == collectionItems {
            let width = self.collectionItems.frame.size.width / 3
            return CGSize(width: width, height: width)
        } else {
            return CGSize(width: self.collectionStatusData.frame.size.width / 4, height: collectionStatusData.frame.size.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionStatusData {
            guard let user = user else { return }
            if UserProfileStatsCellTypes.allCases[indexPath.item] == .followers || UserProfileStatsCellTypes.allCases[indexPath.item] == .following {
                let controller = FollowContainer(forUser: user, type: UserProfileStatsCellTypes.allCases[indexPath.item])
                navigationController?.pushViewController(controller, animated: true)
            }
        } else if collectionView == collectionCategories {
            selectedCategory = self.allCategories[indexPath.row]
            self.collectionCategories.reloadData()
            self.getProduct()
        } else if collectionView == collectionItems {
            if viewProductSeprator.isHidden {
                if allPurchases[indexPath.row].postId.checkEmpty() == false {
                    self.didSelectItem(withId: allPurchases[indexPath.row].postId, ofType: allPurchases[indexPath.row].type, post: PostItem(dict: [:]))
                } else {
                    self.didSelectItem(withId: allPurchases[indexPath.row].id, ofType: allPurchases[indexPath.row].type, post: PostItem(dict: [:]))
                }
            } else {
                self.didSelectItem(withId: userPosts[indexPath.row].id, ofType: userPosts[indexPath.row].type, post: userPosts[indexPath.row])
            }
        }
    }
    
    
    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if viewProductSeprator.isHidden {
            let item = allPurchases[longPressGestureRecognizer.view?.tag ?? 0]
            print("DEBUG:- IRTEM TYPE: \(item.type)")
            let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: item.purchaseStatus.hidden == "0" ? ( appDele!.isForArabic ? Hide_purchase_ar : Hide_purchase_en) : ( appDele!.isForArabic ? UnHide_purchase_ar : UnHide_purchase_en), style: .default, handler: { alert in
                Service.shared.makeSinglePurchaseHidden(setHidden: item.purchaseStatus.hidden == "1" ? false : true, purchaseId: item.purchaseStatus.purchaseId) { status in
                    if status {
                        loggedInUser!.isPublic.toggle()
                        defaults.set(nil, forKey: "USER")
                        do {
                            self.allPurchases[longPressGestureRecognizer.view?.tag ?? 0].purchaseStatus.hidden = item.purchaseStatus.hidden == "1" ? "0" : "1"
                            
                            let encoder = JSONEncoder()
                            let data = try encoder.encode(loggedInUser!)
                            defaults.set(data, forKey: "USER")
                        }catch{
                            print("DEBUG:- ERROR OCCOURED WHILE CHANGING LANGUAGE: \(error.localizedDescription)")
                        }
                        self.collectionItems.reloadData()
                        self.showAlert(withMsg: appDele!.isForArabic ? Post_details_updated_successfully_ar : Post_details_updated_successfully_en)
                    } else {
                        
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: appDele!.isForArabic ? Cancel_ar : Cancel_en, style: .cancel, handler: { alert in
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func didSelectItem(withId id: String, ofType type: PostType, post: PostItem) {
        switch type {
        case .fixed:
            if post.id == "" {
                var po = post
                po.id = id
                let controller = SinglePostController(forPost: po, isForSingleItem: true)
                self.navigationController?.pushViewController(controller, animated: true)
            } else {
                let controller = SinglePostController(forPost: post, isForSingleItem: true)
                self.navigationController?.pushViewController(controller, animated: true)
            }
            return
        case .auction:
            Service.shared.fetchPostDetail(postId: id, userId: user?.id ?? "") { items, status, message in
                Utility.hideHud()
                if status {
                    guard let items = items else { return }
                    let controller = BiddingController(isForSingleItem: true)
                    controller.allBidItems = items
                    self.navigationController?.pushViewController(controller, animated: true)
                } else {
                    guard let message = message else { return }
                    Utility.showISMessage(str_title: "Failed!", Message: "Error occoured while loading bid: \(message)", msgtype: .error)
                }
            }
        }
    }
}

