////
////  SettingViewController.swift
////  FFlash
////
////  Created by hemant agarwal on 17/02/20.
////  Copyright © 2020 hemant agarwal. All rights reserved.
////
//
//import UIKit
//
//class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//
//
//    // MARK: - View Related Methods
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.edgesForExtendedLayout = []
//        
//        if appDele!.isForBiddingVersion {
//            arrForNotification = [
//                SettingObject(text: "Notification", img: "", tag: 1),
//             //   SettingObject(text: "Public Profile", img: "", tag: 2),
//                SettingObject(text: "Edit Profile", img: "", tag: 3),
//              //  SettingObject(text: "Packages", img: "", tag: 4),
//                SettingObject(text: "Block User", img: "", tag: 11),
//                SettingObject(text: "Privacy & Security", img: "", tag: 5),
//                SettingObject(text: "Change Password", img: "", tag: 6),
//                SettingObject(text: "Change to Business", img: "", tag: 7),
//                SettingObject(text: "Terms & Condition", img: "", tag: 8),
//                SettingObject(text: "Privacy Policy", img: "", tag: 9),
//                SettingObject(text: "Log Out", img: "", tag: 10)]
//        }
//        
//        tblSetting.registerNib(nibName: "SelectionTCell")
//        self.navigationController?.navigationBar.isHidden = true
//        // Do any additional setup after loading the view.
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//
//    }
//    
//    @IBAction func btnBackClick(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
//    }
//    
//    // MARK: - Tableview Delegate and Data Source
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return arrForNotification.count
//    }
//    
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell:SelectionTCell = tblSetting.dequeueReusableCell(withIdentifier: "cell") as! SelectionTCell
//        
//        let obj = arrForNotification[indexPath.row]
//        
//        cell.lblTitle.text = obj.str_title
//        
//        cell.imgRound.setRadius(radius: cell.imgRound.viewHeightBy2)
//        
//        cell.imgSwitch.isHidden = obj.tagForItem == 2 ? false : true
//        cell.imgSwitch.image = UIImage.init(named: appDele?.objUser.public1 == "0" ? "off" : "on")
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        let obj = arrForNotification[indexPath.row]
//        
//        switch obj.tagForItem {
//        case 1:
//            self.navigationController?.pushViewController(NotificationStatusViewController(), animated: true)
//            break
//        case 2:
//            let cell = tblSetting.cellForRow(at: indexPath) as! SelectionTCell
//            if cell.imgSwitch.image!.isEqualToImage(image: UIImage.init(named: "on")!) {
//                cell.imgSwitch.image = UIImage.init(named: "off")
//                ChangeStatus(strStatus: 0)
//                appDele?.objUser.public1 = "0"
//            } else {
//                cell.imgSwitch.image = UIImage.init(named: "on")
//                ChangeStatus(strStatus: 1)
//                appDele?.objUser.public1 = "1"
//            }
//            break
//        case 3:
//            let obj = ProfileViewController()
//            obj.isForProfile = true
//            self.navigationController?.pushViewController(obj, animated: true)
//            break
//        case 4:
//            self.navigationController?.pushViewController(PackageViewController(), animated: true)
//            break
//        case 5:
//            let obj = TermsViewController()
//            obj.type = 2
//            self.navigationController?.pushViewController(obj, animated: true)
//            break
//        case 6:
//            self.navigationController?.pushViewController(ChangePasswordViewController(), animated: true)
//            break
//        case 7:
//            self.navigationController?.pushViewController(ChangesToBusinessViewController(), animated: true)
//            break
//        case 8:
//            let obj = TermsViewController()
//            self.navigationController?.pushViewController(obj, animated: true)
//            break
//        case 9:
//            let obj = TermsViewController()
//            obj.type = 3
//            self.navigationController?.pushViewController(obj, animated: true)
//            break
//        case 10:
//            logOut()
//            break
//        case 11:
//            let obj = UserListViewController()
//            obj.isFor = 2
//            self.navigationController?.pushViewController(obj, animated: true)
//            break
//        default:
//            break
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }
//    
//    // MARK: - Logout Alert
//    func logOut()  {
//        let alert = UIAlertController(title: "Logout", message: "Are you sure want to logout ?", preferredStyle: .alert)
//        
//        let ok = UIAlertAction(title: "Logout", style: .default, handler: { action in
//            AppUserObject.removeAllUsersData()
//            appDele?.showLoginview()
//            
//        })
//        alert.addAction(ok)
//        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
//            
//        })
//        alert.addAction(cancel)
//        DispatchQueue.main.async(execute: {
//            self.present(alert, animated: true)
//        })
//    }
//    
//    func ChangeStatus(strStatus:Int) {
//        
//        var params: Dictionary <String, Any> = [:]
//        params["status"] = strStatus
//
//        Utility.showHud(view: self.view)
//        WSManage.getDataWithGetServiceWithParams(name: WSManage.WSUsrSetPublic, parameters: params, isPost: true) { (isSuccess, dict) in
//            Utility.hideHud()
//            print(dict)
//            if let str = dict?["status"] as? Int {
//                if str == 1 {
//                    AppUserObject.updatePublicValue(strStatus: strStatus)
//                    Utility.showISMessage(str_title: "Your rofile status has been changed successfully.", Message: "", msgtype: 0)
//                } else if str == 0 {
//                    Utility.showISMessage(str_title: "Somethign went wrong, please try again after sometime.", Message: "", msgtype: 2)
//                }
//            }
//        }
//    }
//
//    
//    // MARK: - Variables and Other Declarations
//    @IBOutlet weak var viewNav: UIView!
//    @IBOutlet weak var lblTitle: UILabel!
//    
//    @IBOutlet weak var tblSetting: UITableView!
//    var arrForNotification:[SettingObject] = [
//        SettingObject(text: "Notification", img: "", tag: 1),
//     //   SettingObject(text: "Public Profile", img: "", tag: 2),
//        SettingObject(text: "Edit Profile", img: "", tag: 3),
//      //  SettingObject(text: "Packages", img: "", tag: 4),
//        SettingObject(text: "Block User", img: "", tag: 11),
//        SettingObject(text: "Privacy & Security", img: "", tag: 5),
//        SettingObject(text: "Change Password", img: "", tag: 6),
//        SettingObject(text: "Change to Business", img: "", tag: 7),
//        SettingObject(text: "Terms & Condition", img: "", tag: 8),
//        SettingObject(text: "Privacy Policy", img: "", tag: 9),
//        SettingObject(text: "Log Out", img: "", tag: 10)]
//
//    @IBOutlet weak var btnBack: UIButton!
//    
//}
