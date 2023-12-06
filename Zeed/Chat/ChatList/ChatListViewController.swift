//
//  ChatListViewController.swift
//  FFlash
//
//  Created by hemant agarwal on 24/02/20.
//  Copyright © 2020 hemant agarwal. All rights reserved.
//

import UIKit
import SocketIO
import Foundation

class ChatListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FollowingControllerDelegate {
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(#imageLiteral(resourceName: "cross"), for: .normal)
        button.setDimensions(height: 19, width: 19)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        button.tintColor = .appPrimaryColor
        return button
    }()
    
    private lazy var startNewChat: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(named: "plus_icon"), for: .normal)
        button.setDimensions(height: 19, width: 19)
        button.addTarget(self, action: #selector(handlePlus), for: .touchUpInside)
        button.tintColor = .appPrimaryColor
        return button
    }()
    
    var isForChatUser : Bool = false
    var user : UserObject?

    override func viewDidLoad() {
        super.viewDidLoad()
        tblUser.registerNib(nibName: "ChatListTCell")
        Utility.openScreenView(str_screen_name: "Chat_List", str_nib_name: self.nibName ?? "")

        //        tblUser.register(ChatListTCell.self, forCellReuseIdentifier: ChatListTCell.reuseIdentifier)
        connectSocket()
        
        configureNavigationBar(largeTitleColor: .appPrimaryColor, backgoundColor: .appBackgroundColor, tintColor: .appPrimaryColor, title: "Chat", preferredLargeTitle: false)
        
        navigationItem.title = appDele!.isForArabic ? Messages_ar : Messages_en
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: cancelButton)]
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: startNewChat)]
        
        if isForChatUser == true {
            let obj = ChatViewController()
            obj.objUser = user!
            self.navigationController?.pushViewController(obj, animated: true)
        }

        if appDele!.isForArabic == true {
            ConvertArabicViews.init().tranFormingView(toArabic: self.view)
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.WSForGetChatUserList()
        self.edgesForExtendedLayout = .bottom
        self.extendedLayoutIncludesOpaqueBars = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    func connectSocket() {
        let socket = SocketService.shared.socket
        
        socket.on("typing") {data, ack in
            if let arr = data as?  [[String:AnyObject]] {
                for item in arr {
                    let objChat = ChatObject(dict: item)
                    let filteredArray = self.arrForUsers.filter({$0.objUser.id == objChat.UserId})
                    for obj in filteredArray {
                        obj.objUser.isTyping = true
                    }
                    self.tblUser.reloadData()
                    print(filteredArray)
                }
            }
        }
        
        socket.on("stop typing") {data, ack in
            if let arr = data as?  [[String:AnyObject]] {
                for item in arr {
                    let objChat = ChatObject(dict: item)
                    let filteredArray = self.arrForUsers.filter({$0.objUser.id == objChat.UserId})
                    for obj in filteredArray {
                        obj.objUser.isTyping = false
                    }
                    self.tblUser.reloadData()
                    print(filteredArray)
                }
            }
        }
        
        socket.on("new message") {data, ack in
            print(data)
            if let arr = data as?  [[String:AnyObject]] {
                self.checkCurrentUserObject(arrData: arr, op: 1)
            }
        }
    }
    
    func checkCurrentUserObject(arrData:[[String:AnyObject]], op:Int) {
        for item in arrData {
            let objChat = ChatObject(dict: item)
            let filteredArray = self.arrForUsers.filter({$0.objUser.id == objChat.UserId})
            for obj in filteredArray {
                if let currentUser = AppUser.shared.getDefaultUser() {
                    if objChat.targetUserId == currentUser.id || objChat.targetGroupId == obj.objUser.id {
                        obj.objChat = objChat
                        self.tblUser.reloadData()
                    }
                }
            }
        }
    }
    
    //MARK: - Selectors
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Selectors
    @objc func handlePlus() {
        let obj = FollowingListViewController()
        obj.type = 1
        obj.delegate = self
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func sendUserWithType(object: UserObject, arrForGroup: [UserObject], SelectionType: Int) {
        if arrForGroup.count > 1 {
            let group = GroupViewController()
            group.arrForUsers = arrForGroup
            self.navigationController?.pushViewController(group, animated: false)
        } else if arrForGroup.count == 1 {
            openChatBoard(arrForGroup[0])
        }
    }
    
    // MARK: - Tableview Delegate and Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ChatListTCell = tblUser.dequeueReusableCell(withIdentifier: reuseIdentifier1) as! ChatListTCell
        
        let obj = arrForUsers[indexPath.row]
        
        cell.lblCount.isHidden = false
        cell.lblCount.setRadius(radius: cell.lblCount.viewHeightBy2)
        
        if obj.anonymous == "1" {
            cell.imgView.image = UIImage(named: "userPlaceHolder")
            cell.lblID.text = "Anonymous"
        } else {
            cell.imgView.setUserImageUsingUrl(obj.objUser.objImage.url)
            cell.lblID.text = obj.objUser.username
        }
        
        if obj.unSeen.floatValue > 0 {
            cell.lblCount.text = obj.unSeen
            cell.lblCount.isHidden = false
        } else {
            cell.lblCount.isHidden = true
        }
        
        if obj.objUser.isTyping {
            cell.lblMsg.text = "Typing..."
            cell.lblMsg.textColor = .appColor
        } else {
            cell.lblMsg.text = obj.objChat.typeOfMessage == "1" ? obj.objChat.text : "Video/Image/Audio"
            cell.lblMsg.textColor = .black
        }
        
        cell.imgView.setBorder(colour: applicationMainColor, alpha: 1.0, radius: cell.imgView.viewHeightBy2, borderWidth: 1.0)
        cell.lblTime.text = obj.objChat.dateToShow
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: cell.contentView)
            
            cell.lblMsg.textAlignment = .right
            cell.lblID.textAlignment = .right
            cell.lblTime.textAlignment = .left

        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openChatBoard(arrForUsers[indexPath.row].objUser, arrForUsers[indexPath.row])
    }
    
    func openChatBoard(_ objUser:UserObject, _ objChatList : ChatListObject = ChatListObject()) {
        let obj = ChatViewController()
        obj.objUser = objUser
        obj.objChatListObject = objChatList
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // MARK: - WSCalls
    func WSForGetChatUserList() {
        var params: Dictionary<String, String> = [:]
        params["startRange"] = "0"
        params["count"] = "1000"
        params["type"] = "following"
        params["userId"] = loggedInUser?.id ?? ""
        
        Utility.showHud(view: self.view)
        WSManage.getDataWithGetServiceWithParams(name: WSManage.WSChatUserList, parameters: params, isPost: true) { (isSuccess, dict) in
            Utility.hideHud()
            self.arrForUsers = []
            print(dict)
            if let str = dict?["status"] as? Int {
                if str == 1 {
                    if var arrData = dict?["data"] as? [[String:AnyObject]] {
                        arrData.reverse()
                        for item in arrData {
                            self.arrForUsers.append(ChatListObject(dict: item))
                        }
                    }
                    self.tblUser.reloadData()
                } else if str == 0 {
                    
                }
            }
        }
    }
    
    // MARK: - Variables and Other Declarations
    
    
    @IBOutlet weak var tblUser: UITableView!
    var arrForUsers:[ChatListObject] = []
    
}
