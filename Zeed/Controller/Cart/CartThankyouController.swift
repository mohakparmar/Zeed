//
//  CartThankyouController.swift
//  Zeed
//
//  Created by Shrey Gupta on 08/04/21.
//

import UIKit

class CartThankyouController: UIViewController {
    //MARK: - Properties
    let purchaseInfo: CartPurchaseBlock
    
    //MARK: - UI Elements
    private let thankyouImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "thankyou_image").withRenderingMode(.alwaysOriginal)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let thankyouLabel: UILabel = {
        let label = UILabel()
        label.text = "Thank you for the purchase."
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .appPrimaryColor
        label.textAlignment = .center
        return label
    }()
    
    private let orderIdTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Order Id"
        label.textColor = UIColor.darkGray.withAlphaComponent(0.75)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var orderIdValueModeLabel: UILabel = {
        let label = UILabel()
        label.text = purchaseInfo.objPaymentData.InvoiceId
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    private lazy var orderIdContainer: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [orderIdTitleLabel, orderIdValueModeLabel])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let transactionTypeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Transaction Type"
        label.textColor = UIColor.darkGray.withAlphaComponent(0.75)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var transactionTypeLabel: UILabel = {
        let label = UILabel()
        label.text = purchaseInfo.paymentType
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    private lazy var transactionTypeContainer: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [transactionTypeTitleLabel, transactionTypeLabel])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let transactionIdTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray.withAlphaComponent(0.75)
        label.text = "Transaction ID"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var transactionIdLabel: UILabel = {
        let label = UILabel()
        label.text = "\(purchaseInfo.objPaymentData.InvoiceId)"
        label.textColor = .systemGreen
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    private lazy var transactionIdContainer: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [transactionIdTitleLabel, transactionIdLabel])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let paymenyStatusTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Payment status"
        label.textColor = UIColor.darkGray.withAlphaComponent(0.75)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var paymenyStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "Success"
//        label.textColor = .systemRed
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    private lazy var paymenyStatusContainer: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [paymenyStatusTitleLabel, paymenyStatusLabel])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private lazy var myOrderButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .appBrightBlueColor
        button.setTitle("My Order", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        
        button.addTarget(self, action: #selector(handleMyOrder), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var homeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .appBrightBlueColor
        button.setTitle("Home", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        
        button.addTarget(self, action: #selector(handleHome), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    init(purchaseInfo: CartPurchaseBlock, isSuccess : Bool) {
        self.purchaseInfo = purchaseInfo
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.openScreenView(str_screen_name: "Cart_Thank_You", str_nib_name: self.nibName ?? "")

        configureUI()
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
    @objc func handleMyOrder() {
        self.dismiss(animated: true) {
            let tabController = appDele?.window?.rootViewController as? TabBarController
            let mainController = tabController?.selectedViewController as? UINavigationController
            mainController?.setNavigationBarHidden(false, animated: true)
            mainController?.pushViewController(MyOrderController(), animated: true)
        }
    }
    
    @objc func handleHome() {
        guard let controller = UIApplication.shared.windows.filter({$0.isKeyWindow}).first!.rootViewController as? TabBarController else { return }
        controller.checkIfTheUserIsLoggedIn()
    }
    
    //MARK: - Helper Functions
    func configureUI() {
        view.backgroundColor = .appBackgroundColor
        
        let infoStack = UIStackView(arrangedSubviews: [orderIdContainer, transactionTypeContainer, transactionIdContainer,
                                                       paymenyStatusContainer])
        infoStack.axis = .vertical
        infoStack.alignment = .fill
        infoStack.distribution = .fillEqually
        infoStack.spacing = 12
        infoStack.setCustomSpacing(20, after: paymenyStatusContainer)
        
        infoStack.backgroundColor = .white
        infoStack.layer.cornerRadius = 8
        infoStack.clipsToBounds = true
        
        thankyouLabel.setDimensions(height: 35, width: view.frame.width - 50)
        infoStack.setDimensions(height: 200, width: view.frame.width - 30)
        
        let buttonStack = UIStackView(arrangedSubviews: [homeButton, myOrderButton])
        buttonStack.axis = .horizontal
        buttonStack.alignment = .fill
        buttonStack.spacing = 10
        buttonStack.distribution = .fillEqually
        
        buttonStack.setDimensions(height: 50, width: view.frame.width - 30)
        
        let mainStack = UIStackView(arrangedSubviews: [thankyouImage, thankyouLabel, infoStack, buttonStack])
        mainStack.axis = .vertical
        mainStack.alignment = .center
        mainStack.distribution = .fill
        mainStack.spacing = 30
        
        view.addSubview(mainStack)
        mainStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor)
    }
}
