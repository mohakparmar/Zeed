//
//  ProfileBuyerView.swift
//  Zeed
//
//  Created by Shrey Gupta on 15/03/21.
//
import UIKit
import ZendeskSDKMessaging
import ZendeskSDK

protocol ProfileBuyerControllerDelegate: AnyObject {
    func profileBuyer(_ profileBuyerController: ProfileBuyerViewController, didSelectController controller: UIViewController)
}

enum ProfileBuyerItems: Int, CaseIterable {
    case myOrders
    case myBidding
    case wallet
    case myAddresses
    case viewed
    case liked
    case interest
    case Privacy
    case requestVerification
    case addNewProduct
    case Support
    case settings
    
    var description: String {
        switch self {
        case .wallet:
            return appDele!.isForArabic ? Wallet_ar : Wallet_en
        case .addNewProduct:
            if let loggedInUser = AppUser.shared.getDefaultUser() {
                if loggedInUser.isSeller {
                    return appDele!.isForArabic ? add_new_post_ar : add_new_post_en
                } else {
                    return appDele!.isForArabic ? Become_a_Seller_ar : Become_a_Seller_en
                }
            } else {
                return ""
            }
        case .myBidding:
            return appDele!.isForArabic ? My_Biddings_ar : My_Biddings_en
        case .myOrders:
            return appDele!.isForArabic ? My_Orders_ar : My_Orders_en
        case .myAddresses:
            return appDele!.isForArabic ? Addresses_ar : Addresses_en
        case .viewed:
            return appDele!.isForArabic ? Viewed_ar : Viewed_en
        case .liked:
            return appDele!.isForArabic ? Liked_ar : Liked_en
        case .interest:
            return appDele!.isForArabic ? Interests_ar : Interests_en
        case .requestVerification:
            return appDele!.isForArabic ? Request_Verification_ar : Request_Verification_en
        case .settings:
            return appDele!.isForArabic ? Settings_ar : Settings_en
        case .Privacy:
            return appDele!.isForArabic ? Privacy_ar : Privacy_en
        case .Support:
            return appDele!.isForArabic ? Support_ar : Support_en
        }
    }
    
    var image: UIImage {
        switch self {
        case .wallet:
            return #imageLiteral(resourceName: "wallet").withRenderingMode(.alwaysOriginal)
        case .addNewProduct:
            return #imageLiteral(resourceName: "wallet").withRenderingMode(.alwaysOriginal)
        case .myBidding:
            return #imageLiteral(resourceName: "auction").withRenderingMode(.alwaysOriginal)
        case .myOrders:
            return #imageLiteral(resourceName: "invoice").withRenderingMode(.alwaysOriginal)
        case .viewed:
            return #imageLiteral(resourceName: "eye").withRenderingMode(.alwaysOriginal)
        case .liked:
            return #imageLiteral(resourceName: "like").withRenderingMode(.alwaysOriginal)
        case .interest:
            return #imageLiteral(resourceName: "invoice").withRenderingMode(.alwaysOriginal)
        case .settings:
            return #imageLiteral(resourceName: "settings").withRenderingMode(.alwaysOriginal)
        case .Privacy:
            return #imageLiteral(resourceName: "privacy_icon").withRenderingMode(.alwaysOriginal)
        case .requestVerification:
            return #imageLiteral(resourceName: "tick_verified").withRenderingMode(.alwaysOriginal)
        case .myAddresses:
            return #imageLiteral(resourceName: "address").withRenderingMode(.alwaysTemplate)
        case .Support:
            return #imageLiteral(resourceName: "settings").withRenderingMode(.alwaysOriginal)
        }
    }
}

class ProfileBuyerViewController: UIViewController {
    //MARK: - Properties
    weak var delegate: ProfileBuyerControllerDelegate?
    var collectionView: UICollectionView
    
    //MARK: - Lifecycle
    init() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
        
        let currentUser = AppUser.shared.getDefaultUser()
        if currentUser?.isSeller ?? false == false  {
            title = ""
        } else {
            title = appDele!.isForArabic ? Buyer_ar : Buyer_en
        }
        
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.alwaysBounceVertical = true
        
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utility.openScreenView(str_screen_name: "Profile_Buyer", str_nib_name: self.nibName ?? "")

        configureUI()
        addObservers()
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        removeObservers()
    }
    
    //MARK: - Selectors
    fileprivate  func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
    fileprivate  func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc fileprivate func applicationDidBecomeActive() {
        fetchUser()
    }
    
    func fetchUser() {
        guard let loggedUser = loggedInUser else { return }
        Service.shared.getUserData(forUserId: loggedUser.id) { (user, status, message) in
            if status {
                guard let user = user else { return }
                guard var currentUser = AppUser.shared.getDefaultUser() else { return }
                currentUser.isSeller = user.isSeller
                let _ = AppUser.shared.setDefaultUser(user: currentUser)
            }
        }
    }

    
    //MARK: - Helper Functions
    func configureUI() {
        view.backgroundColor = .appBackgroundColor
        collectionView.backgroundColor = .appBackgroundColor
        
        view.addSubview(collectionView)
        collectionView.fillSuperview()
    }
}


extension ProfileBuyerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileBuyerItems.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCell.reuseIdentifier, for: indexPath) as! ProfileCell
        let type = ProfileBuyerItems(rawValue: indexPath.row)!
        cell.profileCellType = type
        return cell
    }
}

extension ProfileBuyerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 20, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = ProfileBuyerItems(rawValue: indexPath.row)!
        
        switch type {
        case .wallet:
            delegate?.profileBuyer(self, didSelectController: WalletController())
        case .addNewProduct:
            if let loggedInUser = AppUser.shared.getDefaultUser() {
                if loggedInUser.isSeller {
                    let obj = CreateController()
                    obj.hidesBottomBarWhenPushed = true
                    delegate?.profileBuyer(self, didSelectController: obj)
                } else {
                    guard let url = URL(string: "https://www.zeedco.co/") else {
                        return
                    }
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                    
                    //                    let obj = BecomeSellerController()
                    //                    obj.hidesBottomBarWhenPushed = true
                    //                    obj.delegate = self
                    //                    delegate?.profileBuyer(self, didSelectController: obj)
                }
            }
        case .Privacy:
            delegate?.profileBuyer(self, didSelectController: PrivacyListViewController())
        case .myBidding:
            delegate?.profileBuyer(self, didSelectController: MyBiddingController())
        case .myOrders:
            delegate?.profileBuyer(self, didSelectController: MyOrderController())
        case .viewed:
            delegate?.profileBuyer(self, didSelectController: LikedViewedController(type: .viewed))
        case .interest:
            let obj = SelectIntrestViewController()
            obj.isFromProfile = true
            delegate?.profileBuyer(self, didSelectController: obj)
        case .liked:
            delegate?.profileBuyer(self, didSelectController: LikedViewedController(type: .liked))
        case .settings:
            delegate?.profileBuyer(self, didSelectController: SettingsController())
        case .myAddresses:
            delegate?.profileBuyer(self, didSelectController: MyAddressVC())
        case .Support:
            delegate?.profileBuyer(self, didSelectController: SupportViewController())
            
            //            Zendesk.initialize(withChannelKey: "eyJzZXR0aW5nc191cmwiOiJodHRwczovL3plZWQ3MDgzLnplbmRlc2suY29tL21vYmlsZV9zZGtfYXBpL3NldHRpbmdzLzAxR1FGRlFBWjIxMDJCV1ZCV0NaWDVGSjZNLmpzb24ifQ==",
            //                               messagingFactory: DefaultMessagingFactory()) { result in
            //                    if case let .failure(error) = result {
            //                        print("Messaging did not initialize.\nError: \(error.localizedDescription)")
            //                    } else {
            //                        DispatchQueue.main.async {
            //                            guard let viewController = Zendesk.instance?.messaging?.messagingViewController() else { return }
            //                            self.navigationController?.show(viewController, sender: self)
            //                        }
            //                    }
            //                }
        case .requestVerification:
            let str = String(format: appDele!.isForArabic ? "نحن بصدد دراسة طلب توثيق حسابك بكل عناية وسيتم تحديد ما اذا كانت معايير التوثيق تنطبق على حسابك." : "We are currently in the process of reviewing your verification request with care and will determine if you meet the necessary criteria for verification.")

//            let str = String(format: "Your account will be reviewed based on the details you have entered in below section.\n\n1.User Profile\n2.No of follower on your account. \n\nIf all the details available in your account meet our requirement criteria then you will receive a notification of approval.")
//            let str = String(format: "Your account will be reviewed based on the details you have entered in below section.\n\n1.User Profile\n2.No of follower on your account. \n\nIf all the details available in your account meet our requirement criteria then you will receive a notification of approval.")

            let alert = UIAlertController(title: "Request Account for verification", message: str, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { alert in
                Service.shared.accountVerificationRequest { isSuccess in
                    Utility.showISMessage(str_title: "Success", Message: "Request submitted successfully.", msgtype: .success)
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { alert in
                
            }))
            self.present(alert, animated: true, completion: nil)
            break
        }
    }
}

extension ProfileBuyerViewController : BecomeSellerDelegate {
    func successBecomeASeller() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            let obj = CreateController()
            self.navigationController?.pushViewController(obj, animated: true)
        })
    }
}
