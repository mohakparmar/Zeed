//
//  SelectLanguageController.swift
//  Zeed
//
//  Created by Shrey Gupta on 10/04/21.
//

import UIKit

class SelectLanguageController: UIViewController {
    //MARK: - Properties
    
    //MARK: - UI Elements
    private let appLogo: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "zeed2")
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let powerByLogo: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "powerByLogo")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var englishButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("English", for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.hex("#6DC3D6")
        button.isHidden = true
        button.addTarget(self, action: #selector(handleEnglish), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var arabicButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("العربية", for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.hex("#6DC3D6")
        button.isHidden = true
        button.addTarget(self, action: #selector(handleArabic), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.openScreenView(str_screen_name: "Select_Language", str_nib_name: self.nibName ?? "")

        navigationController?.navigationBar.isHidden = true
        
        configureUI()
    }
    
    //MARK: - Selectors
    @objc func handleEnglish() {
        UserDefaults.standard.set("1", forKey: "lang")
        UserDefaults.standard.synchronize()
        appDele?.isForArabic = false
//        navigationController?.pushViewController(SignInController(), animated: true)
        self.openAnalyticsPermission()
    }
    
    @objc func handleArabic() {
        UserDefaults.standard.set("2", forKey: "lang")
        UserDefaults.standard.synchronize()
        appDele?.isForArabic = true
//        navigationController?.pushViewController(SignInController(), animated: true)
        self.openAnalyticsPermission()
    }
    
    
    func openAnalyticsPermission() {
        if (UserDefaults.standard.value(forKey: "CustomAlertPermission") != nil) {
            navigationController?.pushViewController(SignInController(), animated: true)
        } else {
            let obj = AnalyticsPermissionAlertViewController()
            obj.modalPresentationStyle = .fullScreen
            obj.delegate = self
            self.present(obj, animated: true)
        }

    }
    
    //MARK: - Helper Functions
    func configureUI() {
        view.backgroundColor = .appBackgroundColor
        
        let buttonStack = UIStackView(arrangedSubviews: [englishButton, arabicButton])
        buttonStack.alignment = .fill
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 1
        
        buttonStack.backgroundColor = .clear
        buttonStack.layer.cornerRadius = 6
        buttonStack.clipsToBounds = true
        buttonStack.setDimensions(height: 45, width: view.frame.width - (view.frame.width/4))
        
        
        view.addSubview(buttonStack)
        buttonStack.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 10)
        buttonStack.centerX(inView: view)
        
        view.addSubview(appLogo)
        appLogo.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: view.frame.height/6)
        appLogo.centerX(inView: view)
        appLogo.setDimensions(height: 280, width: 280)


        view.addSubview(powerByLogo)
        powerByLogo.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 100)
        powerByLogo.centerX(inView: view)
        
        if let loggedUser = loggedInUser {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                guard let controller = UIApplication.shared.windows.filter({$0.isKeyWindow}).first!.rootViewController as? TabBarController else { return }
                controller.checkIfTheUserIsLoggedIn()
                self.dismiss(animated: false, completion: nil)
            })
        } else {
            englishButton.isHidden = false
            arabicButton.isHidden = false
        }
//        powerByLogo.setDimensions(height: 280, width: 280)

    }
}

extension SelectLanguageController : CustomAlertDelegate {
    func btnContinuePress() {
        navigationController?.pushViewController(SignInController(), animated: true)
    }
}
