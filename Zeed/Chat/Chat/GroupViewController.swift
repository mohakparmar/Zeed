//
//  GroupViewController.swift
//  FFlash
//
//  Created by hemant agarwal on 24/02/20.
//  Copyright © 2020 hemant agarwal. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FollowingControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblUser.registerNib(nibName: "ChatListTCell")
        tblMenu.registerNib(nibName: "MenuTCell")
        
        Utility.openScreenView(str_screen_name: "Add_Update_Group", str_nib_name: self.nibName ?? "")

        if objGroup.id.checkEmpty() == false {
            WSForGetDetails()
            btnCreateGroup.setTitle("Update Group", for: .normal)
        } else {
            btnCreateGroup.isHidden = false
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setLayouts()
//        appDele?.tabBarController?.tabBar.isHidden = true
        self.edgesForExtendedLayout = .bottom
        self.extendedLayoutIncludesOpaqueBars = true
        imgView.setRadius(radius: imgView.viewHeightBy2)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        appDele?.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - LayoutMethods
    func setLayouts() {
        tblMenu.setRadius(radius: 10)
        btnCancel.setRadius(radius: 10)
        viewForMenu.setHeightPosition(heightValue: (CGFloat(arrForStatus.count) * 50)  + 55 )
        btnCreateGroup.setRadius(radius: btnCreateGroup.viewHeightBy2)
        txtGroupName.setTextFieldPlaceHolderColour(colour: placeHolderColor, alpha: 1.0)
    }
    
    
    // MARK: - ButtonClicks
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnInfoClick(_ sender: Any) {
        self.arrForStatus = [
        SettingObject(text: "Delete Group", img: "F93A3A", tag: 2),
        SettingObject(text: "Exit Group", img: "FFFFFF", tag: 3)]
        self.tblMenu.reloadData()
        self.hideShowMenu()
    }
    
    @IBAction func btnImgClick(_ sender: Any) {
        showActionSheet()
    }
    
    @IBAction func btnAddMemberClick(_ sender: Any) {
        let obj = FollowingListViewController()
        obj.delegate = self
        obj.type = 1
        obj.arrForSelectedUsers = arrForUsers
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func sendUserWithType(object: UserObject, arrForGroup: [UserObject], SelectionType: Int) {
        arrForUsers = arrForUsers + arrForGroup
        tblUser.reloadData()
        WSForAddUsers(arrUser: arrForGroup)
    }
    
    @IBAction func btnCloseClick(_ sender: Any) {
        hideShowMenu()
    }
    
    @IBAction func btnCreateGroupClick(_ sender: Any) {
        if txtGroupName.text!.checkEmpty() {
            Utility.showISMessage(str_title: "Please enter group name.", Message: "", msgtype: .warning)
        } else if arrForUsers.count == 0 {
            Utility.showISMessage(str_title: "Please select users.", Message: "", msgtype: .warning)
        } else {
            WSForAddGroup()
        }
    }
    
    
    // MARK: - Tableview Delegate and Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblMenu {
            return arrForStatus.count
        }
        return arrForUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblMenu {
            let cell:MenuTCell = tblMenu.dequeueReusableCell(withIdentifier: "cell") as! MenuTCell
            let obj = arrForStatus[indexPath.row]
            cell.lblTitle.text = obj.str_title
            cell.lblTitle.textColor = UIColor().setColor(hex: obj.str_img, alphaValue: 1.0)
            return cell
        }
        let cell:ChatListTCell = tblUser.dequeueReusableCell(withIdentifier: "cell") as! ChatListTCell
        
        let obj = arrForUsers[indexPath.row]
        
        cell.imgView.setUserImageUsingUrl(obj.objImage.url)
        cell.lblID.text = obj.username.uppercased()
        cell.lblMsg.text = obj.admin == "1" ? "ADMIN" : ""
        cell.lblTime.isHidden = true
        cell.btnMenu.isHidden = AppUser.shared.getDefaultUser()!.id == obj.id ? true : false
        
        cell.imgView.setBorder(colour: applicationMainColor, alpha: 1.0, radius: cell.imgView.viewHeightBy2, borderWidth: 1.0)
        
        cell.btnMenuClick = {
            
            if self.isCurrentUserAdmin {
                self.arrForStatus = [
                SettingObject(text: "Remove", img: "F93A3A", tag: 1),
                SettingObject(text: "Make Admin", img: "FFFFFF", tag: 4)]
                self.tblMenu.reloadData()
                self.selectedIndex = indexPath.row
                self.hideShowMenu()
            } else {
                Utility.showISMessage(str_title: "Only admin can change the user status.", Message: "", msgtype: .error)
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblMenu {
            hideShowMenu()
            if indexPath.row == 0 {
                WSForRemoveUsers()
            } else if indexPath.row == 1 {
                WSForAddOrRemoveAdmin(isMakeAdmin: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblMenu {
            return 50
        }
        return 100
    }
    
    // MARK: - HideShowMenu
    func hideShowMenu() {
        if viewForMenu.isHidden {
            view.endEditing(true)
            self.viewForMenu.isHidden = false
            UIView.animate(withDuration: 0.3) {
                _ = self.viewForMenu.setYPosition(yValue: screenHeight - self.viewForMenu.viewHeight - 20)
            }
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                _ = self.viewForMenu.setYPosition(yValue: screenHeight)
            }) { (finished) in
                self.viewForMenu.isHidden = true
            }
        }
    }
    
    
    //MARK:- Image Picker Methods
    func showActionSheet() {
        //Create the AlertController and add Its action like button in Actionsheet
        let actionSheetController: UIAlertController = UIAlertController(title: appDele!.isForArabic ? Upload_Image_ar : Upload_Image_en, message: nil, preferredStyle: .actionSheet)
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
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func camera() {
        let myPickerControllerCamera = UIImagePickerController()
        myPickerControllerCamera.delegate = self
        myPickerControllerCamera.sourceType = UIImagePickerController.SourceType.camera
        myPickerControllerCamera.allowsEditing = true
        self.present(myPickerControllerCamera, animated: true, completion: nil)
    }
    
    func gallery() {
        let myPickerControllerGallery = UIImagePickerController()
        myPickerControllerGallery.delegate = self
        myPickerControllerGallery.sourceType = UIImagePickerController.SourceType.photoLibrary
        myPickerControllerGallery.allowsEditing = true
        self.present(myPickerControllerGallery, animated: true, completion: nil)
    }
    
    
    //MARK:- UIImagePickerController delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[.editedImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        // Set photoImageView to display the selected image.
        imgView.image = selectedImage
        uploadImageToserver()
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImageToserver() {
        let params: Dictionary<String, String> = [:]
        let imgData = imgView.image!.jpegData(compressionQuality: 0.8)
        Utility.showHud(view: self.view)
        WSManage.requestWithMultipartImageDataUpload(name: WSManage.WSAddMedia, imageData: imgData, type: 0, parameters: params, imageName: "media") { (isFinished, dict) in
            Utility.hideHud()
            print(dict)
            if let str = dict?["status"] as? Int {
                if str == 1 {
                    if let arr = dict?["data"] as? [[String:AnyObject]] {
                        for item in arr {
                            self.objUpload = UploadImageObject(dict: item)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - WSCalls
    func WSForAddGroup() {
        var params: Dictionary<String, Any> = [:]
        params["name"] = txtGroupName.text
        params["description"] = ""
        params["mediaId"] = objUpload.id
        
        var arr: [String] = []
        for object in arrForUsers {
            arr.append(object.id)
        }
        params["userIds"] = arr
        
        var name:String = WSManage.WSAddGroup
        if objGroup.id.checkEmpty() == false {
            params["groupId"] = objGroup.id
            name = WSManage.WSUpdateGroup
        }
        
        Utility.showHud(view: self.view)
        WSManage.getDataWithGetServiceWithParams(name: name, parameters: params, isPost: true) { (isSuccess, dict) in
            Utility.hideHud()
            print(dict)
            if let str = dict?["status"] as? Int {
                if str == 1 {
                    if self.objGroup.id.checkEmpty() == false {
                        Utility.showISMessage(str_title: "Group Details Updated successfully.", Message: "", msgtype: .success)
                    } else {
                        Utility.showISMessage(str_title: "Group added successfully.", Message: "", msgtype: .success)
                        self.navigationController?.popViewController(animated: true)
                    }
                    self.navigationController?.popViewController(animated: true)
                } else if str == 0 {
                    Utility.showISMessage(str_title: "Something went wrong. Please try again.", Message: "", msgtype: .success)
                }
            }
        }
    }
    
    func WSForGetDetails() {
        var params: Dictionary<String, Any> = [:]
        params["groupId"] = objGroup.id
        
        Utility.showHud(view: self.view)
        WSManage.getDataWithGetServiceWithParams(name: WSManage.WSGetGroupDetails, parameters: params, isPost: true) { (isSuccess, dict) in
            Utility.hideHud()
            print(dict)
            if let str = dict?["status"] as? Int {
                if str == 1 {
                    if let dictGroup = dict?["data"] as? [String:AnyObject] {
                        if let arr = dictGroup["Groups"] as? [[String:AnyObject]] {
                            for item in arr {
                                if let arrUs = item["Users"] as? [[String:AnyObject]] {
                                    for user in arrUs {
                                        let user = UserObject(dict: user)
                                        if user.id == AppUser.shared.getDefaultUser()!.id && user.admin == "1" {
                                            self.isCurrentUserAdmin = true
                                        }
                                        self.arrForUsers.append(user)
                                    }
                                }
                                self.tblUser.reloadData()
                                self.txtGroupName.text = Utility.getValue(dict: item, key: "name")
                                if let media = item["media"] as? [String:AnyObject] {
                                    self.objUpload = UploadImageObject(dict: media)
                                    self.imgView.setImageUsingUrl(self.objUpload.url)
                                }
                            }
                        }
                    }
                } else if str == 0 {
                    Utility.showISMessage(str_title: "Something went wrong. Please try again.", Message: "", msgtype: .error)
                }
            }
        }
    }
    
    
    // MARK: - WSCalls Add Uaer
    func WSForAddUsers(arrUser:[UserObject]) {
        var params: Dictionary<String, Any> = [:]
        params["groupId"] = objGroup.id
        
        var arr:[String] = []
        for obj in arrUser {
            arr.append(obj.id)
        }
        params["userIds"] = arr
        
        Utility.showHud(view: self.view)
        WSManage.getDataWithGetServiceWithParams(name: WSManage.WSAddUser, parameters: params, isPost: true) { (isSuccess, dict) in
            Utility.hideHud()
            print(dict)
            if let str = dict?["status"] as? Int {
                if str == 1 {
                    Utility.showISMessage(str_title: "", Message: "Users Added to Group.", msgtype: .success)
                } else if str == 0 {
                    Utility.showISMessage(str_title: "", Message: "Something went wrong while adding user. Please try again.", msgtype: .error)
                }
            }
        }
    }

    
    // MARK: - WSCalls Add Uaer
    func WSForRemoveUsers() {
        var params: Dictionary<String, Any> = [:]
        params["groupId"] = objGroup.id
        let obj = arrForUsers[selectedIndex]
        params["userId"] = obj.id
        Utility.showHud(view: self.view)
        WSManage.getDataWithGetServiceWithParams(name: WSManage.WSRemoveUser, parameters: params, isPost: true) { (isSuccess, dict) in
            Utility.hideHud()
            print(dict)
            if let str = dict?["status"] as? Int {
                if str == 1 {
                    Utility.showISMessage(str_title: "", Message: "Users removed from Group.", msgtype: .success)
                } else if str == 0 {
                    Utility.showISMessage(str_title: "", Message: "Something went wrong while removing user. Please try again.", msgtype: .error)
                }
            }
        }
    }

    
    // MARK: - WSCalls
    func WSForAddOrRemoveAdmin(isMakeAdmin:Bool) {
        var params: Dictionary<String, Any> = [:]
        params["groupId"] = objGroup.id
        let obj = arrForUsers[selectedIndex]
        params["userId"] = obj.id

        var name:String = WSManage.WSMakeAdmin
        if objGroup.id.checkEmpty() == false {
            name = WSManage.WSRemoveAdmin
        }
        
        Utility.showHud(view: self.view)
        WSManage.getDataWithGetServiceWithParams(name: name, parameters: params, isPost: true) { (isSuccess, dict) in
            Utility.hideHud()
            print(dict)
            if let str = dict?["status"] as? Int {
                if str == 1 {
                    Utility.showISMessage(str_title: "", Message: "Admin role assign successfully.", msgtype: .success)
                } else if str == 0 {
                    Utility.showISMessage(str_title: "", Message: "Something went wrong while removing user. Please try again.", msgtype: .error)
                }
            }
        }
    }
    
    
    
    // MARK: - Variables and Other Declarations
    @IBOutlet weak var viewNav: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnInfo: UIButton!
    
    @IBOutlet weak var viewImg: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnImg: UIButton!
    
    @IBOutlet weak var viewGroupName: UIView!
    @IBOutlet weak var txtGroupName: UITextField!
    
    @IBOutlet weak var lblMembers: UILabel!
    @IBOutlet weak var btnAddMember: UIButton!
    
    @IBOutlet weak var tblUser: UITableView!
    var arrForUsers:[UserObject] = []
    
    @IBOutlet weak var viewForMenu: UIView!
    @IBOutlet weak var tblMenu: UITableView!
    @IBOutlet weak var btnCancel: UIButton!
    var arrForStatus:[SettingObject] = [
        SettingObject(text: "Remove", img: "F93A3A", tag: 1),
        SettingObject(text: "Make Admin", img: "FFFFFF", tag: 4)]
    
    var objGroup:UserObject = UserObject()
    
    @IBOutlet weak var btnCreateGroup: UIButton!
    var objUpload:UploadImageObject = UploadImageObject()
    var selectedIndex:Int = 0
    
    var isCurrentUserAdmin:Bool = false
    
}
