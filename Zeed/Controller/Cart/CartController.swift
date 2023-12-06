//
//  CartController.swift
//  Zeed
//
//  Created by Shrey Gupta on 20/03/21.
//

import UIKit
import JGProgressHUD
import SwipeCellKit
import Network

class CartController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    //MARK: - Properties
    var hud = JGProgressHUD(style: .dark)
    
    var cartItems = [CartItem]() {
        didSet {
            collectionView.reloadData()
            if cartItems.count > 0 {
                addItemsLabel.alpha = 0
                checkoutButton.isHidden = false
            } else {
                addItemsLabel.alpha = 1
                checkoutButton.isHidden = true
            }
        }
    }
    
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
    
    private lazy var checkoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(appDele!.isForArabic ? Checkout_ar : Checkout_en, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .appBrightBlueColor
        
        button.layer.cornerRadius = 9
        
        button.addTarget(self, action: #selector(handleCheckOut), for: .touchUpInside)
        
        return button
    }()
    
    private let addItemsLabel: UILabel = {
        let label = UILabel()
        label.text = "Cart is empty \nPlease add items to your cart"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .light)
        label.textColor = .appPrimaryColor
        return label
    }()
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utility.openScreenView(str_screen_name: "Cart", str_nib_name: self.nibName ?? "")

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        
        configureNavigationBar(largeTitleColor: .appPrimaryColor, backgoundColor: .appBackgroundColor, tintColor: .appPrimaryColor, title: appDele!.isForArabic ? Cart_ar : Cart_en, preferredLargeTitle: true)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        
        collectionView.delegate = self
        collectionView.register(CartCell.self, forCellWithReuseIdentifier: CartCell.reuseIdentifier)
        
        configureUI()
    }
    
    //MARK: - Selectors
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleCheckOut() {
        hud.show(in: self.view, animated: true)
        Service.shared.getCartItems { items, status, message in
            self.hud.dismiss(animated: true)
            if status {
                guard let items = items else { return }
                appDele?.arrForCart = items
                let arr = items.filter({ $0.outOfStock == true })
                if arr.count > 0 {
                    self.showAlert(withMsg: "Some of your cart items are out of stock.")
                } else {
                    let controller = CartCheckoutController(forCartItems: items)
                    self.navigationController?.pushViewController(controller, animated: true)
                }
                
            } else {
                guard let error = message else { return }
//                self.showAlert(withMsg: "Error while checking out: \(error)")
            }
        }
    }
    
    var subTotalAmount: Double? {
        didSet {
            checkoutButton.setTitle("\(appDele!.isForArabic ? Checkout_ar : Checkout_en) (\(subTotalAmount ?? 0) \(appDele!.isForArabic ? KWD_ar : KWD_en))", for: .normal)
        }
    }
    
    var totalAmount: Double? {
        didSet {
            checkoutButton.setTitle("\(appDele!.isForArabic ? Checkout_ar : Checkout_en) (\(totalAmount ?? 0) \(appDele!.isForArabic ? KWD_ar : KWD_en))", for: .normal)
        }
    }

    
    //MARK: - Helper Funtions
    func setupCheckoutSummary() {
        var subtotalAmount: Double = 0
        for item in cartItems {
            subtotalAmount += item.totalPrice
        }
        self.subTotalAmount = subtotalAmount
        self.totalAmount = subtotalAmount
    }
    
    //MARK: - API
    func fetchCartItems() {
        hud.show(in: self.view, animated: true)
        Service.shared.getCartItems { (cartItems, status, message) in
            self.hud.dismiss(animated: true)
            if status {
                guard let cartItems = cartItems else { return }
                appDele?.arrForCart = cartItems
                self.cartItems = cartItems
                self.collectionView.reloadData()
                self.setupCheckoutSummary()
            } else {
                self.cartItems = []
                self.collectionView.reloadData()
//                guard let message = message else { return }
//                self.showAlert(withMsg: message)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchCartItems()
    }
    
    //MARK: - Helper Functions
    func configureUI() {
        collectionView.backgroundColor = .appBackgroundColor
        view.backgroundColor = .appBackgroundColor
        
        view.addSubview(checkoutButton)
        checkoutButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 8, width: view.frame.width - 16, height: 50)
        checkoutButton.centerX(inView: view)
        
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: checkoutButton.topAnchor, right: view.rightAnchor, paddingLeft: 10, paddingBottom: 8, paddingRight: 10)
        
        collectionView.addSubview(addItemsLabel)
        addItemsLabel.centerX(inView: collectionView)
        addItemsLabel.centerY(inView: collectionView)
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().tranFormingView(toArabic: self.view)
            addItemsLabel.transform = trnForm_Ar;
        }

    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CartCell.reuseIdentifier, for: indexPath) as! CartCell
        cell.delegate = self
        cell.indexPath = indexPath
        cell.item = cartItems[indexPath.row]
        cell.cartCelldelegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 30, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}

extension CartController: SwipeCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: nil) { action, indexPath in
            action.fulfill(with: .reset)
            self.removeItem(at: self.cartItems[indexPath.item])
//            self.cartItems.remove(at: indexPath.item)
//            self.collectionView.deleteItems(at: [indexPath])
            self.collectionView.reloadData()
//            action.fulfill(with: .delete)
        }

        let iv = UIImageView(image: #imageLiteral(resourceName: "trash").withRenderingMode(.alwaysTemplate))
        iv.tintColor = .white
        
        // customize the action appearance
        deleteAction.image = iv.image
        
        return [deleteAction]
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
}

extension CartController: CartCellDelegate {
    func removeItem(at indexPath: IndexPath) {
        
    }
    
    func didUpdateQuantity(quantity: Int, atIndexPath indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CartCell else { return }
        guard let item = cell.item else { return }
        
        if let variant = item.selectedVariant {

        } else {

        }

        
        
        hud.show(in: self.view, animated: true)
        
        var post = PostItem(dict: [:])
        post.id = item.id
        post.price =  item.price
        post.quantity = quantity
        Service.shared.addToCart(post: post, variant: item.selectedVariant, quantity: quantity, cartId: item.cartId) { status, str in
            self.hud.dismiss(animated: true)
            self.fetchCartItems()
            Utility.addToCartProduct(productId: post.id, productName: post.title, productPrice: post.price, productVariantId: "", productVariantName: "")
            if status {
            } else {
                Utility.showISMessage(str_title: "Failed!", Message: "You have added max quantity of this product.", msgtype: .error)
            }

        }
        
//        Service.shared.addToCart(post: cartItems[indexPath.row].id, quantity: <#T##Int#>, completion: <#T##(Bool, String?) -> Void#>)
    }
    
    func removeItem(at indexPath: CartItem) {
//        guard let cell = collectionView.cellForItem(at: indexPath) as? CartCell else { return }
//        guard let item = cell.item else { return }
        
        hud.show(in: view, animated: true)
        Service.shared.deleteCartItem(cartItem: indexPath) { (status) in
            if status {
                Utility.showISMessage(str_title: "Item Removed!", Message: "Item has been removed from your cart successfully!", msgtype: .success)
            } else {
                Utility.showISMessage(str_title: "Failed!", Message: "Failed to remove item from your cart! Please try again later.", msgtype: .error)
            }
            self.hud.dismiss(animated: true)
            self.fetchCartItems()
        }
    }
}
