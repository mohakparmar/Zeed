//
//  MyAuctionsContainer.swift
//  Zeed
//
//  Created by Shrey Gupta on 02/04/21.
//

import UIKit
import Parchment

class MyAuctionsContainer: UIViewController {
    //MARK: - Properties
    
    let ongoingController = MyAuctionsOnGoingController()
    let completedController = MyAuctionsCompletedController()
    
    lazy var pagingViewController = PagingViewController(viewControllers: [ongoingController, completedController])

    //MARK: - UI Elements


    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.openScreenView(str_screen_name: "My_Auctions", str_nib_name: self.nibName ?? "")

        configureNavigationBar(largeTitleColor: .appPrimaryColor, backgoundColor: .appBackgroundColor, tintColor: .appPrimaryColor, title: "My Auctions", preferredLargeTitle: false)
        
        configure()
    }
    
    //MARK: - Selector
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helper Functions
    func configure() {
        view.backgroundColor = .appBackgroundColor
        
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

