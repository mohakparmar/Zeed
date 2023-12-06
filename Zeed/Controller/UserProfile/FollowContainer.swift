//
//  FollowContainer.swift
//  Zeed
//
//  Created by Shrey Gupta on 30/03/21.
//
import UIKit
import Parchment

class FollowContainer: UIViewController {
    
    //MARK: - Properties
    var type: UserProfileStatsCellTypes
    var user: User
    
    lazy var usersController = FollowResultController(forUser: user, from: type, type: .users)
    lazy var allController = FollowResultController(forUser: user, from: type, type: .all)
    lazy var sellerController = FollowResultController(forUser: user, from: type, type: .seller)
    
    lazy var pagingViewController = PagingViewController(viewControllers: [usersController, sellerController, allController])


    //MARK: - Lifecycle
    init(forUser user: User, type: UserProfileStatsCellTypes) {
        self.type = type
        self.user = user
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = type.description
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.openScreenView(str_screen_name: "Follower_List", str_nib_name: self.nibName ?? "")

        configure()
    }
    
    //MARK: - Selector
    
    //MARK: - Helper Functions
    func configure() {
        view.backgroundColor = .white
        
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
        pagingViewController.delegate = self
    }
}


extension FollowContainer : PagingViewControllerDelegate {
    func pagingViewController(_: PagingViewController, isScrollingFromItem currentPagingItem: PagingItem, toItem upcomingPagingItem: PagingItem?, startingViewController: UIViewController, destinationViewController: UIViewController?, progress: CGFloat) {
            
    }
    
    func pagingViewController(_: PagingViewController, willScrollToItem pagingItem: PagingItem, startingViewController: UIViewController, destinationViewController: UIViewController) {
            
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {
        
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, didSelectItem pagingItem: PagingItem) {
        
    }
}
