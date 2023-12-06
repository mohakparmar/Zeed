//
//  MessagesController.swift
//  Zeed
//
//  Created by Shrey Gupta on 01/04/21.
//

import UIKit
import MessageKit


class MessagesContainer: UICollectionViewController {
    
    //MARK: - Properties
    var allConversations:[ChatListObject] = []
    
    //MARK: - UI Elements
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(#imageLiteral(resourceName: "cross"), for: .normal)
        button.setDimensions(height: 19, width: 19)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        button.tintColor = .appPrimaryColor
        return button
    }()
    
    //MARK: - Lifecycle
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.WSForGetChatUserList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        configureNavigationBar(largeTitleColor: .appPrimaryColor, backgoundColor: .appBackgroundColor, tintColor: .appPrimaryColor, title: "Messages", preferredLargeTitle: false)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        
        collectionView.delegate = self
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: MessageCell.reuseIdentifier)
        
        // Do any additional setup after loading the view.
        collectionView.backgroundColor = .appBackgroundColor

        collectionView.isScrollEnabled = true
        collectionView.alwaysBounceVertical = true
        
        connecMessagingtSocket()
    }
    
    //MARK: - Selector
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // FIXME: - handle create group
    @objc func btnCreateGroupClick(_ sender: Any) {
        let obj = FollowingListViewController()
        obj.type = 1
        obj.delegate = self
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    //MARK: - Socket
    func connecMessagingtSocket() {
        let socket = SocketService.shared.socket
        
        socket.on("typing") {data, ack in
            if let arr = data as?  [[String:AnyObject]] {
                for item in arr {
                    print("DEBUG:- received typing")
                    let objChat = ChatObject(dict: item)
                    let filteredArray = self.allConversations.filter({$0.objUser.id == objChat.UserId})
                    for obj in filteredArray {
                        obj.objUser.isTyping = true
                    }
                    self.collectionView.reloadData()
                    print(filteredArray)
                }
            }
        }

        socket.on("stop typing") {data, ack in
            if let arr = data as?  [[String:AnyObject]] {
                for item in arr {
                    print("DEBUG:- received stop typing")
                    let objChat = ChatObject(dict: item)
                    let filteredArray = self.allConversations.filter({$0.objUser.id == objChat.UserId})
                    for obj in filteredArray {
                        obj.objUser.isTyping = false
                    }
                    self.collectionView.reloadData()
                    print(filteredArray)
                }
            }
        }
        
        socket.on("new message") {data, ack in
            print(data)
            print("DEBUG:- received new message")
            if let arr = data as?  [[String:AnyObject]] {
                self.checkCurrentUserObject(arrData: arr, op: 1)
            }
        }
    }

    func checkCurrentUserObject(arrData:[[String:AnyObject]], op:Int) {
        for item in arrData {
            let objChat = ChatObject(dict: item)
            let filteredArray = self.allConversations.filter({$0.objUser.id == objChat.UserId})
            for obj in filteredArray {
                if let currentUser = AppUser.shared.getDefaultUser() {
                    if objChat.targetUserId == currentUser.id || objChat.targetGroupId == obj.objUser.id {
                        obj.objChat = objChat
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    //MARK: - Helper Functions
    func WSForGetChatUserList() {
         var params: Dictionary<String, String> = [:]
         params["startRange"] = "0"
         params["count"] = "1000"
        
         Utility.showHud(view: self.view)
         WSManage.getDataWithGetServiceWithParams(name: WSManage.WSChatUserList, parameters: params, isPost: true) { (isSuccess, dict) in
             Utility.hideHud()
            self.allConversations = []
             if let str = dict?["status"] as? Int {
                 if str == 1 {
                     if var arrData = dict?["data"] as? [[String:AnyObject]] {
                        arrData.reverse()
                        var allItems = [ChatListObject]()
                         for item in arrData {
                            allItems.append(ChatListObject(dict: item))
                         }
                        
                        self.allConversations = allItems
                     }
                     self.collectionView.reloadData()
                 } else if str == 0 {
                     
                 }
             }
         }
     }
    
    func openChatBoard(_ objUser:UserObject, _ objChatList : ChatListObject = ChatListObject()) {
        let obj = ChatViewController()
        obj.objUser = objUser
        obj.objChatListObject = objChatList
        self.navigationController?.pushViewController(obj, animated: true)
    }

    //MARK: - DataSource UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allConversations.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageCell.reuseIdentifier, for: indexPath) as! MessageCell
        let obj = allConversations[indexPath.row]
        
        cell.notificationView.isHidden = false
        
        if obj.anonymous == "1" {
            cell.profileImageView.image = UIImage(named: "userPlaceHolder")
            cell.nameLabel.text = "Anonymous"
        } else {
            cell.profileImageView.setUserImageUsingUrl(obj.objUser.objImage.url)
            cell.nameLabel.text = obj.objUser.username
        }
        
        if obj.unSeen.floatValue > 0 {
            cell.notificationNumberLabel.text = obj.unSeen
            cell.notificationView.isHidden = false
        } else {
            cell.notificationView.isHidden = true
        }

        if obj.objUser.isTyping {
            cell.lastMessageLabel.text = "Typing..."
            cell.lastMessageLabel.textColor = .lightGray
        } else {
            cell.lastMessageLabel.text = obj.objChat.typeOfMessage == "1" ? obj.objChat.text : "Video/Image/Audio"
            cell.lastMessageLabel.textColor = .darkGray
        }
        
        cell.timeLabel.text = obj.objChat.dateToShow
        return cell
    }
}

extension MessagesContainer: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.openChatBoard(allConversations[indexPath.row].objUser, allConversations[indexPath.row])
    }
}

//MARK: - Delegate FollowingControllerDelegate
extension MessagesContainer: FollowingControllerDelegate {
    func sendUserWithType(object: UserObject, arrForGroup: [UserObject], SelectionType: Int) {
        if arrForGroup.count > 1 {
            let group = GroupViewController()
            group.arrForUsers = arrForGroup
            self.navigationController?.pushViewController(group, animated: false)
        } else if arrForGroup.count == 1 {
            openChatBoard(arrForGroup[0])
        }
    }
}
