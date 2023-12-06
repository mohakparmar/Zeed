//
//  EditMyProfileController.swift
//  Zeed
//
//  Created by Shrey Gupta on 14/05/21.
//

import UIKit

class EditProfileController: UIViewController {
    //MARK: - Properties
    private let imagePicker = UIImagePickerController()
    
    //MARK: - UI Elements
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SAVE", for: .normal)
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

    
    private lazy var profileImageButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "profileImage").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setDimensions(height: view.frame.width/4 , width: view.frame.width/4)
        button.layer.cornerRadius = view.frame.width/8
        
        button.addTarget(self, action: #selector(didTapUpdateImage), for: .touchUpInside)
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var nameTextFeild: SGTextField = {
        let tf = SGTextField()
        tf.placeholder = "Name"
        tf.placeholderLabel.textColor = .lightGray
        tf.borderInactiveColor = .lightGray
        tf.borderActiveColor = .appPrimaryColor
        tf.placeholderFontScale = 1
        tf.anchor(height: 50)
        return tf
    }()
    
    private lazy var emailTextFeild: SGTextField = {
        let tf = SGTextField()
        tf.placeholder = "Email"
        tf.placeholderLabel.textColor = .lightGray
        tf.borderInactiveColor = .lightGray
        tf.borderActiveColor = .appPrimaryColor
        tf.placeholderFontScale = 1
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    private lazy var phoneTextFeild: SGTextField = {
        let tf = SGTextField()
        tf.placeholder = "Mobile No."
        tf.placeholderLabel.textColor = .lightGray
        tf.borderInactiveColor = .lightGray
        tf.borderActiveColor = .appPrimaryColor
        tf.keyboardType = .phonePad
        tf.placeholderFontScale = 1
        
        return tf
    }()
    
    private lazy var updateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("UPDATE", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.backgroundColor = .appPrimaryColor
        button.setTitleColor(.white, for: .normal)
        
        button.layer.cornerRadius = 5
        
        button.setDimensions(height: 40, width: 120)
        return button
    }()
    
    
    //MARK: - Lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundWhiteColor
        
        Utility.openScreenView(str_screen_name: "Edit_Profile", str_nib_name: self.nibName ?? "")

        configureNavigationBar(largeTitleColor: .appPrimaryColor, backgoundColor: .appBackgroundColor, tintColor: .appPrimaryColor, title: "Edit My Profile", preferredLargeTitle: false)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        
        setupToHideKeyboardOnTapOnView()
        configureUI()
        
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        updateUser()
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
    
    
    //MARK: - Selectors
    @objc func didTapUpdateImage() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapSave() {
        
    }
    
    //MARK: - Helper Functions
    func configureUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        
        view.addSubview(profileImageButton)
        profileImageButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 15)
        profileImageButton.centerX(inView: view)
        
        let stack = UIStackView(arrangedSubviews: [nameTextFeild, emailTextFeild, phoneTextFeild])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 5
        
        view.addSubview(stack)
        stack.anchor(top: profileImageButton.bottomAnchor, paddingTop: 18, width: view.frame.width - 30)
        stack.centerX(inView: view)
        
        view.addSubview(updateButton)
        updateButton.isHidden = true
        updateButton.anchor(top: stack.bottomAnchor, paddingTop: 20)
        updateButton.centerX(inView: view)
    }
    
    func updateUser() {
        guard let user = AppUser.shared.getDefaultUser() else { return }
        profileImageButton.setImage(imageCache[user.image.url], for: .normal)
        nameTextFeild.text = user.userName
        emailTextFeild.text = user.email
        phoneTextFeild.text = user.mobileNumber
    }
}

extension EditProfileController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        profileImageButton.setImage(selectedImage, for: .normal)
        picker.dismiss(animated: true, completion: nil)
    }
}

