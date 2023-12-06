//
//  UserProfileItemsCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 04/03/21.
//

import UIKit
import Parchment

protocol UserProfileItemsContainerCellDelegate: AnyObject {
    func didSelectItem(withId id: String, ofType: PostType, post: PostItem)
}

class UserProfileItemsContainerCell: UITableViewCell {
    //MARK: - Properties
    weak var delegate: UserProfileItemsContainerCellDelegate?
    
    var user: User?
    let productItems = UserProfileProductItems()
    let purchasedItems = UserProfilePurchasedItems()
    
    lazy var pagingViewController = PagingViewController(viewControllers: [productItems, purchasedItems])
    
    //MARK: - UI Elements
    
    
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        if let user = self.user {
            productItems.user = self.user
            purchasedItems.user = self.user
            if user.isSeller == true {
                pagingViewController = PagingViewController(viewControllers: [productItems, purchasedItems])
            } else {
                pagingViewController = PagingViewController(viewControllers: [purchasedItems])
            }
        } else {
            let currentUser = AppUser.shared.getDefaultUser()
            productItems.user = currentUser
            purchasedItems.user = currentUser
            if currentUser?.isSeller ?? false == true {
                pagingViewController = PagingViewController(viewControllers: [productItems, purchasedItems])
            } else {
                pagingViewController = PagingViewController(viewControllers: [purchasedItems])
            }
        }
        productItems.delegate = self
        purchasedItems.delegate = self
        
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPageController() {
        pagingViewController.view.removeFromSuperview()
        if let user = self.user {
            productItems.user = self.user
            purchasedItems.user = self.user
            if user.isSeller == true {
                pagingViewController = PagingViewController(viewControllers: [productItems, purchasedItems])
            } else {
                pagingViewController = PagingViewController(viewControllers: [purchasedItems])
            }
            configureCell()
        }
    }
    
    
    //MARK: - Selectors
    
    //MARK: - Helper Functions
    func configureCell() {
        backgroundColor = .appBackgroundColor
        pagingViewController.backgroundColor = .appBackgroundColor
        pagingViewController.selectedBackgroundColor = .appBackgroundColor
        
        pagingViewController.indicatorColor = .appPrimaryColor
        pagingViewController.textColor = .appPrimaryColor
        pagingViewController.selectedTextColor = .appPrimaryColor
        pagingViewController.menuItemSize = .sizeToFit(minWidth: 100, height: 45)
        
        contentView.addSubview(pagingViewController.view)
        pagingViewController.view.fillSuperview()
        
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        if appDele!.isForArabic == true {
            pagingViewController.view.transform = trnForm_Ar
        }
    }
}

extension UserProfileItemsContainerCell: UserProfileProductItemsDelegate {
    func didselectCategory(withId id: String) {
        
    }
    
    func didSelectProduct(withId id: String, ofType type: PostType, post:PostItem) {
        delegate?.didSelectItem(withId: id, ofType: type, post: post)
    }
}


extension UserProfileItemsContainerCell: UserProfilePurchasedItemsDelegate {
    func didSelectPurchase(withId id: String, ofType type: PostType, post: PostItem?) {
        delegate?.didSelectItem(withId: id, ofType: type, post: post ?? PostItem(dict: [:]))
    }
}
