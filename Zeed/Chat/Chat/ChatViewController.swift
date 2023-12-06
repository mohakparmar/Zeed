//
//  ChatViewController.swift
//  FFlash
//
//  Created by hemant agarwal on 24/02/20.
//  Copyright © 2020 hemant agarwal. All rights reserved.
//

import UIKit
import SocketIO
import Foundation
import AVFoundation
import MobileCoreServices
import ReverseExtension

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: - UI Elements
    private lazy var profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        iv.setDimensions(height: 40, width: 40)
        iv.layer.cornerRadius = 40/2
        
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let typingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.darkGray.withAlphaComponent(0.75)
        label.text = "typing..."
        label.alpha = 0
        return label
    }()
    
    private lazy var infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(#imageLiteral(resourceName: "info").withRenderingMode(.alwaysTemplate), for: .normal)
        button.setDimensions(height: 19, width: 19)
        button.addTarget(self, action: #selector(btnHideClick), for: .touchUpInside)
        button.tintColor = .appPrimaryColor
        return button
    }()
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(#imageLiteral(resourceName: "menu_options").withRenderingMode(.alwaysTemplate), for: .normal)
        button.setDimensions(height: 19, width: 19)
        button.addTarget(self, action: #selector(btnUserSettingClick), for: .touchUpInside)
        button.tintColor = .appPrimaryColor
        return button
    }()
    
    func configureTopBar() {
        let nameTypingStack = UIStackView(arrangedSubviews: [nameLabel, typingLabel])
        nameTypingStack.axis = .vertical
        nameTypingStack.alignment = .leading
        nameTypingStack.distribution = .fillProportionally
        nameTypingStack.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        let mainTopBarStack = UIStackView(arrangedSubviews: [profileImageView, nameTypingStack])
        mainTopBarStack.axis = .horizontal
        mainTopBarStack.spacing = 7
        mainTopBarStack.alignment = .center
        mainTopBarStack.distribution = .fill
        mainTopBarStack.anchor(width: view.frame.width - (view.frame.width/6))
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGestureRecognizer)

        navigationItem.titleView = mainTopBarStack
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: infoButton), UIBarButtonItem(customView: settingsButton)]
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
//        let controller = UserProfileController(forUserId: objUser.id)
        let obj = OtherProfileVC()
        obj.userId = objUser.id
        navigationController?.pushViewController(obj, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureTopBar()
        Utility.openScreenView(str_screen_name: "Chat_View", str_nib_name: self.nibName ?? "")

        tblChat.re.delegate = self
//        tblChat.registerNib(nibName: )TextCCell
        tblChat.register(ChatMessageTCell.self, forCellReuseIdentifier: ChatMessageTCell.reuseIdentifier)
        // Do any additional setup after loading the view.
        nameLabel.text = objUser.username
        profileImageView.setUserImageUsingUrl(objUser.objImage.url)

        if objUser.type.uppercased() == "GROUP" {
            infoButton.isHidden = false
            settingsButton.isHidden = true
        } else {
            infoButton.isHidden = true
            settingsButton.isHidden = false
            self.setAnnoData()
        }
        

        // Do any additional setup after loading the view.
        collectionEmojis.registerNib(nibName: "TextCCell")
        
        for i in 0x1F601...0x1F64F {
            let c = String(UnicodeScalar(i) ?? "-")
            arrForEmojis.append(c)
            print(c)
        }

//        if isforBiddingChat {
//            viewproduct.isHidden = false
//
//            imgProduct.setImageUsingUrl(objBiddingItem.objMedia.url)
//            lblProductName.text = objBiddingItem.title.uppercased()
//            lblProductPrice.text = objBiddingItem.objCurrentBidder.Price + " " + objBiddingItem.currency
//
//        }
        
        connectSocket()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        WSForGetMessage()
        setLayouts()
//        appDele?.tabBarController?.tabBar.isHidden = true
        self.edgesForExtendedLayout = .bottom
        self.extendedLayoutIncludesOpaqueBars = true
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        appDele?.tabBarController?.tabBar.isHidden = false
    }

    func sendTypingBlock(isStarted:Bool) {
        let socket = SocketService.shared.socket
        var params: [String : String] = [:]
        if objUser.type.uppercased() == "GROUP" {
            params["targetUserId"] = ""
            params["targetGroupId"] = objUser.id
        } else {
            params["targetUserId"] = objUser.id
            params["targetGroupId"] = ""
        }
        socket.emit(isStarted ? "typing" : "stop typing", with: [params]) {
            print("typing start")
            self.isTyping = isStarted
        }
    }
    
    func stopTyping() {
        
    }
    
    func connectSocket() {
        SocketService.shared.connectSocket()
        let socket = SocketService.shared.socket
        socket.connect()
        socket.on("connect") {data, ack in
            print("Session Connected")
        }
        
        socket.on("typing") {data, ack in
            if let arr = data as?  [[String:AnyObject]] {
                self.checkCurrentUserObject(arrData: arr, op: 2)
            }
        }

        socket.on("stop typing") {data, ack in
            if let arr = data as?  [[String:AnyObject]] {
                self.checkCurrentUserObject(arrData: arr, op: 3)
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
            let socket = SocketService.shared.socket

            // FIXME: - guar dlet string
            let userId = AppUser.shared.getDefaultUser()!.id
            if objChat.targetUserId == userId || objChat.targetGroupId == self.objUser.id || objChat.UserId == userId || objChat.UserId == self.objUser.id   {
                if op == 1 {
                    let objChat = ChatObject(dict: item)
                    var params: [String : String] = [:]
                    params["messageId"] = objChat.id
                    socket.emit("seenDirect", with: [params]) {
                        print("Message Seen")
                    }
                    
                    self.arrForMessage.insert(objChat, at: 0)
                    self.addChatOBjectinView(objMsg: objChat)
                    self.scrollToBottom()
                } else if op == 2 {
                    self.typingLabel.isHidden = false
                } else if op == 3 {
                    self.typingLabel.isHidden = true
                }
            }
        }
    }

    // MARK: - LayoutMethods
    func setLayouts() {
        btnCamera.setRadius(radius: btnCamera.viewHeightBy2)
        btnEmojis.setRadius(radius: btnEmojis.viewHeightBy2)
        txtMsg.settextPaddingAndBorder()
    }

    // MARK: - Tableview Delegate and Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForDsiplayMsg.count 
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        
        let viewChat = arrForDsiplayMsg[indexPath.row]
        viewChat.tag = indexPath.row

        for i in 0..<cell.contentView.subviews.count {
            let subV = cell.contentView.subviews[i]
            if subV.tag != viewChat.tag {
                subV.removeFromSuperview()
            }
        }

        cell.contentView.addSubview(viewChat)
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objMsg = arrForMessage[indexPath.row]
        
        if objMsg.typeOfMessage == "1" {

        } else if objMsg.typeOfMessage == "2" {
            if objMsg.objMedia.type.contains("video") {
                let obj =  Utility.getVideoPreviewClass(str: objMsg.objMedia.url)
                self.present( obj, animated: true) {
                    obj.player!.play()
                }
            } else {
                // FIXME: - return image viewer controller
                self.present(Utility.getImagePreviewClass(str: objMsg.objMedia.url), animated: true, completion: nil)

            }
        } else if objMsg.typeOfMessage == "3" {
            if currentAudioIndex != 100000 {
                if indexPath.row == currentAudioIndex {
                    
                    let getImg = arrForDsiplayMsg[currentAudioIndex].viewWithTag(1) as! UIImageView
                    getImg.image = UIImage(named: "play.circle.fill")
                } else {
                    let getImg = arrForDsiplayMsg[currentAudioIndex].viewWithTag(1) as! UIImageView
                    getImg.image = UIImage(named: "play.circle.fill")
                    
                    currentAudioIndex = indexPath.row
                    let getImg1 = arrForDsiplayMsg[currentAudioIndex].viewWithTag(1) as! UIImageView
                    getImg1.image = UIImage(named: "pause.circle.fill")
                    self.playAudioAtIndex(index: currentAudioIndex)
                }
            } else {
                currentAudioIndex = indexPath.row
                let getImg1 = arrForDsiplayMsg[currentAudioIndex].viewWithTag(1) as! UIImageView
                getImg1.image = UIImage(named: "pause.circle.fill")
                self.playAudioAtIndex(index: currentAudioIndex)
            }
        } else if objMsg.typeOfMessage == "4" {

        } else if objMsg.typeOfMessage == "5" {
            guard let post = objMsg.objPost else { return }
            let controller = SinglePostController(forPost: post, isForSingleItem: false)
            navigationController?.pushViewController(controller, animated: true)

//            if objMsg.objPost.arrForMedia.count > 0 {
                // FIXME: - story view controller
//                let objMedia = objMsg.objPost.arrForMedia[0]
//                let obj = PostViewViewController()
//                obj.objMedia = MediaObject()
//                obj.objMedia.id = objMedia.id
//                self.navigationController?.pushViewController(obj, animated: true)
//            }
        }
    }
    
    func getView(index:Int) -> UIImageView {
        let view = arrForDsiplayMsg[index]
        for sub in view.subviews {
            if sub is UIImageView {
                let ima = sub as! UIImageView
                if ima.tag > 0 {
                    return ima
                }
            }
        }
        return UIImageView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let bubble = self.arrForDsiplayMsg[indexPath.row]
        return bubble.frame.size.height+20;

        let objMsg = arrForMessage[indexPath.row]
        return objMsg.heightForText
    }

    
    // MARK: - ButtonClicks
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnHideClick(_ sender: Any) {
        if objUser.type.uppercased() == "GROUP" {
            let objGr = GroupViewController()
            objGr.objGroup = objUser
            self.navigationController?.pushViewController(objGr, animated: true)
        }
    }
    
    @IBAction func btnUserSettingClick(_ sender: Any) {
        let alert = UIAlertController(title: "Setting", message: "", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: self.objUser.isBlockByUser == "1" ? "Unblock" : "Block", style: .default , handler:{ (UIAlertAction)in
            self.blockUser(str: self.objUser.id, strStatus: self.objUser.isBlockByUser == "1" ? "0" : "1")
            print("User click Approve button")
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func blockUser(str:String, strStatus:String) {
        var params: Dictionary<String, Any> = [:]
        params["userId"] = str
        params["block"] = strStatus == "1" ? "true" : "false"

        
        // FIXME: - call service for block unblock
        Utility.showHud(view: self.view)
        WSManage.getDataWithGetServiceWithParams(name: WSManage.WSBlockUser, parameters: params, isPost: true) { (isSuccess, dict) in
            Utility.hideHud()
//            print(dict)
            if let str = dict?["status"] as? Int {
                if str == 1 {
                    if strStatus == "1" {
                        Utility.showISMessage(str_title: "", Message: "User blocked successfully.", msgtype: .success)
                    } else {
                        Utility.showISMessage(str_title: "", Message: "User unblocked successfully.", msgtype: .success)
                    }
                    self.navigationController?.popToRootViewController(animated: true)
                } else if str == 0 {

                }
            }
        }
    }

    
    @IBAction func btnCameraClick(_ sender: Any) {
//        let obj = AddStoryViewController()
//        obj.isForChatCommentImage = 1
//        obj.objUser = self.objUser
//        self.navigationController?.pushViewController(obj, animated: true)
        showActionSheet()
    }

//    func uploadImageToserver(img:UIImage, type: Int, data:Data) {
//        // FIXME: - update upload images
//        let params: Dictionary<String, String> = [:]
//        var imgData = img.jpegData(compressionQuality: 0.5)
//        if  type == 1 {
//            imgData = data
//        }
//        Utility.showHud(view: self.view)
//        WSManage.requestWithMultipartImageDataUpload(name: WSManage.WSAddMedia, imageData: imgData, type: type, parameters: params, imageName: "media") { (isFinished, dict) in
//            Utility.hideHud()
//            if let str = dict?["status"] as? Int {
//                if str == 1 {
//                    if let arr = dict?["data"] as? [[String:AnyObject]] {
//                        for item in arr {
//                            self.objUpload = UploadImageObject()
//                            self.objUpload = UploadImageObject(dict: item)
//                        }
//                    }
//                    if self.objUpload.id.checkEmpty() == false {
//                        self.sendMsg(isForText: false, msg: "", mediaObject: self.objUpload)
//                    }
//                }
//            }
//        }
//    }

    // MARK: - CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrForEmojis.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell" , for: indexPath as IndexPath) as! TextCCell
        
        cell.lblTitle.text = arrForEmojis[indexPath.row]
        cell.lblTitle.backgroundColor = UIColor.clear
        cell.lblTitle.font = UIFont.systemFont(ofSize: 35)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        txtMsg.text = txtMsg.text! + arrForEmojis[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }

    
    @IBAction func btnEmojisClick(_ sender: Any) {
        if collectionEmojis.isHidden {
            viewBottom.setHeightPosition(heightValue: 120)
            viewBottom.setYPosition(yValue: scrView.viewHeight - 130)
            collectionEmojis.isHidden = false
        } else {
            viewBottom.setHeightPosition(heightValue: 60)
            viewBottom.setYPosition(yValue: scrView.viewHeight - 70)
            collectionEmojis.isHidden = true
        }
    }
    
    // MARK: - TextFieldDelegte
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.sendTypingBlock(isStarted: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.sendTypingBlock(isStarted: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.txtMsg == textField {
            if textField.text?.checkEmpty() == false {
                sendMsg(isForText: true, msg: textField.text!, mediaObject: UploadImageObject())
                txtMsg.text = ""
            }
        }
        return false
    }
    
    func sendMsg(isForText:Bool, msg:String, mediaObject : UploadImageObject) {
        let socket = SocketService.shared.socket
        var params: [String : String] = [:]
        if objUser.type.uppercased() == "GROUP" {
            params["targetUserId"] = ""
            params["targetGroupId"] = objUser.id
        } else {
            params["targetUserId"] = objUser.id
            params["targetGroupId"] = ""
        }
        if isForText {
            params["text"] = isForText ? msg.encode() : ""
        } else {
            params["mediaId"] = mediaObject.id
        }
        
        socket.emit("new message", with: [params]) {
            print("Message Sent")
//            let obj = ChatObject()
//            obj.createdAt = ""
//            // FIXME: - guard let app user
//            obj.UserId = AppUser.shared.getDefaultUser()!.id
//            obj.text = msg
//            obj.objMedia = mediaObject
//            obj.MediumId = mediaObject.id
//            obj.isSendByMe = true
//            obj.targetUserId = self.objUser.id
//            let objFrame = ChatObject.getHeightfromText(str: obj.text)
//            obj.heightForText = objFrame.height
//            obj.widthForText = objFrame.width
//
//            if isForText {
//                obj.typeOfMessage = "1"
//            } else {
//                obj.heightForText = 270
//                if self.objUpload.type.contains("image") {
//                    obj.text = "Image"
//                } else if self.objUpload.type.contains("video") {
//                    obj.text = "Video"
//                } else if self.objUpload.type.contains("audio") {
//                    obj.typeOfMessage = "3"
//                    obj.heightForText = 100
//                    obj.text = "Audio"
//                }
//            }
//            self.addChatOBjectinView(objMsg: obj)
//            self.arrForMessage.append(obj)
//            self.scrollToBottom()
        }
    }
    
    func addChatOBjectinView(objMsg:ChatObject) {
        if objMsg.typeOfMessage == "1" {
            self.arrForDsiplayMsg.insert(AGChatViewController().createMessage(withText: objMsg.text, image: "", dateTime: objMsg.dateToShow, isReceived: !objMsg.isSendByMe, isVideo: false, type: ""), at: 0)
        } else if objMsg.typeOfMessage == "2" {
            if objMsg.objMedia.type.contains("video") {
                self.arrForDsiplayMsg.insert(AGChatViewController().createMessage(withText: nil, image: objMsg.objMedia.url, dateTime: objMsg.dateToShow, isReceived: !objMsg.isSendByMe, isVideo: true, type: objMsg.objMedia.type), at: 0)
            } else {
                self.arrForDsiplayMsg.insert(AGChatViewController().createMessage(withText: nil, image: objMsg.objMedia.url, dateTime: objMsg.dateToShow, isReceived: !objMsg.isSendByMe, isVideo: false, type: objMsg.objMedia.type), at: 0)
            }
        } else if objMsg.typeOfMessage == "3" {
            self.arrForDsiplayMsg.insert(AGChatViewController().createMessage(withText: nil, image: objMsg.objMedia.url, dateTime: objMsg.dateToShow, isReceived: !objMsg.isSendByMe, isVideo: false, type: objMsg.objMedia.type), at: 0)
        } else if objMsg.typeOfMessage == "4" {
//            self.arrForDsiplayMsg.insert(AGChatViewController().createMessage(withText: objMsg.text, image: objMsg.objStory.objMedia.url, dateTime: objMsg.dateToShow, isReceived: !objMsg.isSendByMe, isVideo: false, type: objMsg.objStory.objMedia.type), at: 0)
        } else if objMsg.typeOfMessage == "5" {
            if let medias = objMsg.objPost?.medias {
                if medias.count > 0 {
                    let objPost = objMsg.objPost?.medias[0]
                    self.arrForDsiplayMsg.insert(AGChatViewController().createMessage(withText: objMsg.text, image: objPost?.url, dateTime: objMsg.dateToShow, isReceived: !objMsg.isSendByMe, isVideo: false, type: objPost?.type), at: 0)
                }
            }
        }
//        tblChat.beginUpdates()
//        tblChat.re.insertRows(at: [IndexPath(row: arrForDsiplayMsg.count - 1, section: 1)], with: .automatic)
//        tblChat.endUpdates()
    }

    func scrollToBottom(){
        DispatchQueue.main.async {
            self.tblChat.reloadData()
            self.tblChat.scrollToLastRow(animated: true)
//            let indexPath = IndexPath(row: self.arrForMessage.count-1, section: 0)
//            self.tblChat.scrollToRow(at: indexPath, at: .bottom, animated: true)
            self.viewEmpty.isHidden = self.arrForMessage.count == 0 ? false : true
        }
    }
    
    
    //MARK:- Image Picker Methods
    func showActionSheet() {
        //Create the AlertController and add Its action like button in Actionsheet
        let actionSheetController: UIAlertController = UIAlertController(title: appDele!.isForArabic ? Upload_Images_ar : Upload_Images_en, message: nil, preferredStyle: .actionSheet)
        actionSheetController.view.tintColor = UIColor.black
        let cancelActionButton: UIAlertAction = UIAlertAction(title: appDele!.isForArabic ? Cancel_ar : Cancel_en, style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        let saveActionButton: UIAlertAction = UIAlertAction(title: appDele!.isForArabic ? Take_Photo_ar : Take_Photo_en, style: .default)
        { action -> Void in
            self.camera()
        }
        actionSheetController.addAction(saveActionButton)
        let deleteActionButton: UIAlertAction = UIAlertAction(title: appDele!.isForArabic ? Choose_Photo_From_Gallery_ar : Choose_Photo_From_Gallery_en, style: .default)
        { action -> Void in
            self.gallery()
        }
        actionSheetController.addAction(deleteActionButton)

        let saveActionButton1: UIAlertAction = UIAlertAction(title: appDele!.isForArabic ? Take_Video_ar : Take_Video_en, style: .default)
        { action -> Void in
            self.openCameraForVideo()
        }
        actionSheetController.addAction(saveActionButton1)
        let deleteActionButton1: UIAlertAction = UIAlertAction(title: appDele!.isForArabic ? Choose_Video_From_Gallery_ar : Choose_Video_From_Gallery_en, style: .default)
        { action -> Void in
            self.openImgPickerForVideo()
        }
        actionSheetController.addAction(deleteActionButton1)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    
    
    //MARK:- OpenCamera

    
    func openImgPickerForVideo() {
         let imagePickerController = UIImagePickerController()
         imagePickerController.sourceType = .savedPhotosAlbum
         imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
         imagePickerController.mediaTypes = ["public.movie"]
         imagePickerController.videoMaximumDuration = 30
         present(imagePickerController, animated: true, completion: nil)
     }
     
     func openCameraForVideo(){
         if UIImagePickerController.isSourceTypeAvailable(.camera){
             let myPickerController = UIImagePickerController()
             myPickerController.delegate = self
             myPickerController.allowsEditing = true
             myPickerController.sourceType = .camera
             myPickerController.mediaTypes = ["public.movie"]
             myPickerController.videoMaximumDuration = 30
             present(myPickerController, animated: true, completion: nil)
         }
     }


    func camera() {
        let myPickerControllerCamera = UIImagePickerController()
        myPickerControllerCamera.delegate = self
        myPickerControllerCamera.allowsEditing = true
        myPickerControllerCamera.sourceType = UIImagePickerController.SourceType.camera
        myPickerControllerCamera.allowsEditing = true
        self.present(myPickerControllerCamera, animated: true, completion: nil)
    }
    
    func gallery() {
        let myPickerControllerGallery = UIImagePickerController()
        myPickerControllerGallery.delegate = self
        myPickerControllerGallery.allowsEditing = true
        myPickerControllerGallery.sourceType = UIImagePickerController.SourceType.photoLibrary
        myPickerControllerGallery.allowsEditing = true
        self.present(myPickerControllerGallery, animated: true, completion: nil)
    }
    
    
    //MARK:- UIImagePickerController delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        var arrSelectedImages : [ImageObject] = []
        guard info[UIImagePickerController.InfoKey.mediaType] != nil else { return }
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! CFString
        
        switch mediaType {
        case kUTTypeImage:
            guard let selectedImage = info[.editedImage] as? UIImage else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            }
            let objImage = ImageObject()
            objImage.image = selectedImage
            objImage.selected = true
            arrSelectedImages.append(objImage)
            uploadImageToserver(arr: arrSelectedImages)
            break
        case kUTTypeMovie:
            let mediaType = info[UIImagePickerController.InfoKey.mediaType] as AnyObject
            if mediaType as! String == kUTTypeMovie as String {
                let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
                print("VIDEO URL: \(videoURL!)")
                let objImage = ImageObject()
                objImage.image = Utility.getThumbnailImage(forUrl: videoURL!)!
                do {
                    let video = try Data(contentsOf: videoURL!, options: .mappedIfSafe)
                    objImage.dataVideo = video as Data
                    objImage.videoUrl = videoURL
                    arrSelectedImages.append(objImage)
                    uploadImageToserver(arr: arrSelectedImages)
                } catch {
                   print(error)
                   return
                }
            }
            break
        case kUTTypeLivePhoto:
        
            break
        default:
            break
        }


        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Variables and Other Declarations
    func uploadImageToserver(arr:[ImageObject]) {
        let params: Dictionary<String, Any> = [:]
        Utility.showHud(view: self.view)
        WSManage.uploadMultipleImages(name: WSManage.WSAddMedia, parameters: params, arrImages: arr) { (isFinished, dict) in
            Utility.hideHud()
            print(dict)
            if let str = dict?["status"] as? Int {
                if str == 1 {
                    if let arr = dict?["data"] as? [[String:AnyObject]] {
                        for item in arr {
                            self.objUpload = UploadImageObject()
                            self.objUpload = UploadImageObject(dict: item)
                        }
                    }
                    if self.objUpload.id.checkEmpty() == false {
                        self.sendMsg(isForText: false, msg: "", mediaObject: self.objUpload)
                    }
                }
            }
        }
    }
    
    // MARK: - WSCalls

    func setAnnoData() {
        if self.objChatListObject.anonymous == "1" {
            nameLabel.text = "Anonymous"
            profileImageView.image = UIImage(named: "userPlaceHolder")
        } else {
            nameLabel.text = objUser.username
            profileImageView.setUserImageUsingUrl(objUser.objImage.url)
        }
    }
    
    // MARK: - WSCalls
    func WSForGetMessage() {
        var params: Dictionary<String, String> = [:]
        var name:String = ""
        if objUser.type.uppercased() == "GROUP" {
            params["groupId"] = objUser.id
            name = WSManage.WSGroupMessage
        } else {
            params["userId"] = objUser.id
            name = WSManage.WSDirectMessage
        }
        Utility.showHud(view: self.view)
        WSManage.getDataWithGetServiceWithParams(name: name, parameters: params, isPost: true) { (isSuccess, dict) in
            Utility.hideHud()
            print(dict)
            self.arrForMessage = []
            self.arrForDsiplayMsg = []
            if let str = dict?["status"] as? Int {
                if str == 1 {
                    if let arrData = dict?["data"] as? [[String:AnyObject]] {
                        for item in arrData {
                            let objMsg = ChatObject(dict: item)
                            self.arrForMessage.insert(objMsg, at: 0)
                            self.addChatOBjectinView(objMsg: objMsg)
                        }
                    }
                    self.viewEmpty.isHidden = self.arrForMessage.count == 0 ? false : true
                } else if str == 0 {
                    if let str = dict?["message"] as? String {
                        if str == "This userId has blocked you" {
                            Utility.showISMessage(str_title: "", Message: "You can not send message to this user.", msgtype: .error)
                            self.viewBottom.isHidden = true
                        }
                    }
                }
            }
            self.tblChat.reloadData()
        }
    }
    

    
    func playAudioAtIndex(index:Int) {
        let objChat = arrForMessage[index]
        let url = URL(string: objChat.objMedia.url)
        avPlayerItem = AVPlayerItem.init(url: url! as URL)
        avPlayer = AVPlayer.init(playerItem: avPlayerItem)
        avPlayer?.volume = 1.0
        avPlayer?.play()
    }
    
    @IBAction func btnSendMsgClick(_ sender: Any) {
        txtMsg.resignFirstResponder()
        if txtMsg.text?.checkEmpty() == false {
            sendMsg(isForText: true, msg: txtMsg.text!, mediaObject: UploadImageObject())
            txtMsg.text = ""
        }
    }
    

    // MARK: - Variables and Other Declarations
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var txtMsg: UITextField!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var btnEmojis: UIButton!
    
    @IBOutlet weak var tblChat: UITableView!
    
    var isTyping:Bool = false
    var arrForMessage:[ChatObject]  = []
    var arrForDsiplayMsg:[UIView]  = []
    var objUser: UserObject = UserObject() {
        didSet {
            nameLabel.text = objUser.username
            profileImageView.loadImage(from: objUser.objImage.url)
        }
    }
    var objUpload:UploadImageObject = UploadImageObject()
    
    var recorder = KAudioRecorder.shared

    var arrForEmojis:[String] = []
    @IBOutlet weak var collectionEmojis: UICollectionView!

    @IBOutlet weak var viewEmpty: UIView!
    
    @IBOutlet weak var viewRecordWhite: UIView!
    @IBOutlet weak var scrView: UIScrollView!
    
    var avPlayer:AVPlayer?
    var avPlayerItem:AVPlayerItem?
    var currentAudioIndex : Int = 100000
    
    
    @IBOutlet weak var viewproduct: UIView!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    
    var objChatListObject:ChatListObject = ChatListObject()
}

extension UITableView {
    func setOffsetToBottom(animated: Bool) {
        self.setContentOffset(CGPoint(x: 0, y: self.contentSize.height - self.frame.size.height), animated: true)
    }

    func scrollToLastRow(animated: Bool) {
        if self.numberOfRows(inSection: 0) > 0 {
            self.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: animated)
        }
    }
}
