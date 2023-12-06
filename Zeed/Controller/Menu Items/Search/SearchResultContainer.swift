//
//  SearchResultController.swift
//  Zeed
//
//  Created by Shrey Gupta on 02/03/21.
//

import UIKit
import Parchment

class SearchResultContainer: UIViewController {
    
    var isHighLow: Bool = false {
        didSet {
            productResultsController.isHighLow = isHighLow
        }
    }
    
    //MARK: - Properties
    var searchText: String = "" {
        didSet {
            if index == 0 {
                userResultsController.searchText = searchText
            } else {
                productResultsController.searchText = searchText
            }
        }
    }
    
    let userResultsController = SearchUserResultsController()
    let productResultsController = SearchProductsResultsController()
    
    lazy var pagingViewController = PagingViewController(viewControllers: [userResultsController, productResultsController])


    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    var index : Int = 0
    
    //MARK: - Selector
    
    //MARK: - Helper Functions
    func configure() {
        view.backgroundColor = .appBackgroundColor
        
        
        pagingViewController.delegate = self
        
        pagingViewController.backgroundColor = .white
        pagingViewController.selectedBackgroundColor = .white
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

extension SearchResultContainer : PagingViewControllerDelegate {
    func pagingViewController(_: Parchment.PagingViewController, isScrollingFromItem currentPagingItem: Parchment.PagingItem, toItem upcomingPagingItem: Parchment.PagingItem?, startingViewController: UIViewController, destinationViewController: UIViewController?, progress: CGFloat) {
        if startingViewController is SearchUserResultsController {
            index = 1
        } else {
            index = 0
        }
    }
    
    func pagingViewController(_: Parchment.PagingViewController, willScrollToItem pagingItem: Parchment.PagingItem, startingViewController: UIViewController, destinationViewController: UIViewController) {
        
    }
    
    func pagingViewController(_ pagingViewController: Parchment.PagingViewController, didScrollToItem pagingItem: Parchment.PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {
            
    }
    
    func pagingViewController(_ pagingViewController: Parchment.PagingViewController, didSelectItem pagingItem: Parchment.PagingItem) {

    }}
 
