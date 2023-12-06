//
//  NotificationContainer.swift
//  Zeed
//
//  Created by Shrey Gupta on 30/03/21.
//

import UIKit
import Parchment

class NotificationContainer: UIViewController {
    //MARK: - Properties
    
    let requestController = NotificationRequestsController()
    let activitiesController = NotificationActivitiesController()
    
    lazy var pagingViewController = PagingViewController(viewControllers: [requestController, activitiesController])

    //MARK: - UI Elements
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(#imageLiteral(resourceName: "cross"), for: .normal)
        button.setDimensions(height: 19, width: 19)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        button.tintColor = .appPrimaryColor
        return button
    }()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.openScreenView(str_screen_name: "Notification", str_nib_name: self.nibName ?? "")

        configureNavigationBar(largeTitleColor: .appPrimaryColor, backgoundColor: .appBackgroundColor, tintColor: .appPrimaryColor, title: appDele!.isForArabic ? "الإشعارات" : "Notifications", preferredLargeTitle: false)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
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
