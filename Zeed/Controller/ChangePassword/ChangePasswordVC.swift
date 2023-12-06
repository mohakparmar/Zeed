//
//  ForgotPasswordVC.swift
//  Zeed
//
//  Created by JeetBhuva on 04/03/23.
//

import UIKit

class ChangePasswordVC: UIViewController {
    
    //MARK: - UI Elements
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(#imageLiteral(resourceName: "cross"), for: .normal)
        button.setDimensions(height: 19, width: 19)
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        button.tintColor = .appPrimaryColor
        return button
    }()
    
    // MARK: - Outlets
    @IBOutlet weak var txtCurrentPassword: SGTextField!
    @IBOutlet weak var txtNewPassword: SGTextField!
    @IBOutlet weak var txtConfirmPassword: SGTextField!
    @IBOutlet weak var btnSave: UIButton!

    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utility.openScreenView(str_screen_name: "Change_Password", str_nib_name: self.nibName ?? "")

        self.view.backgroundColor = .backgroundWhiteColor
        configureNavigationBar(largeTitleColor: .appPrimaryColor, backgoundColor: .appBackgroundColor, tintColor: .appPrimaryColor, title: appDele!.isForArabic ? Change_Password_ar : Change_Password_en, preferredLargeTitle: false)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        btnSave.layer.cornerRadius = 10.0
        btnSave.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().tranFormingView(toArabic: self.view)
            txtCurrentPassword.placeholder = Current_Password_ar
            txtNewPassword.placeholder = New_Password_ar
            txtConfirmPassword.placeholder = Confirm_Password_ar
       }

    }

    // MARK: - Selector Methods
    @objc func didTapCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapSaveButton() {
        guard let currentPassword = txtCurrentPassword.text else { return }
        guard let newPassword = txtNewPassword.text else { return }
        guard let confirmPassword = txtConfirmPassword.text else { return }
        
        var messagee = ""
        
        if currentPassword.isEmpty {
            messagee = appDele!.isForArabic ? Please_enter_current_password_ar : Please_enter_current_password_en
            self.showAlert(withMsg: messagee)
        } else if newPassword.isEmpty {
            messagee = appDele!.isForArabic ? Please_enter_new_password_ar : Please_enter_new_password_en
            self.showAlert(withMsg: messagee)
        } else if confirmPassword.isEmpty {
            messagee = appDele!.isForArabic ? Please_enter_confirm_password_ar : Please_enter_confirm_password_en
            self.showAlert(withMsg: messagee)
        } else if confirmPassword != newPassword {
            messagee = appDele!.isForArabic ? Password_doesnt_match_ar : Password_doesnt_match_en
            self.showAlert(withMsg: messagee)
        } else {
            Service.shared.changeUserPassword(currentPassword: currentPassword, newPassword: newPassword) { (status, message) in
                debugPrint(message)
                if let status {
                    if status {
                        self.dismiss(animated: true) {
                            messagee = appDele!.isForArabic ? Your_password_has_been_successfully_changed_ar : Your_password_has_been_successfully_changed_en
                            self.showAlert(withMsg: messagee)
                        }
                    } else {
                        guard let message else { return }
                        self.showAlert(withMsg: message)
                    }
                }
            }
        }
    }
}
