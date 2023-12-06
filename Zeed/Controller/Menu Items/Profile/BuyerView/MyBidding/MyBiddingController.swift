//
//  MyBiddingController.swift
//  Zeed
//
//  Created by Shrey Gupta on 15/03/21.
//

import UIKit
import Parchment

class MyBiddingController: UIViewController {
    //MARK: - Properties
    let onGoingController = BiddingOnGoingController()
    let lostController = BiddingLostController()
    let wonController = BiddingWonController()
    
    lazy var pagingViewController = PagingViewController(viewControllers: [onGoingController, lostController, wonController])


    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.openScreenView(str_screen_name: "My_Bidding", str_nib_name: self.nibName ?? "")

        navigationItem.title = appDele!.isForArabic ? My_Biddings_ar : My_Biddings_en
        configure()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let tabBarFrame = self.tabBarController?.tabBar.frame {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
                self.tabBarController?.tabBar.frame.origin.y = UIScreen.main.bounds.size.height - tabBarFrame.height
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.tabBarController?.tabBar.frame.origin.y = UIScreen.main.bounds.size.height
        })
    }
    
    //MARK: - Selectors
    
    //MARK: - Helper Functions
    func configure() {
        view.backgroundColor = .white
        
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
            pagingViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
}

extension MyBiddingController: ProfileBuyerControllerDelegate {
    func profileBuyer(_ profileBuyerController: ProfileBuyerViewController, didSelectController controller: UIViewController) {
        navigationController?.pushViewController(controller, animated: true)
    }
}
