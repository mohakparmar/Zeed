//
//  SettingsController.swift
//  Zeed
//
//  Created by Shrey Gupta on 15/03/21.
//
import UIKit
import JGProgressHUD
import Network

enum SettingsItems: Int, CaseIterable {
    case changeLanguage
//    case aboutUs
//    case termsAndConditions
//    case makePrivate
//    case hideMyPurchase
    case changePassword
    case logout
    case DeleteAccount

    var description: String {
        switch self {
        case .changeLanguage:
            return appDele!.isForArabic ? Change_Language_ar : Change_Language_en
//        case .aboutUs:
//            return appDele!.isForArabic ? About_ar : Account_en
//        case .termsAndConditions:
//            return appDele!.isForArabic ? Terms_and_Conditions_ar : Terms_and_Conditions_en
//        case .makePrivate:
//            return appDele!.isForArabic ? Switch_to_a_private_account_ar : Switch_to_a_private_account_en
//        case .hideMyPurchase:
//            return appDele!.isForArabic ? Hide_my_Purchase_ar : Hide_my_Purchase_en
        case .changePassword:
            return appDele!.isForArabic ? Change_Password_ar : Change_Password_en
        case .logout:
            return appDele!.isForArabic ? Logout_ar : Logout_en
        case .DeleteAccount:
            return appDele!.isForArabic ? Delete_Account_ar : Delete_Account_en
        
        }
    }
    
    var image: UIImage {
        switch self {
        case .changeLanguage:
            return #imageLiteral(resourceName: "translation").withRenderingMode(.alwaysOriginal)
//        case .aboutUs:
//            return #imageLiteral(resourceName: "zeed_logo").withRenderingMode(.alwaysOriginal)
//        case .termsAndConditions:
//            return #imageLiteral(resourceName: "invoice").withRenderingMode(.alwaysOriginal)
//        case .makePrivate:
//            return #imageLiteral(resourceName: "private").withRenderingMode(.alwaysOriginal)
//        case .hideMyPurchase:
//            return #imageLiteral(resourceName: "private").withRenderingMode(.alwaysOriginal)
        case .changePassword:
            if #available(iOS 13.0, *) {
                return #imageLiteral(resourceName: "password").withRenderingMode(.alwaysTemplate).withTintColor(.appColor)
            } else {
                return #imageLiteral(resourceName: "exit").withRenderingMode(.alwaysOriginal)
            }
        case .logout:
            return #imageLiteral(resourceName: "exit").withRenderingMode(.alwaysOriginal)
        case .DeleteAccount:
            return #imageLiteral(resourceName: "exit").withRenderingMode(.alwaysOriginal)
        }
    }
}

class SettingsController: UIViewController {
    //MARK: - Properties
    var collectionView: UICollectionView
    var hud = JGProgressHUD(style: .dark)
    
    //MARK: - Lifecycle
    init() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
        
        title = appDele!.isForArabic ? Settings_ar : Settings_en
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.openScreenView(str_screen_name: "Setting", str_nib_name: self.nibName ?? "")

        configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let tabBarFrame = self.tabBarController?.tabBar.frame {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
                self.tabBarController?.tabBar.frame.origin.y = UIScreen.main.bounds.size.height - tabBarFrame.height
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.tabBarController?.tabBar.frame.origin.y = UIScreen.main.bounds.size.height
        })
    }
    
    //MARK: - Selectors
    
    //MARK: - Helper Functions
    func configureUI() {
        view.backgroundColor = .appBackgroundColor
        collectionView.backgroundColor = .appBackgroundColor
        
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().tranFormingView(toArabic: self.view)
        }
    }
}


extension SettingsController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SettingsItems.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCell.reuseIdentifier, for: indexPath) as! ProfileCell
        let type = SettingsItems(rawValue: indexPath.row)!
        cell.settingsCellType = type
        
//        if type == .makePrivate {
//            if loggedInUser!.isPublic {
//                cell.subCategoryName.text = appDele!.isForArabic ? Switch_to_a_private_account_ar : Switch_to_a_private_account_en
//            } else {
//                cell.subCategoryName.text = "Make Account Public"
//            }
//        }
        
        return cell
    }
}

extension SettingsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 20, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = SettingsItems(rawValue: indexPath.row)!
        
        switch type {
        case .changeLanguage:
            if appDele!.isForArabic == true {
                appDele!.isForArabic = false
                UserDefaults.standard.set("1", forKey: "lang")
            } else {
                appDele!.isForArabic = true
                UserDefaults.standard.set("2", forKey: "lang")
            }
            UserDefaults.standard.synchronize()
            guard let controller = UIApplication.shared.windows.filter({$0.isKeyWindow}).first!.rootViewController as? TabBarController else { return }
            controller.checkIfTheUserIsLoggedIn()
            break
//        case .aboutUs:
//            break
//        case .termsAndConditions:
//            break
//        case .makePrivate:
//            hud.show(in: view, animated: true)
//            Service.shared.setUserPublic(setPublic: !loggedInUser!.isPublic) { (status) in
//                self.hud.dismiss(animated: true)
//                if status {
//                    self.showAlert(withMsg: status.description)
//                    loggedInUser!.isPublic.toggle()
//                    defaults.set(nil, forKey: "USER")
//                    do {
//                        let encoder = JSONEncoder()
//                        let data = try encoder.encode(loggedInUser!)
//                        defaults.set(data, forKey: "USER")
//                        collectionView.reloadData()
//                    }catch{
//                        print("DEBUG:- ERROR OCCOURED WHILE CHANGING LANGUAGE: \(error.localizedDescription)")
//                    }
//                } else {
//                    self.showAlert(withMsg: "Unable to change status.")
//                }
//            }
//        break
//        case .hideMyPurchase:
//            let alert = UIAlertController(title: "Make My Purchase Hidden", message: loggedInUser!.isPurchaseHidden == true ? "Are you sure want to make your purchase unhidden ?" : "Are you sure want to make your purchase hidden ?", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { al in
//                self.hud.show(in: self.view, animated: true)
//                Service.shared.makeMyPurchaseHidden(setHidden: loggedInUser!.isPurchaseHidden == true ? false : true) { status in
//                    self.hud.dismiss(animated: true)
//                    if status {
//                        loggedInUser!.isPurchaseHidden.toggle()
//                        defaults.set(nil, forKey: "USER")
//                        do {
//                            let encoder = JSONEncoder()
//                            let data = try encoder.encode(loggedInUser!)
//                            defaults.set(data, forKey: "USER")
//                            collectionView.reloadData()
//                        }catch{
//                            print("DEBUG:- ERROR OCCOURED WHILE CHANGING LANGUAGE: \(error.localizedDescription)")
//                        }
//                        collectionView.reloadData()
//                        self.showAlert(withMsg: "status updated successfully.")
//                    } else {
//                        self.showAlert(withMsg: "Unable to change status.")
//                    }
//                }
//            }))
//            alert.addAction(UIAlertAction(title: "No", style: .default, handler: { al in
//
//            }))
//            self.present(alert, animated: true, completion: nil)
//        break
        case .changePassword:
            let controller = UINavigationController(rootViewController: ChangePasswordVC())
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        case .logout:
            AppUser.shared.removeDefaultUser()
            guard let controller = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController as? TabBarController else { return }
            controller.checkIfTheUserIsLoggedIn()
        case .DeleteAccount:
//            AppUser.shared.removeDefaultUser()
//            guard let controller = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController as? TabBarController else { return }
//            controller.checkIfTheUserIsLoggedIn()
            
            let alert = UIAlertController(title: "DELETE ACCOUNT", message: "Are you sure want to delete your account?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { al in
                self.hud.show(in: self.view, animated: true)
                Service.shared.deactivateUser(completion: { isStatus, msg in
                    self.hud.dismiss(animated: true)
                    if isStatus {
                        AppUser.shared.removeDefaultUser()
                        guard let controller = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController as? TabBarController else { return }
                        controller.checkIfTheUserIsLoggedIn()
                    } else {
                        self.showAlert(withMsg: msg )
                    }
                })
            }))
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: { al in
                
            }))
            self.present(alert, animated: true, completion: nil)

            break
        }
    }
    


}
