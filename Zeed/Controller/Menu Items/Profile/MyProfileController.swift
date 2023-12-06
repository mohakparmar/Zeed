//
//  MyProfileController.swift
//  Zeed
//
//  Created by Shrey Gupta on 27/04/21.
//

import UIKit
import JGProgressHUD
import Network

enum MyProfileSections: Int, CaseIterable {
    case info
    case stats
    case action
    case items
    
    var height: CGFloat {
        switch self {
        case .info:
            return 150
        case .stats:
            return 60
        case .action:
            return 70
        case .items:
            return 100
        }
    }
}

class MyProfileController: UITableViewController {
    //MARK: - Properties
    var user: User? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var userPosts = [PostItem]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var allPurchases = [PurchasedPostItem]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var shouldShowFullBio: Bool = true
    
    var progressHud = JGProgressHUD(style: .dark)
    
    //MARK: - UI Elements
    private lazy var cartButton: BadgeButton = {
        let button = BadgeButton()
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
        bagButton.setImage(UIImage(named: "plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        let currentUser = AppUser.shared.getDefaultUser()
        if currentUser?.isSeller ?? false == true {
            bagButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)

            bagButton.setDimensions(height: 30, width: 30)
        } else {
            bagButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 15)
            bagButton.badge = itemvalue
            bagButton.setImage(UIImage(named: "cartWithOutBadge")?.withRenderingMode(.alwaysTemplate), for: .normal)

        }
        bagButton.addTarget(self, action: #selector(handleCart), for: .touchUpInside)
        return bagButton
    }
    
    //MARK: - API
    func fetchCartItems() {
        let currentUser = AppUser.shared.getDefaultUser()
        if currentUser?.isSeller ?? false == true {
            if appDele!.isForArabic == true {
                navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: messageButton), UIBarButtonItem(customView: plusIcon) ]
            } else {
                navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: messageButton), UIBarButtonItem(customView: plusIcon)]
            }
        } else {
            if appDele!.isForArabic == true {
                navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: messageButton),  UIBarButtonItem(customView: self.addBadge(itemvalue: "0"))]
            } else {
                navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: messageButton), UIBarButtonItem(customView: self.addBadge(itemvalue: "0"))]
            }
            Service.shared.getCartItems { (cartItems, status, message) in
                if status {
                    guard let cartItems = cartItems else { return }
                    appDele?.arrForCart = cartItems
                    if cartItems.count > 0 {
                        if appDele!.isForArabic == true {
                            self.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: self.messageButton), UIBarButtonItem(customView: self.addBadge(itemvalue: "\(cartItems.count)"))]
                        } else {
                            self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: self.messageButton), UIBarButtonItem(customView: self.addBadge(itemvalue: "\(cartItems.count)"))]
                        }
                    }
                }
            }
        }
    }
    

    private lazy var plusIcon: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(named: "plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.setDimensions(height: 25, width: 25)
        button.addTarget(self, action: #selector(handleCart), for: .touchUpInside)
        button.tintColor = .appPrimaryColor
        return button
    }()

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
    
    
    
    lazy var product: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "product1")
        iv.contentMode = .scaleAspectFit
        iv.frame = CGRect(x: 30, y: 220, width: 25, height: 25)
        return iv
    }()
    
    lazy var purchaseImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "purchase1")
        iv.contentMode = .scaleAspectFit
        iv.frame = CGRect(x: ((screenWidth / 2 ) + 20), y: 220, width: 25, height: 25)
        return iv
    }()
    
    var ref = UIRefreshControl()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.openScreenView(str_screen_name: "My_Profile", str_nib_name: self.nibName ?? "")
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: .appBackgroundColor), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = .appPrimaryColor
        self.navigationController?.navigationBar.barTintColor = .appBackgroundColor
        self.navigationItem.title = appDele!.isForArabic ? My_profile_ar : My_profile_en
        
        if #available(iOS 15, *) {
            navigationController?.navigationBar.update(backroundColor: .appBackgroundColor, titleColor: .appPrimaryColor)
        }
        
        tableView.register(UserProfileInfoCell.self, forCellReuseIdentifier: UserProfileInfoCell.reuseIdentifier)
        tableView.register(UserProfileStatsContainerCell.self, forCellReuseIdentifier: UserProfileStatsContainerCell.reuseIdentifier)
        tableView.register(UserProfileActionButtonsCell.self, forCellReuseIdentifier: UserProfileActionButtonsCell.reuseIdentifier)
        tableView.register(UserProfileItemsContainerCell.self, forCellReuseIdentifier: UserProfileItemsContainerCell.reuseIdentifier)
        
        tableView.tableFooterView = UIView()
        
        ref.attributedTitle = NSAttributedString(string: "")
        ref.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(ref) // not required when using UITableViewController
        
        let currentUser = AppUser.shared.getDefaultUser()
//        if currentUser?.isSeller ?? false {
//            self.view.addSubview(product)
//            self.view.addSubview(purchaseImage)
//        }

        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)

        configureUI()
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        if let dict = notification.userInfo as? [String:Any] {
            if let myItem = dict["myItem"] as? String {
                if self.user != nil {
                    self.fetchUserPosts(forUser: self.user!, cateId: myItem)
                }
            } else if let myItem = dict["purchaseId"] as? String {
                if self.user != nil {
                    self.fetchPurchasedPosts(forUser: self.user!, cateId: myItem)
                }
            } else {
                self.fetchPurchasedPosts(forUser: self.user!, cateId: "")
            }
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchCartItems()
        fetchUser()
        NotificationCenter.default.post(name: Notification.Name("CallCategoryService"), object: nil, userInfo: [:])
    }
    
    //MARK: - Selectors
    @objc func handleCart() {
        let currentUser = AppUser.shared.getDefaultUser()
        if currentUser?.isSeller ?? false == true {
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
        
        let obj = OtherProfileVC()
        self.navigationController?.pushViewController(obj, animated: true)
        
//        let controller = UINavigationController(rootViewController: NotificationContainer())
//        controller.modalPresentationStyle = .fullScreen
//        present(controller, animated: true, completion: nil)
    }
    
    @objc func handleMessages() {
        //        let controller = UINavigationController(rootViewController: MessagesContainer())
        let controller = UINavigationController(rootViewController: ChatListViewController())
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .coverVertical
        
        present(controller, animated: true, completion: nil)
    }
    
    //MARK: - API
    func fetchUser() {
        guard let loggedUser = loggedInUser else { return }
        progressHud.show(in: self.view)
        Service.shared.getUserData(forUserId: loggedUser.id) { (user, status, message) in
            self.ref.endRefreshing()
            self.progressHud.dismiss(animated: true)
            if status {
                guard let user = user else { return }
                self.user = user
                self.navigationItem.title = self.user?.userName ?? ""
//                self.fetchUserPosts(forUser: user, cateId: "")
//                self.fetchPurchasedPosts(forUser: user, cateId: "")
            } else {
                guard let message = message else { return }
                self.showAlert(withMsg: message)
            }
        }
    }
    
    func fetchUserPosts(forUser user: User, cateId:String) {
        Service.shared.fetchAllPost(userId: user.id, cID: cateId, isRandom: false) { items, status, message in
            if status {
                guard let allItems = items else { return }
                self.userPosts = allItems
            } else {
                self.showAlert(withMsg: "Error occoured while fetching posts.")
            }
        }
    }
    
    func fetchPurchasedPosts(forUser user: User, cateId:String) {
        Service.shared.fetchAllMyPurchases(forUserId: user.id, cID: cateId) { allPurchases, status, message in
            if status {
                guard let allPurchases = allPurchases else { return }
                self.allPurchases = allPurchases
            } else {
                self.showAlert(withMsg: "Error occoured while fetching purchases.")
            }
        }
    }
    //MARK: - Helper Functions
    func configureUI() {
        tableView.backgroundColor = .white
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().tranFormingView(toArabic: self.view)
            navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: notificationButton)]
            navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: messageButton), UIBarButtonItem(customView: cartButton)]
        } else {
            navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: notificationButton)]
            navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: messageButton), UIBarButtonItem(customView: cartButton)]
        }
        
    }
    
    var arrForitem: [MyProfileSections] {
        let currentUser = AppUser.shared.getDefaultUser()
        if currentUser?.isSeller ?? false {
            return MyProfileSections.allCases
        } else {
            return MyProfileSections.allCases
            return [MyProfileSections.info, MyProfileSections.stats, MyProfileSections.action]
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if user == nil {
            return 0
        }
        return arrForitem.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = MyProfileSections(rawValue: arrForitem[indexPath.section].rawValue)!
        
        switch sectionType {
        case .info:
            let cell = tableView.dequeueReusableCell(withIdentifier: UserProfileInfoCell.reuseIdentifier, for: indexPath) as! UserProfileInfoCell
            cell.delegate = self
            cell.user = user
            cell.optionButton.setImage(#imageLiteral(resourceName: "extra_menu"), for: .normal)
            return cell
        case .stats:
            let cell = tableView.dequeueReusableCell(withIdentifier: UserProfileStatsContainerCell.reuseIdentifier, for: indexPath) as! UserProfileStatsContainerCell
            cell.delegate = self
            cell.user = user
            return cell
        case .action:
            let cell = tableView.dequeueReusableCell(withIdentifier: UserProfileActionButtonsCell.reuseIdentifier, for: indexPath) as! UserProfileActionButtonsCell
            cell.user = user
            cell.delegate = self
            return cell
        case .items:
            let cell = tableView.dequeueReusableCell(withIdentifier: UserProfileItemsContainerCell.reuseIdentifier, for: indexPath) as! UserProfileItemsContainerCell
            cell.productItems.items = userPosts
            cell.purchasedItems.items = allPurchases
            cell.delegate = self
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionType = MyProfileSections(rawValue: indexPath.section)!
        
        if sectionType == .info {
            if shouldShowFullBio {
                return UITableView.automaticDimension
            }
        }
        
        if sectionType == .items {
            let cellWidth = (view.frame.width - 3)/3
            return CGFloat(45 + ((9/3) * 1) + (cellWidth * (9/3)))
        } else {
            return sectionType.height
        }
    }
}

//MARK: - Delegate UserProfileInfoCellDelegate
extension MyProfileController: UserProfileInfoCellDelegate {
    func handleOptionsTapped() {
        navigationController?.pushViewController(ProfileContainer(), animated: true)
    }
}

//MARK: -
extension MyProfileController: UserProfileStatsContainerCellDelegate {
    func didTapProfileStatsOf(_ type: UserProfileStatsCellTypes) {
        guard let user = user else { return }
        if type == .followers || type == .following {
            let controller = FollowContainer(forUser: user, type: type)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension MyProfileController: UserProfileActionButtonsCellDelegate {
    func followTapped(cell: UserProfileActionButtonsCell) {}
    
    func messageTapped(cell: UserProfileActionButtonsCell) {}
    
    func editProfileTapped(cell: UserProfileActionButtonsCell) {
        let controller = UINavigationController(rootViewController: EditMyProfileController1())
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
}




extension UINavigationBar {
    func update(backroundColor: UIColor? = nil, titleColor: UIColor? = nil) {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            if let backroundColor = backroundColor {
                appearance.backgroundColor = backroundColor
            }
            if let titleColor = titleColor {
                appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: titleColor]
            }
            standardAppearance = appearance
            scrollEdgeAppearance = appearance
        } else {
            barStyle = .blackTranslucent
            if let backroundColor = backroundColor {
                barTintColor = backroundColor
            }
            if let titleColor = titleColor {
                titleTextAttributes = [NSAttributedString.Key.foregroundColor: titleColor]
            }
        }
    }
}


extension MyProfileController: UserProfileItemsContainerCellDelegate {
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

//            Service.shared.fetchSinglePost(forPostId: id, userId: user?.id ?? "") { item, status, message in
//                Utility.hideHud()
//                if status {
//                    guard let item = item else { return }
//                    let controller = SinglePostController(forPost: item, isForSingleItem: true)
//                    self.navigationController?.pushViewController(controller, animated: true)
//                } else {
//                    guard let message = message else { return }
//                    Utility.showISMessage(str_title: "Failed!", Message: "Error occoured while loading post: \(message)", msgtype: .error)
//                }
//            }
        case .auction:
            print("DEBUG:- <#what#>")
            Utility.showHud(view: self.view)

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
    
    func didSelectItem(withId id: String) {
        Utility.showHud(view: self.view)
        
        Service.shared.fetchSinglePost(forPostId: id) { item, status, message in
            Utility.hideHud()
            if status {
                guard let item = item else { return }
                let controller = SinglePostController(forPost: item, isForSingleItem: true)
                self.navigationController?.pushViewController(controller, animated: true)
            } else {
                guard let message = message else { return }
                Utility.showISMessage(str_title: "Failed!", Message: "Error occoured while loading image: \(message)", msgtype: .error)
            }
        }
    }
}



class BadgeButton: UIButton {
    
    var badgeLabel = UILabel()
    
    var badge: String? {
        didSet {
            addbadgetobutton(badge: badge)
        }
    }
    
    public var badgeBackgroundColor = UIColor.red {
        didSet {
            badgeLabel.backgroundColor = badgeBackgroundColor
        }
    }
    
    public var badgeTextColor = UIColor.white {
        didSet {
            badgeLabel.textColor = badgeTextColor
        }
    }
    
    public var badgeFont = UIFont.systemFont(ofSize: 12.0) {
        didSet {
            badgeLabel.font = badgeFont
        }
    }
    
    public var badgeEdgeInsets: UIEdgeInsets? {
        didSet {
            addbadgetobutton(badge: badge)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addbadgetobutton(badge: nil)
    }
    
    func addbadgetobutton(badge: String?) {
        badgeLabel.text = badge
        badgeLabel.textColor = badgeTextColor
        badgeLabel.backgroundColor = badgeBackgroundColor
        badgeLabel.font = badgeFont
        badgeLabel.sizeToFit()
        badgeLabel.textAlignment = .center
        let badgeSize = badgeLabel.frame.size
        
        let height = max(18, Double(badgeSize.height) + 5.0)
        let width = max(height, Double(badgeSize.width) + 10.0)
        
        var vertical: Double?, horizontal: Double?
        if let badgeInset = self.badgeEdgeInsets {
            vertical = Double(badgeInset.top) - Double(badgeInset.bottom)
            horizontal = Double(badgeInset.left) - Double(badgeInset.right)
            
            let x = (Double(bounds.size.width) - 10 + horizontal!)
            let y = -(Double(badgeSize.height) / 2) - 10 + vertical!
            badgeLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        } else {
            let x = self.frame.width - CGFloat((width / 2.0))
            let y = CGFloat(-(height / 2.0))
            badgeLabel.frame = CGRect(x: x, y: y, width: CGFloat(width), height: CGFloat(height))
        }
        
        badgeLabel.layer.cornerRadius = badgeLabel.frame.height/2
        badgeLabel.layer.masksToBounds = true
        addSubview(badgeLabel)
        if badge == "0" || badge == nil {
            badgeLabel.isHidden = true
        } else {
            badgeLabel.isHidden = false
        }
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addbadgetobutton(badge: nil)
        fatalError("init(coder:) is not implemented")
    }
}

	
