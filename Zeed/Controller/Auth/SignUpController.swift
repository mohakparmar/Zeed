//
//  SignUpController.swift
//  Zeed
//
//  Created by Shrey Gupta on 10/04/21.
//

import UIKit
import Adjust

class SignUpController: UIViewController {
    //MARK: - Properties
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"

    //MARK: - UI Elements
    private let appLogo: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "zeed_logo")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let sigupLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Sign_Up_ar : Sign_Up_en
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .appPrimaryColor
        return label
    }()
    
    private let fullnameTextField: SGTextField = {
        let tf = SGTextField()
        tf.placeholder = appDele!.isForArabic ? Full_Name_ar : Full_Name_en
        tf.tintColor = .appPrimaryColor
        tf.borderInactiveColor = .lightGray
        tf.borderActiveColor = .appPrimaryColor
        tf.anchor(height: 60)
        tf.keyboardType = .default
        return tf
    }()
    
    private let usernameTextField: SGTextField = {
        let tf = SGTextField()
        tf.placeholder = appDele!.isForArabic ? User_Name_ar : User_Name_en
        tf.tintColor = .appPrimaryColor
        tf.borderInactiveColor = .lightGray
        tf.borderActiveColor = .appPrimaryColor
        tf.anchor(height: 60)
        tf.autocapitalizationType = .none
        tf.addTarget(self, action: #selector(textDidChange1), for: .editingChanged)
        return tf
    }()
    
    
    @objc func textDidChange1() {
        if usernameTextField.text?.count ?? 0 > 16 {
            usernameTextField.text = String(format: "%@", usernameTextField.text!.prefix(16) as CVarArg)
        }
    }


    private let emailTextField: SGTextField = {
        let tf = SGTextField()
        tf.placeholder = appDele!.isForArabic ? Email_ar : Email_en
        tf.autocapitalizationType = .none
        tf.tintColor = .appPrimaryColor
        tf.borderInactiveColor = .lightGray
        tf.borderActiveColor = .appPrimaryColor
        tf.anchor(height: 60)
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    private let passwordTextField: SGTextField = {
        let tf = SGTextField()
        tf.placeholder = appDele!.isForArabic ? Password_ar : Password_en
        tf.isSecureTextEntry = true
        tf.tintColor = .appPrimaryColor
        tf.borderInactiveColor = .lightGray
        tf.borderActiveColor = .appPrimaryColor
        tf.anchor(height: 60)
        return tf
    }()
    
    private let confirmPasswordTextField: SGTextField = {
        let tf = SGTextField()
        tf.placeholder = appDele!.isForArabic ? Confirm_Password_ar : Confirm_Password_en
        tf.isSecureTextEntry = true
        tf.tintColor = .appPrimaryColor
        tf.borderInactiveColor = .lightGray
        tf.borderActiveColor = .appPrimaryColor
        tf.anchor(height: 60)
        return tf
    }()
    
    private let phoneNumberTextField: SGTextField = {
        let tf = SGTextField()
        tf.placeholder = appDele!.isForArabic ? Mobile_Number_ar : Mobile_Number_en
        tf.tintColor = .appPrimaryColor
        tf.borderInactiveColor = .lightGray
        tf.borderActiveColor = .appPrimaryColor
        tf.anchor(height: 60)
        tf.keyboardType = .phonePad
        return tf
    }()
    
    private let countryCodeTextField: SGTextField = {
        let tf = SGTextField()
        tf.placeholder = "Code"
        tf.text = "+965"
        tf.isUserInteractionEnabled = false
        tf.tintColor = .appPrimaryColor
        tf.borderInactiveColor = .lightGray
        tf.borderActiveColor = .appPrimaryColor
        tf.anchor(width:70, height: 60)
        tf.keyboardType = .phonePad
        return tf
    }()
    
    
    private let descriptionTextField: SGTextField = {
        let tf = SGTextField()
        tf.placeholder = appDele!.isForArabic ?  Detail_ar : Detail_en
        tf.tintColor = .appPrimaryColor
        tf.borderInactiveColor = .lightGray
        tf.borderActiveColor = .appPrimaryColor
        tf.anchor(height: 60)
        tf.keyboardType = .default
        return tf
    }()
    
    
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .appBrightBlueColor
        button.setTitle(appDele!.isForArabic ?  Sign_Up_ar : Sign_Up_en, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        
        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        
        return button
    }()
    
    private let imagePicker = UIImagePickerController()
    
    
    private lazy var haveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: appDele!.isForArabic ?  Have_an_account_ar : Have_an_account_en, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .light), NSAttributedString.Key.foregroundColor: UIColor.black])
        
        attributedTitle.append(NSAttributedString(string: appDele!.isForArabic ?  Sign_In_ar : Sign_In_en, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold), NSAttributedString.Key.foregroundColor: UIColor.black]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.tintColor = .black
        
        button.addTarget(self, action: #selector(handlePop), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.openScreenView(str_screen_name: "Register", str_nib_name: self.nibName ?? "")

        registerButton.isEnabled = false
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        usernameTextField.delegate = self
        configureUI()
        configureFormValidation()
        
        setupToHideKeyboardOnTapOnView()
    }
    
    //MARK: - Selectors
    @objc func handleSignup() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullnameTextField.text else { return }
        guard let username = usernameTextField.text else { return }
        guard let phoneNumber = phoneNumberTextField.text else { return }
        guard let description = descriptionTextField.text else { return }
        
        guard usernameTextField.text?.isValidInput() == true else {
            self.showAlert(withMsg: "User name only contain lower/upper alphabets, numbers and underscore only.")
            return
        }
        
        guard (usernameTextField.text?.count ?? 0) > 2  else {
            self.showAlert(withMsg: "Username must contain atleast 3 characters.")
            return
        }

        
        guard usernameTextField.text?.lowercased().contains("zeed") == false else {
            self.showAlert(withMsg: "Please remove Zeed from your user name.")
            return
        }

        guard fullnameTextField.text?.lowercased().contains("zeed") == false else {
            self.showAlert(withMsg: "Please remove Zeed from your full name.")
            return
        }

        
        Service.shared.registerUser(fullname: fullname, username: username, email: email, password: password, phone: phoneNumber, about: description, imageId: imageId) { (status, message) in
            if status {
                let obj = SelectIntrestViewController()
                self.navigationController?.pushViewController(obj, animated: true)
                
                //                guard let controller = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController as? TabBarController else { return }
                //                controller.checkIfTheUserIsLoggedIn()
                //                self.dismiss(animated: false, completion: nil)
                
                if let currentUser = AppUser.shared.getDefaultUser() {
                    let obj = ADJEvent.init(eventToken: "nnti3f")
                    obj?.addPartnerParameter("displayname", value: fullname)
                    obj?.addPartnerParameter("email", value: email)
                    obj?.addPartnerParameter("username", value: username)
                    obj?.addPartnerParameter("mobile", value: phoneNumber)
                    obj?.addPartnerParameter("userId", value: currentUser.id)
                    obj?.addPartnerParameter("device_id", value: Utility.getDeviceId())
                    obj?.addPartnerParameter("detail", value: description)
                    Adjust.trackEvent(obj)
                }
                    
                
            } else {
                guard let message = message else { return }
                self.showAlert(withMsg: message)
            }
        }
    }
    
    @objc func handlePop() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange() {
        registerButton.isEnabled = false
        
        guard fullnameTextField.text?.isEmpty == false && usernameTextField.text?.isEmpty == false && emailTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false && confirmPasswordTextField.text?.isEmpty == false && phoneNumberTextField.text?.isEmpty == false else { return }
        registerButton.isEnabled = passwordTextField.text == confirmPasswordTextField.text
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    //MARK: - Helper Functions
    func configureUI() {
        view.backgroundColor = .appBackgroundColor
        
        WSForGetCountryCode()
        
        sigupLabel.setDimensions(height: 40, width: view.frame.width - 30)
        appLogo.setDimensions(height: view.frame.width/4, width: view.frame.width/4)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        appLogo.isUserInteractionEnabled = true
        appLogo.addGestureRecognizer(tapGestureRecognizer)
        appLogo.image = UIImage(named: "profileImage")
        
        registerButton.setDimensions(height: 45, width: view.frame.width - 30)
        
        countryCodeTextField.delegate = self
        
        let mobile = UIStackView(arrangedSubviews: [countryCodeTextField, phoneNumberTextField])
        mobile.axis = .horizontal
        mobile.alignment = .fill
        mobile.spacing = 10
        
        
        let textFieldStack = UIStackView(arrangedSubviews: [sigupLabel, fullnameTextField, usernameTextField, emailTextField, passwordTextField, confirmPasswordTextField, mobile])
        textFieldStack.axis = .vertical
        textFieldStack.alignment = .fill
        textFieldStack.distribution = .equalSpacing
        
        view.addSubview(appLogo)
        appLogo.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 15)
        appLogo.centerX(inView: view)
        
        view.addSubview(textFieldStack)
        textFieldStack.anchor(top: appLogo.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 15,  paddingRight: 15)
        
        view.addSubview(registerButton)
        registerButton.anchor(top: textFieldStack.bottomAnchor, paddingTop: 20)
        registerButton.centerX(inView: view)
        
        
        view.addSubview(haveAccountButton)
        haveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 15)
        haveAccountButton.centerX(inView: view)
        
        
        if appDele?.isForArabic == true {
            ConvertArabicViews.init().tranFormingView(toArabic: self.view)
        }
        
    }
    
    func configureFormValidation() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        phoneNumberTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
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
    
    var imageId : String = ""
}


extension SignUpController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        appLogo.image = selectedImage
        appLogo.contentMode = .scaleAspectFill
        appLogo.setRadius(radius: appLogo.viewHeightBy2)
        self.uploadImageToserver(imgage: appLogo.image!)
        picker.dismiss(animated: true, completion: nil)
    }
}


extension SignUpController : UISearchTextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == countryCodeTextField {
            let alert = UIAlertController(title: appDele!.isForArabic ?  Select_Country_Code_ar : Select_Country_Code_en, message: "", preferredStyle: .actionSheet)
            for item in arrForCountry {
                alert.addAction(UIAlertAction(title: item.name, style: .default, handler: { aler in
                    
                }))
            }
            alert.addAction(UIAlertAction(title: appDele!.isForArabic ?  Cancel_ar : Cancel_en, style: .cancel, handler: { aler in
                
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == usernameTextField {
            let cs = CharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered: String = (string.components(separatedBy: cs) as NSArray).componentsJoined(by: "")
            return (string == filtered)
        }
        return true
    }
    
}

