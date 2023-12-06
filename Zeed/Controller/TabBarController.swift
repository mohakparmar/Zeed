//
//  TabBarController.swift
//  Zeed
//
//  Created by Shrey Gupta on 28/02/21.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    //MARK: - Properties

    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Checking Authetication Status
        perform(#selector(openLangScreen), with: nil, afterDelay: 0)
        
        //UITabBarController Delegate
        self.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.tabBar.layer.masksToBounds = true
        self.tabBar.isTranslucent = true
        self.tabBar.barStyle = .default
        self.tabBar.layer.cornerRadius = 20
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                
        self.tabBar.backgroundColor = .white
        self.tabBar.layer.shadowColor = UIColor.black.cgColor
        self.tabBar.layer.shadowOpacity = 0.9
        self.tabBar.layer.shadowOffset = CGSize(width: 1, height: 1)
    }

    
    // Function to create ViewControllers that exists within TabBarController
    func configureTabBarViewControllers() {
        
        // FeedViewController
        let homeVC = HomeController()
        let homeNC = constructNavController(unselectedImage: #imageLiteral(resourceName: "home"), selectedImage: #imageLiteral(resourceName: "home"), rootViewController: homeVC)
        
        // Search Feed Controller
        let searchVC = SearchContainer()
        let searchNC = constructNavController(unselectedImage: #imageLiteral(resourceName: "search"), selectedImage: #imageLiteral(resourceName: "search"), rootViewController: searchVC)
        
        // Select Image Post Controller
        var uploadPostNC = constructNavController(unselectedImage: #imageLiteral(resourceName: "plus"), selectedImage: #imageLiteral(resourceName: "plus"))
        if loggedInUser == nil {
            uploadPostNC = constructNavController(unselectedImage: #imageLiteral(resourceName: "plus"), selectedImage: #imageLiteral(resourceName: "plus"), rootViewController: SignInController())
        }
        
        // Bidding Controller
        let biddingVC = BiddingController(isForSingleItem: false)
        let biddingsNC = constructNavController(unselectedImage: #imageLiteral(resourceName: "bidding"), selectedImage: #imageLiteral(resourceName: "bidding"), rootViewController: biddingVC)
        
        // Profile Controller
//        let profileVC = MyProfileController(style: .plain)
        let profileVC = OtherProfileVC()
        profileVC.userId = AppUser.shared.getDefaultUser()?.id ?? ""
        let profileNC = constructNavController(unselectedImage: #imageLiteral(resourceName: "profile"), selectedImage: #imageLiteral(resourceName: "profile"), rootViewController: profileVC)
        
        // VC to be added to TabMenu Bar
//         viewControllers = [homeNC, searchNC, uploadPostNC, biddingsNC, profileNC]
//        viewControllers = [homeNC, searchNC, biddingsNC, profileNC]
        viewControllers = [homeNC, searchNC, profileNC]

        // Tab Bar Background color
        tabBar.tintColor = .appPrimaryColor
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            tabBar.standardAppearance = appearance
            tabBar.standardAppearance = tabBar.standardAppearance
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        let index = viewControllers?.firstIndex(of: viewController)
//        if index == 2 {
//            if let loggedInUser = AppUser.shared.getDefaultUser() {
//                if loggedInUser.isSeller {
//                    let createPostVC = CreateController()
//                    let navController = UINavigationController(rootViewController: createPostVC)
//                    navController.modalPresentationStyle = .fullScreen
//                    self.present(navController, animated: true, completion: nil)
//                } else {
//                    let becomerSellerVC = BecomeSellerController()
//                    let navController = UINavigationController(rootViewController: becomerSellerVC)
//                    navController.modalPresentationStyle = .fullScreen
//                    self.present(navController, animated: true, completion: nil)
//                }
//            } else {
//                appDele!.loginAlert(con: self)
//            }
//            return false
//        }
        
        return true
    }
    
    func constructNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> (UINavigationController){
        // Construct NavController
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = unselectedImage.withRenderingMode(.alwaysTemplate)
        
        navController.navigationBar.tintColor = .black
        
        // Return NavController
        return navController
    }
    
    //MARK: - Selectors
    
    
    @objc func openLangScreen() {
        let navController = UINavigationController(rootViewController: SelectLanguageController())
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }

    
    @objc func checkIfTheUserIsLoggedIn() {
        if let loggedUser = loggedInUser {
            configureTabBarViewControllers()
            print("DEBUG:- LOGGED IN USER: \(loggedUser.auth)")
            selectedIndex = 0
        } else {
            let navController = UINavigationController(rootViewController: SelectLanguageController())
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true, completion: nil)
        }
    }

    
    @objc func openForGuestUser() {
        configureTabBarViewControllers()
        selectedIndex = 0
    }

    func signOut() {
        AppUser.shared.removeDefaultUser()
        checkIfTheUserIsLoggedIn()
    }
}



