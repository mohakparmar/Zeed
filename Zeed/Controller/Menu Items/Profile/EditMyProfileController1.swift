//
//  EditMyProfileController1.swift
//  Zeed
//
//  Created by Mohak Parmar on 19/01/22.
//

import UIKit
import JGProgressHUD


class EditMyProfileController1: UIViewController {
    var hud = JGProgressHUD(style: .dark)
    
    
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"

    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.openScreenView(str_screen_name: "Edit_Profile", str_nib_name: self.nibName ?? "")

        self.view.backgroundColor = .backgroundWhiteColor
        configureNavigationBar(largeTitleColor: .appPrimaryColor, backgoundColor: .appBackgroundColor, tintColor: .appPrimaryColor, title: appDele!.isForArabic ? Edit_Profile_ar : Edit_Profile_en, preferredLargeTitle: false)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        updateUser()
        WSForGetCountryCode()
        txtUsername.delegate = self
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().tranFormingView(toArabic: self.view)
            txtUsername.placeholder = EmailUsername_ar
            txtEmail.placeholder = Email_ar
            txtMobileNumber.placeholder = Mobile_Number_ar
            txtDescription.placeholder = Detail_ar
            txtFullname.placeholder = Full_Name_ar
       }
        // Do any additional setup after loading the view.
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let tabBarFrame = self.tabBarController?.tabBar.frame {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
                self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height - tabBarFrame.height
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
            self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height
        }
    }

    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapSave() {
        WSForUpdateUser()
    }
    
    
    func updateUser() {
        guard let user = AppUser.shared.getDefaultUser() else { return }
        imgView.setImage(url: user.image.url)
        txtUsername.text = user.userName
        txtFullname.text = user.fullName
        txtEmail.text = user.email
        txtMobileNumber.text = user.mobileNumber
        txtDescription.text = user.about
    }
    
    
    
    func uploadImageToserver(imgage : UIImage) {
        let params: Dictionary<String, String> = [:]
        let imgData = imgage.jpegData(compressionQuality: 0.8)
        Utility.showHud(view: self.view)
        WSManage.requestWithMultipartImageDataUpload(name: WSManage.WSAddMedia, imageData: imgData, type: 0, parameters: params, imageName: "media") { (isFinished, dict) in
            Utility.hideHud()
            print(dict)
            if let str = dict?["status"] as? Int {
                if str == 1 {
                    if let arr = dict?["data"] as? [[String:AnyObject]] {
                        for item in arr {
                            if let id = item["id"] as? String {
                                self.imageId = id
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func txtUserChange(_ sender: Any) {
        if txtUsername.text?.count ?? 0 > 16 {
            txtUsername.text = String(format: "%@", txtUsername.text!.prefix(16) as CVarArg)
        }
    }
    

    func WSForUpdateUser() {
        guard txtUsername.text?.checkEmpty() == false else {
            self.showAlert(withMsg: appDele!.isForArabic ? Please_enter_your_user_name_ar : Please_enter_your_user_name_en)
            return
        }

        guard txtUsername.text?.isValidInput() == true else {
            self.showAlert(withMsg: "User name only contain lower/upper alphabets, numbers and underscore only.")
            return
        }

        guard (txtUsername.text?.count ?? 0) > 2  else {
            self.showAlert(withMsg: "Username must contain atleast 3 characters.")
            return
        }

        guard txtUsername.text?.lowercased().contains("zeed") == false else {
            self.showAlert(withMsg: "Please remove Zeed from your user name.")
            return
        }

        guard txtFullname.text?.checkEmpty() == false else {
            self.showAlert(withMsg: "Please enter your name.")
            return
        }

        guard txtFullname.text?.lowercased().contains("zeed") == false else {
            self.showAlert(withMsg: "Please remove Zeed from your full name.")
            return
        }

        
        guard txtCountryCode.text?.checkEmpty() == false else {
            self.showAlert(withMsg: appDele!.isForArabic ? Select_Country_Code_ar : Select_Country_Code_en)
            return
        }

        guard txtMobileNumber.text?.checkEmpty() == false else {
            self.showAlert(withMsg: appDele!.isForArabic ? Please_enter_your_mobile_number_ar : Please_enter_your_mobile_number_en)
            return
        }

//        guard txtDescription.text?.checkEmpty() == false else {
//            self.showAlert(withMsg: "Please enter your about us details.")
//            return
//        }
        
        hud.show(in: self.view, animated: true)
        Service.shared.updateUserDetails(username: txtUsername.text!, name: txtFullname.text!, mobile: txtMobileNumber.text!, countryCode: txtCountryCode.text!, about: txtDescription.text!, imageId: self.imageId) { objUser, status, message in
            self.hud.dismiss(animated: true)
            if status {
                let encodeStatus = AppUser.shared.setDefaultUser(user: objUser!)
                Utility.showISMessage(str_title: "Success!", Message: "Your profile data updated successfully.", msgtype: .success, duration: 3)
                self.dismiss(animated: true)
            } else {
                Utility.showISMessage(str_title: "Failed!", Message: "Error occured: \(message)", msgtype: .error)
            }
        }
    }
    
    var arrForCountry : [AddressCountry] = []
    func WSForGetCountryCode() {
        WSManage.getDataWithPost(name: WSManage.WSCountryList, parameters: [:], isPost: false) { isError, dictionary in
            self.arrForCountry = []
            if isError == false {
                if let arr = dictionary?["data"] as? [[String:Any]] {
                    for item in arr {
                        self.arrForCountry.append(AddressCountry(dict: item))
                    }
                }
            }
        }
    }
    
    
    //MARK: - UI Elements
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(appDele!.isForArabic ? Confirm_ar : Confirm_en, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.tintColor = .appPrimaryColor
        button.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(#imageLiteral(resourceName: "cross"), for: .normal)
        button.setDimensions(height: 19, width: 19)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        button.tintColor = .appPrimaryColor
        return button
    }()

    @IBOutlet weak var imgView: UIImageView!
    private let imagePicker = UIImagePickerController()
    @IBAction func btnSelectImageClick(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var txtUsername: SGTextField!
    @IBOutlet weak var txtFullname: SGTextField!
    @IBOutlet weak var txtEmail: SGTextField!
    @IBOutlet weak var txtDescription: SGTextField!
    @IBOutlet weak var txtCountryCode: SGTextField!
    @IBOutlet weak var txtMobileNumber: SGTextField!
    
    var imageId : String = ""
    
    
}


extension EditMyProfileController1: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        imgView.image = selectedImage
        imgView.contentMode = .scaleAspectFill
        imgView.setRadius(radius: imgView.viewHeightBy2)
        self.uploadImageToserver(imgage: imgView.image!)
        picker.dismiss(animated: true, completion: nil)
    }
}

extension EditMyProfileController1 : UISearchTextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtCountryCode {
            let alert = UIAlertController(title: "Select Country", message: "", preferredStyle: .actionSheet)
            for item in arrForCountry {
                alert.addAction(UIAlertAction(title: item.name, style: .default, handler: { aler in
                    
                }))
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { aler in
                
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtUsername {
            let cs = CharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered: String = (string.components(separatedBy: cs) as NSArray).componentsJoined(by: "")
            return (string == filtered)
        }
        return true
    }
}
