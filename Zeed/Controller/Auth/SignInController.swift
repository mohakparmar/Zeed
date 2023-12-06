//
//  SignInController.swift
//  Zeed
//
//  Created by Shrey Gupta on 10/04/21.
//

import UIKit

class SignInController: UIViewController {
    //MARK: - Properties
    
    //MARK: - UI Elements
    private let appLogo: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "zeed_logo")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let siginLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Sign_In_ar : Sign_In_en
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .appPrimaryColor
        return label
    }()
    
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
    
    private lazy var signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .appBrightBlueColor
        button.setTitle(appDele!.isForArabic ? Sign_Up_ar : Sign_Up_en, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        
        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .appBrightBlueColor
        button.setTitle(appDele!.isForArabic ? Sign_In_ar : Sign_In_en, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var appleButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setImage(#imageLiteral(resourceName: "apple").withRenderingMode(.alwaysOriginal), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        
        button.addTarget(self, action: #selector(handleAppleLogin), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var facebookButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.hex("#164CBD")
        button.setImage(#imageLiteral(resourceName: "facebook").withRenderingMode(.alwaysOriginal), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        
        button.addTarget(self, action: #selector(handleFacebookLogin), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var googleButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.hex("#DD4B39")
        button.setImage(#imageLiteral(resourceName: "google").withRenderingMode(.alwaysOriginal), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        
        button.addTarget(self, action: #selector(handleGoogleLogin), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var guestButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .appBrightBlueColor
        button.setTitle(appDele!.isForArabic ? Continue_as_a_Guest_ar : Continue_as_a_Guest_en, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        
        button.addTarget(self, action: #selector(handleGuest), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(appDele!.isForArabic ? Forgot_Password_ar : Forgot_Password_en, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(forgorPassword), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        emailTextField.text = "iosuser100"
//        passwordTextField.text = "123456"
        
//        loginButton.isEnabled = false
        
        Utility.openScreenView(str_screen_name: "Login", str_nib_name: self.nibName ?? "")

        configureUI()
        configureFormValidation()
        
        setupToHideKeyboardOnTapOnView()
    }
    
    //MARK: - Selectors
    @objc func handleSignup() {
        navigationController?.pushViewController(SignUpController(), animated: true)
    }
    
    @objc func forgorPassword() {
        guard let email = emailTextField.text else {
            Utility.showISMessage(str_title: appDele!.isForArabic ? Please_enter_a_valid_email_id_ar : Please_enter_a_valid_email_id_en, Message: "", msgtype: .error)
            return }
        Service.shared.forgorPassword(email: email) { (status, message) in
            print(message)
            if status {
                Utility.showISMessage(str_title: appDele!.isForArabic ? Please_check_your_email_account_for_the_password_reset_link_ar : Please_check_your_email_account_for_the_password_reset_link_en, Message: "", msgtype: .success)
            } else {
                guard let message = message else { return }
                self.showAlert(withMsg: message)
            }
        }
    }

    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Service.shared.loginUser(email: email, password: password) { (status, message) in
            print(message)
            if status {
//                let obj = SelectIntrestViewController()
//                self.navigationController?.pushViewController(obj, animated: true)
//                return
                guard let controller = UIApplication.shared.windows.filter({$0.isKeyWindow}).first!.rootViewController as? TabBarController else { return }
                controller.checkIfTheUserIsLoggedIn()
                self.dismiss(animated: false, completion: nil)

            } else {
                guard let message = message else { return }
                self.showAlert(withMsg: message)
            }
        }
    }
    
    @objc func handleAppleLogin() {
        print("DEBUG:- handleAppleLogin")
    }
    
    @objc func handleFacebookLogin() {
        print("DEBUG:- handleFacebookLogin")
    }
    
    @objc func handleGoogleLogin() {
        print("DEBUG:- handleGoogleLogin")
    }
    
    @objc func handleGuest() {
        guard let controller = UIApplication.shared.windows.filter({$0.isKeyWindow}).first!.rootViewController as? TabBarController else { return }
        controller.openForGuestUser()
        self.dismiss(animated: false, completion: nil)
        print("DEBUG:- On progress")
    }
    
    @objc func textDidChange() {
        loginButton.isEnabled = emailTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false
    }
    
    //MARK: - Helper Functions
    func configureUI() {
        view.backgroundColor = .appBackgroundColor
        
        siginLabel.setDimensions(height: 40, width: view.frame.width - 30)
        appLogo.setDimensions(height: view.frame.width/4, width: view.frame.width/4)
        
        let buttonStack = UIStackView(arrangedSubviews: [signupButton, loginButton])
        buttonStack.axis = .horizontal
        buttonStack.alignment = .fill
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 18
        
        let socialStack = UIStackView(arrangedSubviews: [appleButton, facebookButton, googleButton])
        socialStack.axis = .horizontal
        socialStack.alignment = .fill
        socialStack.distribution = .fillEqually
        socialStack.spacing = 8
        
        buttonStack.setDimensions(height: 50, width: view.frame.width - 30)
        socialStack.setDimensions(height: 40, width: view.frame.width - (view.frame.width/3))
        guestButton.setDimensions(height: 45, width: view.frame.width - 30)
        
        let allStack = UIStackView(arrangedSubviews: [buttonStack, guestButton])
//        let allStack = UIStackView(arrangedSubviews: [buttonStack, socialStack, guestButton])
        allStack.axis = .vertical
        allStack.alignment = .center
        allStack.distribution = .equalSpacing
        allStack.spacing = 40

        let textFieldStack = UIStackView(arrangedSubviews: [siginLabel, emailTextField, passwordTextField])
        textFieldStack.axis = .vertical
        textFieldStack.alignment = .fill
        textFieldStack.distribution = .equalSpacing
        textFieldStack.setDimensions(height: 180, width: view.frame.width - 30)
        
        
        let mainStack = UIStackView(arrangedSubviews: [appLogo, textFieldStack, buttonStack, guestButton])
        mainStack.alignment = .center
        mainStack.distribution = .equalSpacing
        mainStack.axis = .vertical
        
        mainStack.setCustomSpacing(8, after: siginLabel)
        
        view.addSubview(mainStack)
        mainStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 15, paddingBottom: 30, paddingRight: 15)
        
        view.addSubview(forgotPasswordButton)
        forgotPasswordButton.anchor(top: passwordTextField.bottomAnchor, right: mainStack.rightAnchor, paddingTop: 10, paddingRight: 15)
        
        if appDele?.isForArabic == true {
            ConvertArabicViews.init().tranFormingView(toArabic: self.view)
        }
        
        
    }
    
    func configureFormValidation() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
}
