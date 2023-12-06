//
//  SearchController.swift
//  Zeed
//
//  Created by Shrey Gupta on 28/02/21.
//

import UIKit
import SquareFlowLayout

class SearchContainer: UIViewController {
    //MARK: - Properties
    private let exploreController = ExploreController()
    private let searchResultsController = SearchResultContainer()
    

    var isLowTohigh : Bool = true
    var selectedCategory: ItemCategory?
    var categoryPicker = CategoryPicker()
    var blackView = UIView()
    //MARK: - UI Elements
    private lazy var searchBar: UISearchBar = {
        let sb = UISearchBar(frame: CGRect.zero)
        sb.searchBarStyle = .minimal
        sb.placeholder = appDele!.isForArabic ? Search_ar : Search_en
        sb.delegate = self
        if #available(iOS 13.0, *) {
            sb.searchTextField.textAlignment = appDele!.isForArabic ? .right : .left
        } else {
            // Fallback on earlier versions
        }
        return sb
    }()
    
    var allCategories: [ItemCategory] = []
    let collectionCategory :UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 60), collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        collection.backgroundColor = .appBackgroundColor
        return collection
    }()

    
    private lazy var cartButton: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(#imageLiteral(resourceName: "cartWithOutBadge"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: -12, left: 0, bottom: 0, right: 0);
        button.setDimensions(height: 30, width: 30)
        button.addTarget(self, action: #selector(handleCart), for: .touchUpInside)
        button.tintColor = .appPrimaryColor
        return button
    }()

    
    func addBadge(itemvalue: String) -> BadgeButton {
        let bagButton = BadgeButton()
        bagButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        bagButton.tintColor = .appPrimaryColor
        bagButton.imageEdgeInsets = UIEdgeInsets(top: -12, left: 0, bottom: 0, right: 0);
        bagButton.setImage(UIImage(named: "cartWithOutBadge")?.withRenderingMode(.alwaysTemplate), for: .normal)
        bagButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 15)
        bagButton.badge = itemvalue
        bagButton.addTarget(self, action: #selector(handleCart), for: .touchUpInside)
        return bagButton
    }
    
    //MARK: - API
    func fetchCartItems() {
        if appDele!.isForArabic {
            navigationItem.titleView = searchBar
            navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: messageButton), UIBarButtonItem(customView: self.addBadge(itemvalue: "0"))]
        } else {
            navigationItem.titleView = searchBar
            navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: messageButton), UIBarButtonItem(customView: self.addBadge(itemvalue: "0"))]
        }
        Service.shared.getCartItems { (cartItems, status, message) in
            if status {
                guard let cartItems = cartItems else { return }
                appDele?.arrForCart = cartItems
                if cartItems.count > 0 {
                    if appDele!.isForArabic {
                        self.navigationItem.titleView = self.searchBar
                        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: self.messageButton), UIBarButtonItem(customView: self.addBadge(itemvalue: "\(cartItems.count)"))]
                    } else {
                        self.navigationItem.titleView = self.searchBar
                        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: self.messageButton), UIBarButtonItem(customView: self.addBadge(itemvalue: "\(cartItems.count)"))]
                    }
                }
            }
        }
    }

    
    private lazy var messageButton: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(named: "message"), for: .normal)
        button.setDimensions(height: 30, width: 30)
        button.imageEdgeInsets = UIEdgeInsets(top: -12, left: 0, bottom: 0, right: 0);
        button.addTarget(self, action: #selector(handleMessages), for: .touchUpInside)
        button.tintColor = .appPrimaryColor
        return button
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(#imageLiteral(resourceName: "filter"), for: .normal)
        button.setDimensions(height: 30, width: 30)
        button.imageEdgeInsets = UIEdgeInsets(top: -12, left: 0, bottom: 0, right: 0);
        button.addTarget(self, action: #selector(handleFilter), for: .touchUpInside)
        button.tintColor = .appPrimaryColor
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(#imageLiteral(resourceName: "cross"), for: .normal)
        button.setDimensions(height: 19, width: 19)
        button.imageEdgeInsets = UIEdgeInsets(top: -12, left: 0, bottom: 0, right: 0);
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        button.tintColor = .appPrimaryColor
        return button
    }()

    
    private lazy var sortButton: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(named: "sort_ascending"), for: .normal)
        button.setDimensions(height: 19, width: 19)
        button.imageEdgeInsets = UIEdgeInsets(top: -12, left: 0, bottom: 0, right: 0);
        button.addTarget(self, action: #selector(sortItemClick), for: .touchUpInside)
        button.tintColor = .appPrimaryColor
        return button
    }()


    
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryPicker.delegate = self
        
        collectionCategory.delegate = self
        collectionCategory.dataSource = self
        collectionCategory.showsHorizontalScrollIndicator = false
        collectionCategory.showsVerticalScrollIndicator = false
        collectionCategory.registerNib(nibName: "CategoryCCell", reUse: "CategoryCCell")
        
        configureNavigationBar(largeTitleColor: .appPrimaryColor, backgoundColor: .appBackgroundColor, tintColor: .appPrimaryColor, title: "", preferredLargeTitle: false)

        
//        if appDele!.isForArabic {
//            navigationItem.titleView = searchBar
//            navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: cartButton), UIBarButtonItem(customView: messageButton)]
//        } else {
//            navigationItem.titleView = searchBar
//            navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: messageButton), UIBarButtonItem(customView: cartButton)]
//        }
        configure()
        if appDele?.isForSearch == false {
            fetchCategories()
        }
    }
        
    override func viewWillAppear(_ animated: Bool) {
        if appDele?.isForSearch == true {
            searchBar.becomeFirstResponder()
            searchResultsPressed()
        }
        fetchCartItems()
    }
    
    //MARK: - Selectors
    @objc func sortItemClick() {
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.tabBarController?.tabBar.frame.origin.y = UIScreen.main.bounds.size.height
        })

        self.view.endEditing(true)
        searchBar.resignFirstResponder()
        let viewAlert = SortOptionView.instantiate(frame: self.view.frame)
        viewAlert.btnHideViewClick = {
            viewAlert.removeFromSuperview()
        }
        viewAlert.btnHighToLowClick = {
            self.isLowTohigh = false
            self.searchResultsController.isHighLow = self.isLowTohigh
            self.exploreController.isPriceLowToHigh = self.isLowTohigh
            self.sortButton.setImage(UIImage(named:  self.isLowTohigh ? "sort_ascending" : "sort_decending"), for: .normal)
            if let tabBarFrame = self.tabBarController?.tabBar.frame {
                UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
                    self.tabBarController?.tabBar.frame.origin.y = UIScreen.main.bounds.size.height - tabBarFrame.height
                })
            }
            viewAlert.removeFromSuperview()
        }
        viewAlert.btnLowToHighClick = {
            self.isLowTohigh = true
            self.searchResultsController.isHighLow = self.isLowTohigh
            self.exploreController.isPriceLowToHigh = self.isLowTohigh
            self.sortButton.setImage(UIImage(named:  self.isLowTohigh ? "sort_ascending" : "sort_decending"), for: .normal)
            if let tabBarFrame = self.tabBarController?.tabBar.frame {
                UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
                    self.tabBarController?.tabBar.frame.origin.y = UIScreen.main.bounds.size.height - tabBarFrame.height
                })
            }
            viewAlert.removeFromSuperview()
        }
        
        self.view.addSubview(viewAlert)

//        isLowTohigh = !isLowTohigh
//        self.searchResultsController.isHighLow = isLowTohigh
//        sortButton.setImage(UIImage(named:  isLowTohigh ? "sort_ascending" : "sort_decending"), for: .normal)
//        self.exploreController.isPriceLowToHigh = isLowTohigh
    }
    
    //MARK: - Selectors
    @objc func handleCart() {
//        if loggedInUser == nil {
//            appDele!.loginAlert(con: self)
//            return
//        }
        let controller = UINavigationController(rootViewController: CartController(collectionViewLayout: UICollectionViewFlowLayout()))
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
    @objc func handleFilter() {
//        if loggedInUser == nil {
//            appDele!.loginAlert(con: self)
//            return
//        }
        bringCategoryPicker()
    }
    
    @objc func handleMessages() {
//        if loggedInUser == nil {
//            appDele!.loginAlert(con: self)
//            return
//        }
        let controller = UINavigationController(rootViewController: ChatListViewController())
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .coverVertical
        
        present(controller, animated: true, completion: nil)
    }
    
    @objc func handleCancel() {
        
        if appDele!.isForArabic {
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: UIView())
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIView())
        }
        
        explorePressed()
        searchBar.text?.removeAll()
        if appDele?.isForSearch == true {
            let tabController = appDele?.window?.rootViewController as? TabBarController
            tabController?.selectedIndex = 0
            appDele?.isForSearch = false
        }
    }
    
    @objc func dismissPicker() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.blackView.alpha = 0
            self.categoryPicker.frame.origin.y = self.view.frame.height
        } completion: { (_) in
            self.blackView.removeFromSuperview()
            self.categoryPicker.removeFromSuperview()
        }
    }
    
    
    
    //MARK: - API
    func fetchCategories() {
        Service.shared.getAllCategories { (allCategories, status, message) in
            if status {
                guard let allCategories = allCategories else { return }
                
                var dict : [String:Any] = [:]
                dict["id"] = ""
                dict["name"] = " All "
                dict["name_ar"] = " الجميع "
                let objCate = ItemCategory(dict: dict)
                self.allCategories.append(objCate)
                self.allCategories.append(contentsOf: allCategories)

//                self.allCategories = allCategories
                self.categoryPicker.allCategories = self.allCategories
                if self.allCategories.count > 0 {
                    self.selectedCategory = self.allCategories[0]
                    self.exploreController.allPosts = []
                    self.exploreController.collectionView.reloadData()
                    self.exploreController.cID = self.selectedCategory?.id ?? ""
                    self.exploreController.allPosts = []
                    self.exploreController.fetchAllPosts()
                    self.collectionCategory.reloadData()
                }
            } else {
                guard let message = message else { return }
//                self.showAlert(withMsg: "Error fetching categories: \(message)")
            }
        }
    }
    
    //MARK: - Helper Functions
    func configure() {
        explorePressed()
    }
    
    @objc func explorePressed() {
        self.view.endEditing(true)
        self.searchBar.endEditing(true)
        collectionCategory.removeFromSuperview()
        searchResultsController.removeFromParent()
        exploreController.viewDidLoad()
        exploreController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        addChild(exploreController)
        exploreController.didMove(toParent: self)
        view.addSubview(exploreController.view)
        view.addSubview(collectionCategory)
        
        if appDele!.isForArabic {
            navigationItem.titleView = searchBar
            navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: cartButton), UIBarButtonItem(customView: messageButton)]
        } else {
            navigationItem.titleView = searchBar
            navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: messageButton), UIBarButtonItem(customView: cartButton)]
        }
        
        UIApplication.shared.keyWindow!.bringSubviewToFront(self.navigationController!.navigationBar)
    }
    
    @objc func searchResultsPressed() {
//        if loggedInUser == nil {
//            appDele!.loginAlert(con: self)
//            return
//        }
        collectionCategory.removeFromSuperview()
        exploreController.removeFromParent()
        searchResultsController.viewDidLoad()
        searchResultsController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        addChild(searchResultsController)
        searchResultsController.didMove(toParent: self)
        view.addSubview(searchResultsController.view)
    }
    
    func bringBlackView() {
        blackView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        blackView.alpha = 0

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
        blackView.gestureRecognizers = [tap]
        blackView.isUserInteractionEnabled = true
        
        UIApplication.shared.keyWindow?.addSubview(blackView)
        blackView.fillSuperview()
    }
    
    func bringCategoryPicker() {
        categoryPicker.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3)
        
        bringBlackView()
        
        UIApplication.shared.keyWindow?.addSubview(categoryPicker)

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.blackView.alpha = 1
            self.categoryPicker.frame.origin.y = UIScreen.main.bounds.height - (UIScreen.main.bounds.height/3)
        }
    }
    
}

//MARK: - Delegate UISearchBarDelegate
extension SearchContainer: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if appDele!.isForArabic {
            self.navigationItem.rightBarButtonItem  = UIBarButtonItem(customView: self.cancelButton)
            navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: cartButton), UIBarButtonItem(customView: messageButton), UIBarButtonItem(customView: sortButton)]

        } else {
            self.navigationItem.leftBarButtonItem  = UIBarButtonItem(customView: self.cancelButton)
            navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: messageButton), UIBarButtonItem(customView: cartButton), UIBarButtonItem(customView: sortButton)]
        }

        searchResultsPressed()
//        searchResultsController.searchText = ""
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResultsController.searchText = searchText
    }
}

//MARK: - Delegate CategoryPickerDelegate
extension SearchContainer: CategoryPickerDelegate {
    func categoryPicker(_ categoryPicker: CategoryPicker, didSelectCategory category: ItemCategory, at indexPath: IndexPath) {
        self.selectedCategory = category
        self.dismissPicker()
    }
}

extension SearchContainer : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: - DataSource UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCCell.reuseIdentifier, for: indexPath) as! CategoryCCell
        cell.lblTitle.text = appDele!.isForArabic ? allCategories[indexPath.row].name_ar : allCategories[indexPath.row].name
        cell.viewMain.setRadius(radius: 5)
        if allCategories[indexPath.row].id == selectedCategory?.id {
            cell.viewMain.backgroundColor = .gradientSecondColor
            cell.lblTitle.textColor = .white
        } else {
            cell.viewMain.backgroundColor = .white
            cell.lblTitle.textColor = UIColor.hex("#807F7F")
        }
        cell.viewMain.layer.borderColor = UIColor.gradientSecondColor.cgColor
        cell.viewMain.layer.borderWidth = 1
        return cell
    }
    
    //MARK: - Delegate UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = self.allCategories[indexPath.row]
        exploreController.cID = selectedCategory?.id ?? ""
        self.exploreController.allPosts = []
        self.exploreController.collectionView.reloadData()
        exploreController.allPosts = []
        exploreController.fetchAllPosts()
        self.collectionCategory.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let Str = appDele!.isForArabic ? allCategories[indexPath.row].name_ar : allCategories[indexPath.row].name
        let Font =  UIFont.systemFont(ofSize: 20)
        let SizeOfString = Str.SizeOf_String(font: Font).width
        return CGSize(width: (SizeOfString + 15), height: 50)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }

}

