//
//  PrivacyListViewController.swift
//  Zeed
//
//  Created by Mohak Parmar on 21/01/23.
//

import UIKit
import JGProgressHUD
import Network

enum PrivacyItems: Int, CaseIterable {
//    case termsAndConditions
    case makePrivate
    case hideMyPurchase
    
    var description: String {
        switch self {
//        case .termsAndConditions:
//            return appDele!.isForArabic ? Terms_and_Conditions_ar : Terms_and_Conditions_en
        case .makePrivate:
            return appDele!.isForArabic ? Switch_to_a_private_account_ar : Switch_to_a_private_account_en
        case .hideMyPurchase:
            return appDele!.isForArabic ? Hide_my_Purchase_ar : Hide_my_Purchase_en
        }
    }
    
    var image: UIImage {
        switch self {
//        case .termsAndConditions:
//            return #imageLiteral(resourceName: "invoice").withRenderingMode(.alwaysOriginal)
        case .makePrivate:
            return #imageLiteral(resourceName: "private").withRenderingMode(.alwaysOriginal)
        case .hideMyPurchase:
            return #imageLiteral(resourceName: "private").withRenderingMode(.alwaysOriginal)
        }
    }
}

class PrivacyListViewController: UIViewController {
    //MARK: - Properties
    var collectionView: UICollectionView
    var hud = JGProgressHUD(style: .dark)
    
    //MARK: - Lifecycle
    init() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
        
        title = appDele!.isForArabic ? Privacy_ar : Privacy_en
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.openScreenView(str_screen_name: "Privacy_View", str_nib_name: self.nibName ?? "")
        
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


extension PrivacyListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PrivacyItems.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCell.reuseIdentifier, for: indexPath) as! ProfileCell
        let type = PrivacyItems(rawValue: indexPath.row)!
        cell.privacyCellType = type
        
        cell.swich.isHidden = true
        if type == .makePrivate {
            cell.swich.isHidden = false
            cell.subCategoryName.text = appDele!.isForArabic ? "حساب خاص" : "Private Account"
            cell.swich.setOn((loggedInUser!.isPublic) ? false : true, animated: false)
//            if loggedInUser!.isPublic {
//                cell.subCategoryName.text = appDele!.isForArabic ? Switch_to_a_private_account_ar : Switch_to_a_private_account_en
//            } else {
//                cell.subCategoryName.text = "Make Account Public"
//            }
        } else if type == .hideMyPurchase  {
            cell.swich.isHidden = false
            cell.subCategoryName.text = appDele!.isForArabic ?  "لي فقط" : "Only Me"
            cell.swich.setOn((loggedInUser!.isPurchaseHidden) ? true : false, animated: false)

//            if loggedInUser!.isPurchaseHidden {
//                cell.subCategoryName.text = "Show My Purchase"
//            } else {
//                cell.subCategoryName.text = "Hide My Purchase"
//            }
        }
        
        return cell
    }
}

extension PrivacyListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 20, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = PrivacyItems(rawValue: indexPath.row)!
        
        switch type {
        case .makePrivate:
            
            
            var title = ""
            var message = ""
            var btnText = ""
            if loggedInUser!.isPublic == false {
                if appDele!.isForArabic {
                    title = "حساب خاص"
                    title = "تحويل حسابك الى عام؟"
                    btnText = "تحويل حسابك الى عام"
                    message = """
                    1. سيتم عرض مشترياتك ليراها الجميع!
                    2. يمكنك اختيار المشتريات التي تريد اخفاءها بشكل منفصل.
                    """
                } else {
                    title = "Private Account"
                    title = "Switch to Public Account?"
                    btnText = "Switch to Public Account"
                    message = """
                    1. Your purchases will be displayed for everyone to see!
                    2. You can choose to hide or unhide your purchases individually.
                    """
                }
            } else {
                if appDele!.isForArabic {
                    title = "حساب خاص"
                    title = "تحويل حسابك الى خاص؟"
                    btnText = "تحويل حسابك الى خاص"
                    message = """
                    1. سيتم اخفاء جميع مشترياتك عن الحسابات التي لا تتابعك، ولكن سيتم عرض مشترياتك لمتابعيك.
                    2. لا زال بإمكانك اخفاء المشترى الذي تريد حتى عن متابعيك.
                    """
                } else {
                    title = "Private Account"
                    title = "Switch to Private Account?"
                    btnText = "Switch to Private Account"
                    message = """
                    1. All your purchases will be hidden from non-followers but will be displayed for your followers to see.
                    2. You can choose to hide your individual purchases from your followers too!
                    """
                }
            }
            
            let viewAlert = PrivacyAlertView.instantiate(title: title, alertText: message, btnName: btnText, frame: UIScreen.main.bounds)
            viewAlert.btnHideClick = {
                viewAlert.removeFromSuperview()
            }
            viewAlert.btnPublicClick = {
                self.hud.show(in: self.view, animated: true)
                Service.shared.setUserPublic(setPublic: !loggedInUser!.isPublic) { (status) in
                    self.hud.dismiss(animated: true)
                    if status {
                        //                    self.showAlert(withMsg: status.description)
                        loggedInUser!.isPublic.toggle()
                        defaults.set(nil, forKey: "USER")
                        do {
                            let encoder = JSONEncoder()
                            let data = try encoder.encode(loggedInUser!)
                            defaults.set(data, forKey: "USER")
                            collectionView.reloadData()
                            viewAlert.removeFromSuperview()
                        }catch{
                            print("DEBUG:- ERROR OCCOURED WHILE CHANGING LANGUAGE: \(error.localizedDescription)")
                        }
                    } else {
                        self.showAlert(withMsg: "Unable to change status.")
                        viewAlert.removeFromSuperview()
                    }
                }
            }
            self.view.addSubview(viewAlert)
            break
            
            
            let alert = UIAlertController(title:  title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { al in
                self.hud.show(in: self.view, animated: true)
                Service.shared.setUserPublic(setPublic: !loggedInUser!.isPublic) { (status) in
                    self.hud.dismiss(animated: true)
                    if status {
                        //                    self.showAlert(withMsg: status.description)
                        loggedInUser!.isPublic.toggle()
                        defaults.set(nil, forKey: "USER")
                        do {
                            let encoder = JSONEncoder()
                            let data = try encoder.encode(loggedInUser!)
                            defaults.set(data, forKey: "USER")
                            collectionView.reloadData()
                        }catch{
                            print("DEBUG:- ERROR OCCOURED WHILE CHANGING LANGUAGE: \(error.localizedDescription)")
                        }
                    } else {
                        self.showAlert(withMsg: "Unable to change status.")
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: { al in
                
            }))
            self.present(alert, animated: true, completion: nil)


            break
        case .hideMyPurchase:
            
            var title = ""
            var message = ""
            var btnText = ""
            if loggedInUser!.isPurchaseHidden == true {
                if appDele!.isForArabic {
                    title = "لي فقط - Toggle OFF"
                    title = "إلغاء تفعيل خاصية \"لي فقط\"؟"
                    btnText = "إلغاء تفعيل خاصية لي فقط"
                    message = """
                    1. ان كان وضع الحساب الخاص غير مفعّل، سيتم عرض مشترياتك ليراها الجميع.
                    2. ان كان وضع الحساب الخاص مفعّل، سيتم عرض مشترياتك ليراها متابعيك فقط.
                    3. لا زال بإمكانك اختيار المشتريات التي تريد اخفاءها بشكل منفصل.
                    """
                } else {
                    title = "Only Me - Toggle OFF"
                    title = "Deactivate \"Only Me\" Mode?"
                    btnText = "Deactivate \"Only Me\" Mode"
                    message = """
                    1. If your “private account” status is off, your purchases will be displayed for everyone to see.
                    2. If your “private account” status is on, your purchases will be displayed only for your followers to see.
                    3. You can still choose to hide or unhide your purchases individually.
                    """
                }
            } else {
                if appDele!.isForArabic {
                    title = "لي فقط"
                    title = "تفعيل خاصية \"لي فقط\"؟"
                    btnText = "بدّل أنا فقط إلى الخاص"
                    message = "1. سيتم اخفاء مشترياتك عن جميع الحسابات، سواءً كانت تتابعك ام لا."
                } else {
                    title = "Only Me"
                    btnText = "Switch Only Me to Private"
                    title = "Activate \"Only Me\" Mode?"
                    message = "1. All your purchases will be hidden from everyone and can only be seen by you."
                }
            }
            
            let viewAlert = PrivacyAlertView.instantiate(title: title, alertText: message, btnName: btnText, frame: UIScreen.main.bounds)
            viewAlert.btnHideClick = {
                viewAlert.removeFromSuperview()
            }
            viewAlert.btnPublicClick = {
                self.hud.show(in: self.view, animated: true)
                Service.shared.makeMyPurchaseHidden(setHidden: loggedInUser!.isPurchaseHidden == true ? false : true) { status in
                    self.hud.dismiss(animated: true)
                    if status {
                        loggedInUser!.isPurchaseHidden.toggle()
                        defaults.set(nil, forKey: "USER")
                        viewAlert.removeFromSuperview()
                        do {
                            let encoder = JSONEncoder()
                            let data = try encoder.encode(loggedInUser!)
                            defaults.set(data, forKey: "USER")
                            collectionView.reloadData()
                            if loggedInUser!.isPurchaseHidden == true {
                                self.callPrivateAccountSettingApi()
                            }
                        }catch{
                            print("DEBUG:- ERROR OCCOURED WHILE CHANGING LANGUAGE: \(error.localizedDescription)")
                        }
                        collectionView.reloadData()
                        self.showAlert(withMsg: "status updated successfully.")
                    } else {
                        viewAlert.removeFromSuperview()
                        self.showAlert(withMsg: "Unable to change status.")
                    }
                }
            }
            self.view.addSubview(viewAlert)
            break

            
            
            let alert = UIAlertController(title:  title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { al in
                self.hud.show(in: self.view, animated: true)
                Service.shared.makeMyPurchaseHidden(setHidden: loggedInUser!.isPurchaseHidden == true ? false : true) { status in
                    self.hud.dismiss(animated: true)
                    if status {
                        loggedInUser!.isPurchaseHidden.toggle()
                        defaults.set(nil, forKey: "USER")
                        do {
                            let encoder = JSONEncoder()
                            let data = try encoder.encode(loggedInUser!)
                            defaults.set(data, forKey: "USER")
                            collectionView.reloadData()
                        }catch{
                            print("DEBUG:- ERROR OCCOURED WHILE CHANGING LANGUAGE: \(error.localizedDescription)")
                        }
                        collectionView.reloadData()
                        self.showAlert(withMsg: "status updated successfully.")
                    } else {
                        self.showAlert(withMsg: "Unable to change status.")
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: { al in
                
            }))
            self.present(alert, animated: true, completion: nil)
            break
//        case .termsAndConditions:
//            break
        }
    }
    
    func callPrivateAccountSettingApi( ) {
        if loggedInUser!.isPublic == false {
            return
        }
        self.hud.show(in: self.view, animated: true)
        Service.shared.setUserPublic(setPublic: !loggedInUser!.isPublic) { (status) in
            self.hud.dismiss(animated: true)
            if status {
                //                    self.showAlert(withMsg: status.description)
                loggedInUser!.isPublic.toggle()
                defaults.set(nil, forKey: "USER")
                do {
                    let encoder = JSONEncoder()
                    let data = try encoder.encode(loggedInUser!)
                    defaults.set(data, forKey: "USER")
                    self.collectionView.reloadData()
                }catch{
                    print("DEBUG:- ERROR OCCOURED WHILE CHANGING LANGUAGE: \(error.localizedDescription)")
                }
            }
        }
    }
}
