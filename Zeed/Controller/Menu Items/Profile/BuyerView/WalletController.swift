//
//  WalletController.swift
//  Zeed
//
//  Created by Shrey Gupta on 28/04/21.
//

import UIKit

class WalletController: UIViewController {
    //MARK: - Properties
    var tableView: UITableView
    
    //MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Wallet_ar : Wallet_en
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private lazy var transferToBankButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(appDele!.isForArabic ? Transfer_to_Bank_ar : Transfer_to_Bank_en, for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        button.backgroundColor = .appPrimaryColor
        button.layer.cornerRadius = 9
        
        button.addTarget(self, action: #selector(handleTransferToBank), for: .touchUpInside)
        
        return button
    }()
    //MARK: - Lifecycle
    init() {
        self.tableView = UITableView(frame: .zero, style: .plain)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var headerView : WalletStretchyHeaderView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.titleView = titleLabel
        
        Utility.openScreenView(str_screen_name: "Wallet", str_nib_name: self.nibName ?? "")

        configureNavigationBar(largeTitleColor: .appPrimaryColor, backgoundColor: .appBackgroundColor, tintColor: .appPrimaryColor, title: title, preferredLargeTitle: false)

        navigationItem.title =  appDele!.isForArabic ? Wallet_ar : Wallet_en
        view.backgroundColor = .backgroundWhiteColor

        self.tableView.backgroundColor = .appBackgroundColor
        self.tableView.separatorColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(WalletCell.self, forCellReuseIdentifier: WalletCell.reuseIdentifier)
        
        headerView = WalletStretchyHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 170))
        headerView?.imageView.image = UIImage(named: "wallet_stretch")
        self.tableView.tableHeaderView = headerView
        
        view.addSubview(tableView)
        tableView.fillSuperview()
        
        view.addSubview(transferToBankButton)
        transferToBankButton.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 15, paddingBottom: 18, paddingRight: 15, height: 50)
        
//        self.getWalletDetails()
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().tranFormingView(toArabic: self.view)
        }


    }
    
    
    

    var balance : String = ""
    func getMyWalletBalance() {
        var dictParam : [String:Any] = [:]
        dictParam["userId"] = loggedInUser?.id
        WSManage.getDataWithGetServiceWithParams(name: WSManage.WSGetSingleUser, parameters: dictParam, isPost: true) { isError, dict in
            print(dict)
            if isError == false {
                if let str = dict?["walletBalance"] {
                    self.balance = "\(str) \(appDele!.isForArabic ? KWD_ar : KWD_en)"
                    self.headerView?.balanceAmountLabel.text = self.balance
                }
            } else {
                
            }
        }
    }

    var arrForTransaction : [WalletTransaction] = []
    func getWalletDetails() {
        var dictParam : [String:Any] = [:]
        dictParam["userId"] = loggedInUser?.id
        WSManage.getDataWithGetServiceWithParams(name: WSManage.WSForGetTransactions, parameters: dictParam, isPost: true) { isError, dict in
//            print(dict)
            self.arrForTransaction = []
            if isError == false {
                if let arr = dict?["data"] as? [[String :Any]] {
                    for item in arr {
                        self.arrForTransaction.append(WalletTransaction.initWithDictionary(dict: item))
                    }
                }
                self.tableView.reloadData()
            } else {
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.tabBarController?.tabBar.frame.origin.y = UIScreen.main.bounds.size.height
        })
        
        // Make sure the top constraint of the TableView is equal to Superview and not Safe Area
        
        // Hide the navigation bar completely
//        self.navigationController?.setNavigationBarHidden(true, animated: true)

        
//        // Make the Navigation Bar background transparent
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.tintColor = .white
//
//
//        navigationController?.navigationBar.update(backroundColor: .clear, titleColor: .white)
//
//        // Remove 'Back' text and Title from Navigation Bar
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        getMyWalletBalance()
        getWalletDetails()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: .appBackgroundColor), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = .appPrimaryColor
        
        if let tabBarFrame = self.tabBarController?.tabBar.frame {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
                self.tabBarController?.tabBar.frame.origin.y = UIScreen.main.bounds.size.height - tabBarFrame.height
            })
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLayoutSubviews() {
          super.viewDidLayoutSubviews()
          self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
    }
    
    //MARK: - Selectors
    @objc func handleTransferToBank() {
        navigationController?.pushViewController(WalletTransferController(), animated: true)
    }
}

extension WalletController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForTransaction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WalletCell.reuseIdentifier, for: indexPath) as! WalletCell

        cell.isFirstCell = false
        cell.isLastCell = false
        if indexPath.row == 0 {
            cell.isFirstCell = true

        }
        if indexPath.row == arrForTransaction.count - 1 {
            cell.isLastCell = false
        }

        cell.objTran = arrForTransaction[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
}

extension WalletController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerView = self.tableView.tableHeaderView as! WalletStretchyHeaderView
        headerView.scrollViewDidScroll(scrollView: scrollView)
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: headerView)
        }
    }
}


class WalletTransaction : NSObject {
    var UserId: String = ""
    var amount: String = ""
    var createdAt: String = ""
    var deliveryCharges: String = ""
    var id: String = ""
    var natureOfTransaction: String = ""
    var paymentType: String = ""
    var purchaseType: String = ""
    var transaction: String = ""
    var updatedAt: String = ""
    var walletAmount: String = ""
    var orderNumber: String = ""

    override init() {
        
    }
    
    class func initWithDictionary(dict : [String:Any]) -> WalletTransaction {
        let obj = WalletTransaction()
        
        obj.UserId = "\(dict["UserId"] ?? "")"
        obj.amount = "\(dict["amount"] ?? "")"
        obj.createdAt = "\(dict["createdAt"] ?? "")"
        obj.deliveryCharges = "\(dict["deliveryCharges"] ?? "")"
        obj.id = "\(dict["id"] ?? "")"
        obj.natureOfTransaction = "\(dict["natureOfTransaction"] ?? "")"
        obj.paymentType = "\(dict["paymentType"] ?? "")"
        obj.purchaseType = "\(dict["purchaseType"] ?? "")"
        obj.transaction = "\(dict["transaction"] ?? "")"
        obj.updatedAt = "\(dict["updatedAt"] ?? "")"
        obj.walletAmount = "\(dict["walletAmount"] ?? "")"
        
        if let dic = dict["Order"] as? [String:Any] {
            obj.paymentType = "\(dic["invoice_number"] ?? "")"
        }

        return obj
    }
    
    
}
