//
//  UserProfileController.swift
//  Zeed
//
//  Created by Shrey Gupta on 04/03/21.
//

import UIKit
import JGProgressHUD

enum UserProfileSections: Int, CaseIterable {
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

class UserProfileController: UITableViewController {
    //MARK: - Properties
    var userId: String
    
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
    
    //MARK: - Lifecycle
    init(forUserId id: String) {
        self.userId = id
        super.init(style: .plain)
        
        fetchUser()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var ref = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar(largeTitleColor: .appPrimaryColor, backgoundColor: .appBackgroundColor, tintColor: .appPrimaryColor, title: "Store", preferredLargeTitle: false)
        Utility.openScreenView(str_screen_name: "User_Profile", str_nib_name: self.nibName ?? "")

        tableView.register(UserProfileInfoCell.self, forCellReuseIdentifier: UserProfileInfoCell.reuseIdentifier)
        tableView.register(UserProfileStatsContainerCell.self, forCellReuseIdentifier: UserProfileStatsContainerCell.reuseIdentifier)
        tableView.register(UserProfileActionButtonsCell.self, forCellReuseIdentifier: UserProfileActionButtonsCell.reuseIdentifier)
        tableView.register(UserProfileItemsContainerCell.self, forCellReuseIdentifier: UserProfileItemsContainerCell.reuseIdentifier)
        
        tableView.tableFooterView = UIView()
        
        ref.attributedTitle = NSAttributedString(string: "")
        ref.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(ref) // not required when using UITableViewController

        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier_Other"), object: nil)

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

    
    //MARK: - Selectors
    @objc func handleCart() {
        print("DEBUG:- handleCart")
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
                self.tableView.reloadData()
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
    
//    func fetchUserPosts(forUser user: User) {
//        Service.shared.fetchAllPost(userId: user.id) { items, status, message in
//            if status {
//                guard let allItems = items else { return }
//                self.userPosts = allItems
//            } else {
//
//            }
//        }
//    }
//
//    func fetchPurchasedPosts(forUser user: User) {
//        Service.shared.fetchAllMyPurchases(forUserId: user.id) { allPurchases, status, message in
//            if status {
//                guard let allPurchases = allPurchases else { return }
//                self.allPurchases = allPurchases
//            } else {
//
//            }
//        }
//    }
    
    func fetchUserPosts(forUser user: User, cateId:String) {
        Service.shared.fetchAllPost(userId: user.id, cID: cateId, isRandom: false) { items, status, message in
            if status {
                guard let allItems = items else { return }
                self.userPosts = allItems
                self.tableView.reloadData()
            } else {
                self.userPosts = []
                self.tableView.reloadData()
                self.showAlert(withMsg: "Error occoured while fetching posts.")
            }
        }
    }
    
    func fetchPurchasedPosts(forUser user: User, cateId:String) {
        Service.shared.fetchAllMyPurchases(forUserId: user.id, cID: cateId) { allPurchases, status, message in
            if status {
                guard let allPurchases = allPurchases else { return }
                self.allPurchases = allPurchases
                self.tableView.reloadData()
            } else {
                self.allPurchases = []
                self.tableView.reloadData()
                self.showAlert(withMsg: "Error occoured while fetching purchases.")
            }
        }
    }

    
    //MARK: - Helper Functions
    func configureUI() {
        tableView.backgroundColor = .white
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: messageButton), UIBarButtonItem(customView: cartButton)]
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().tranFormingView(toArabic: self.view)
        } else {
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchCartItems()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return (self.user != nil ? UserProfileSections.allCases.count : 0)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = UserProfileSections(rawValue: indexPath.section)!
        
        switch sectionType {
        case .info:
            let cell = tableView.dequeueReusableCell(withIdentifier: UserProfileInfoCell.reuseIdentifier, for: indexPath) as! UserProfileInfoCell
            cell.delegate = self
            cell.user = user
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
            cell.user = self.user
            if isRefreshUser == true {
                cell.setPageController()
            }
            cell.delegate = self
            cell.productItems.items = userPosts
            cell.purchasedItems.items = allPurchases
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionType = UserProfileSections(rawValue: indexPath.section)!
        
        if sectionType == .info {
            if shouldShowFullBio {
                return UITableView.automaticDimension
            }
        }
        
        if sectionType == .items {
            return 500
            let numberOfItem = userPosts.count / 3
            let cellWidth = (view.frame.width - 3)/3
            let height = 145 + (numberOfItem) + (Int(cellWidth) * (numberOfItem))
            return CGFloat(height)
        } else {
            return sectionType.height
        }
    }
}

//MARK: - Delegate UserProfileInfoCellDelegate
extension UserProfileController: UserProfileInfoCellDelegate {
    func handleOptionsTapped() {
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
}

//MARK: -
extension UserProfileController: UserProfileStatsContainerCellDelegate {
    func didTapProfileStatsOf(_ type: UserProfileStatsCellTypes) {
        guard let user = user else { return }
        if type == .followers || type == .following {
            let controller = FollowContainer(forUser: user, type: type)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension UserProfileController: UserProfileActionButtonsCellDelegate {
    func followTapped(cell: UserProfileActionButtonsCell) {
        guard let user = cell.user else { return }
        if user.followStatus {
            Service.shared.performAction(ofType: .unfollow, onUser: user) {_ in }
        }
        else {
            Service.shared.performAction(ofType: .follow, onUser: user) {_ in }
        }
    }
    
    func messageTapped(cell: UserProfileActionButtonsCell) {
        let obj = UserObject()
        obj.id = self.userId
        openChatBoard(obj)
    }
    
    func openChatBoard(_ objUser:UserObject, _ objChatList : ChatListObject = ChatListObject()) {
        let obj = ChatViewController()
        obj.objUser = objUser
        obj.objChatListObject = objChatList
        obj.hidesBottomBarWhenPushed = true
//        present(obj, animated: true, completion: nil)
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func editProfileTapped(cell: UserProfileActionButtonsCell) {
        print("DEBUG:- handle editProfileTapped")
    }
}


extension UserProfileController: UserProfileItemsContainerCellDelegate {
    func didSelectItem(withId id: String, ofType type: PostType, post: PostItem) {
//        Utility.showHud(view: self.view)
        
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
//        Utility.showHud(view: self.view)
        
        Service.shared.fetchSinglePost(forPostId: id) { item, status, message in
//            Utility.hideHud()
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

