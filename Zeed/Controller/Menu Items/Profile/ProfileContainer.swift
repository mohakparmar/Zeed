//
//  ProfileController.swift
//  Zeed
//
//  Created by Shrey Gupta on 28/02/21.
//

import UIKit
import Parchment

class ProfileContainer: UIViewController {
    //MARK: - Properties
    
    private lazy var userInfoView = ProfileUserInfo()
    
    let buyerViewController = ProfileBuyerViewController()
    let sellerViewController = ProfileSellerViewController()
    


    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userInfoView.delegate = self
        buyerViewController.delegate = self
        
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        configureNavigationBar(largeTitleColor: .appPrimaryColor, backgoundColor: .appBackgroundColor, tintColor: .appPrimaryColor, title: "Account", preferredLargeTitle: false)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: .appBackgroundColor), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = .appPrimaryColor
        self.navigationController?.navigationBar.barTintColor = .appBackgroundColor
        self.navigationItem.title = appDele!.isForArabic ? Account_ar : Account_en
        
        navigationController?.navigationBar.update(backroundColor: .white, titleColor: .appPrimaryColor)
    }
    
    

    //MARK: - Selector
    
    //MARK: - Helper Functions
    func configure() {
        view.backgroundColor = .white

        var pagingViewController = PagingViewController(viewControllers: [buyerViewController, sellerViewController])

        let currentUser = AppUser.shared.getDefaultUser()
        if currentUser?.isSeller ?? false == false  {
            pagingViewController = PagingViewController(viewControllers: [buyerViewController])
        }

        
        self.navigationController?.extendedLayoutIncludesOpaqueBars = true

        view.addSubview(userInfoView)
        userInfoView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.rightAnchor, height: 126)
        
        pagingViewController.backgroundColor = .appBackgroundColor
        pagingViewController.selectedBackgroundColor = .appBackgroundColor
        pagingViewController.indicatorColor = .appPrimaryColor
        pagingViewController.textColor = .lightGray
        pagingViewController.selectedTextColor = .appPrimaryColor
        pagingViewController.menuItemSize = .sizeToFit(minWidth: 100, height: 45)
        
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            pagingViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            pagingViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            pagingViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pagingViewController.view.topAnchor.constraint(equalTo: userInfoView.safeAreaLayoutGuide.bottomAnchor)
        ])
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().tranFormingView(toArabic: self.view)
            pagingViewController.view.transform  = trnForm_Ar
        }
        
    }
}

//MARK: - Delegate ProfileBuyerControllerDelegate
extension ProfileContainer: ProfileBuyerControllerDelegate {
    func profileBuyer(_ profileBuyerController: ProfileBuyerViewController, didSelectController controller: UIViewController) {
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - Delegate ProfileUserInfoDelegate
extension ProfileContainer: ProfileUserInfoDelegate {
    func didTapEditButton() {
        let controller = UINavigationController(rootViewController: EditMyProfileController1())
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
}
