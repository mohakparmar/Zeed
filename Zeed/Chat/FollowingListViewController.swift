//
//  FollowingListViewController.swift
//  FFlash
//
//  Created by hemant agarwal on 25/02/20.
//  Copyright © 2020 hemant agarwal. All rights reserved.
//

import UIKit

protocol FollowingControllerDelegate {
    func sendUserWithType(object:UserObject, arrForGroup:[UserObject], SelectionType: Int)
}

class FollowingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    private lazy var startNewChat: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitle("Done", for: .normal)
        button.setDimensions(height: 19, width: 60)
        button.addTarget(self, action: #selector(handlePlus), for: .touchUpInside)
        button.tintColor = .appPrimaryColor
        return button
    }()

    //MARK: - Selectors
    @objc func handlePlus() {
        self.navigationController?.popViewController(animated: false)
        var arrSelected:[UserObject] = []
        for obj in arrForUsers {
            if obj.isSelectedForGroup {
                arrSelected.append(obj)
            }
        }
        self.delegate?.sendUserWithType(object: UserObject(), arrForGroup: arrSelected, SelectionType: type)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tblUser.registerNib(nibName: "ChatListTCell")
        WSForGetFollowUserList()

        
        if type == 1 {
            configureNavigationBar(largeTitleColor: .appPrimaryColor, backgoundColor: .appBackgroundColor, tintColor: .appPrimaryColor, title: "START CHAT", preferredLargeTitle: true)
            Utility.openScreenView(str_screen_name: "Chat_User_List", str_nib_name: self.nibName ?? "")
        } else if type == 2 {
            configureNavigationBar(largeTitleColor: .appPrimaryColor, backgoundColor: .appBackgroundColor, tintColor: .appPrimaryColor, title: "FOLLOWER", preferredLargeTitle: true)
            Utility.openScreenView(str_screen_name: "Follower_List", str_nib_name: self.nibName ?? "")
        }
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: startNewChat)]

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        appDele?.tabBarController?.tabBar.isHidden = true
        self.edgesForExtendedLayout = .bottom
        self.extendedLayoutIncludesOpaqueBars = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //        appDele?.tabBarController?.tabBar.isHidden = false
    }
    
    
    // MARK: - Tableview Delegate and Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ChatListTCell = tblUser.dequeueReusableCell(withIdentifier: "cell") as! ChatListTCell
        
        let obj = arrForUsers[indexPath.row]
        
        cell.imgView.setUserImageUsingUrl(obj.objImage.url)
        cell.imgView.contentMode = .scaleAspectFill
        
        cell.lblID.text = obj.username
        cell.lblTime.isHidden = true
        cell.imgCheck.isHidden = true
        if type == 0 {
            
        } else if type == 1 {
            cell.imgCheck.image = UIImage(named: obj.isSelectedForGroup ?  "check1" : "uncheck")
            cell.imgCheck.isHidden = false
            cell.imgView.tintColor = .appPrimaryColor
        }
        
        cell.imgView.setBorder(colour: applicationMainColor, alpha: 1.0, radius: cell.imgView.viewHeightBy2, borderWidth: 1.0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type == 0 || type == 2 {
            let obj = OtherProfileVC()
            obj.userId = arrForUsers[indexPath.row].id
//            let obj = UserProfileController(forUserId: arrForUsers[indexPath.row].id)
            self.navigationController?.pushViewController(obj, animated: true)
        } else {
            for item in arrForUsers {
                item.isSelectedForGroup = false
            }
            let obj = arrForUsers[indexPath.row]
            obj.isSelectedForGroup = !obj.isSelectedForGroup
            tblUser.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // MARK: - WSCalls
    func WSForGetFollowUserList() {
        var params: Dictionary<String, String> = [:]
        params["startRange"] = "0"
        params["count"] = "1000"
        params["userId"] = loggedInUser?.id ?? ""
        
        
        var serviceName : String = ""
        if type == 0 {
            params["type"] = "following"
            serviceName = WSManage.WSForGetFollowerList
        } else if type == 1 {
            params["type"] = "following"
            serviceName = WSManage.WSForGetFollowerList
        } else if type == 2 {
            params["type"] = "follower"
            serviceName = WSManage.WSForGetFollowerList
        }
        
        if strUserId.checkEmpty() == false {
            params["userId"] = strUserId
        }
        
        Utility.showHud(view: self.view)
        WSManage.getDataWithGetServiceWithParams(name: serviceName, parameters: params, isPost: true) { (isSuccess, dict) in
            Utility.hideHud()
            print(dict)
            self.arrForUsers = []
            if let str = dict?["status"] as? Int {
                if str == 1 {
                    if let arrData = dict?["data"] as? [[String:AnyObject]] {
                        for item in arrData {
                            let obj = UserObject(dict: item)
                            var isAvailableInGroup = false
                            for objUser in self.arrForSelectedUsers {
                                if obj.id == objUser.id {
                                    isAvailableInGroup = true
                                }
                            }
                            if isAvailableInGroup == false {
                                self.arrForUsers.append(obj)
                            }
                        }
                    }
                    self.tblUser.reloadData()
                } else if str == 0 {
                    
                }
            }
        }
    }
    
    @IBOutlet weak var tblUser: UITableView!
    var arrForUsers:[UserObject] = []
    var arrForSelectedUsers:[UserObject] = []
    
    var type:Int = 0
    var delegate : FollowingControllerDelegate? = nil
    var strUserId:String = ""
    
}
