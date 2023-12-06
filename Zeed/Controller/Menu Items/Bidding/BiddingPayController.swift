//
//  BiddingPayController.swift
//  Zeed
//
//  Created by Shrey Gupta on 02/04/21.
//

import UIKit
import JGProgressHUD



enum BiddingPaySections: Int, CaseIterable {
    case description
    case totalAmount
    case paymentMethod
    
    var height: CGFloat {
        switch self {
        case .description:
            return CGFloat(100)
        case .totalAmount:
            return CGFloat(50 + 15 + 15)
        case .paymentMethod:
            return CGFloat(150 + 15 + 15)
        }
    }
}

class BiddingPayController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //MARK: - Properties
    let biddingItem: BidItem
    let tableView: UITableView
    
    var footerView = BiddingPayFooterView()
    
    var hud = JGProgressHUD(style: .dark)
    
    var isForBiddingPay : Bool = false
    var amountForRegi : Double = 259
    
    var balance : String? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var paymentMethod: BiddingPayPaymentTypes?

    
    //MARK: - Lifecycle
    init(forBidItem item: BidItem) {
        self.biddingItem = item
        
        self.tableView = UITableView(frame: .zero, style: .plain)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        footerView.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        Utility.openScreenView(str_screen_name: "Bidding_Pay", str_nib_name: self.nibName ?? "")

        tableView.register(BiddingPayDescriptionCell.self, forCellReuseIdentifier: BiddingPayDescriptionCell.reuseIdentifier)
        tableView.register(BiddingPayTotalAmountCell.self, forCellReuseIdentifier: BiddingPayTotalAmountCell.reuseIdentifier)
        tableView.register(BiddingPayPaymentCell.self, forCellReuseIdentifier: BiddingPayPaymentCell.reuseIdentifier)
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        configureUI()
        
        if isForBiddingPay == true {
            let totalAmount = (biddingItem.currentBid?.price ?? 0) - biddingItem.registrationAmount
            if totalAmount < 0 {
                footerView.totalAmountLabel.text = "\(0) KWD"
            } else {
                footerView.totalAmountLabel.text = "\(totalAmount) KWD"
            }
            self.title = biddingItem.title
        }
        self.getMyWalletBalance()
        self.WSForGetPackagedetails()
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
    func configureUI() {
        view.backgroundColor = .appBackgroundColor
        tableView.backgroundColor = .appBackgroundColor
        

        view.addSubview(footerView)
        footerView.anchor(bottom: view.bottomAnchor, paddingBottom: 24, width: view.frame.width - 30, height: 85)
        footerView.centerX(inView: view)
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: footerView.topAnchor, right: view.rightAnchor, paddingBottom: 15)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BiddingPaySections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = BiddingPaySections(rawValue: indexPath.row)!
        
        if section == .description {
            return UITableView.automaticDimension
        }
        
        return section.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = BiddingPaySections(rawValue: indexPath.row)!
        
        switch section {
        case .description:
            let cell = tableView.dequeueReusableCell(withIdentifier: BiddingPayDescriptionCell.reuseIdentifier, for: indexPath) as! BiddingPayDescriptionCell
            return cell
        case .totalAmount:
            let cell = tableView.dequeueReusableCell(withIdentifier: BiddingPayTotalAmountCell.reuseIdentifier, for: indexPath) as! BiddingPayTotalAmountCell
            
            if isForBiddingPay == true {
                let totalAmount = (biddingItem.currentBid?.price ?? 0) - biddingItem.registrationAmount
                if totalAmount < 0 {
                    cell.totalAmountLabel.text = "\(0) KWD"
                } else {
                    cell.totalAmountLabel.text = "\(totalAmount) KWD"
                }
            } else {
                cell.totalAmountLabel.text = "\(self.amountForRegi) KWD"
            }
            return cell
        case .paymentMethod:
            let cell = tableView.dequeueReusableCell(withIdentifier: BiddingPayPaymentCell.reuseIdentifier, for: indexPath) as! BiddingPayPaymentCell
            cell.balance = self.balance ?? "0"
            cell.delegate = self
            return cell
        }
    }
    
    static let WSForPackageDetails: String = "package/get"
    func WSForGetPackagedetails() {
        let params: Dictionary<String, String> = [:]
        WSManage.getDataWithGetServiceWithParams(name: BiddingPayController.WSForPackageDetails, parameters: params, isPost: true) { (isSuccess, dict) in
            print(dict)
            if let str = dict?["status"] as? Int {
                if str == 1 {
                    if let arr = dict?["data"] as? [[String:AnyObject]] {
                        for item in arr {
                            let obj = PackageObject(dict: item)
                            if obj.name == "biddingPostRegistrationPrice" {
                                if obj.type == "percent" {
                                    self.amountForRegi = (Double(obj.amount) ?? 259) * self.biddingItem.initialPrice / 100
                                } else {
                                    self.amountForRegi = Double(obj.amount) ?? 259
                                }
                            }
                            self.footerView.totalAmountLabel.text = String(format: "%.3f %@", self.amountForRegi, appDele!.isForArabic ? KWD_ar : KWD_en)
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func getMyWalletBalance() {
        var dictParam : [String:Any] = [:]
        dictParam["userId"] = loggedInUser?.id
        WSManage.getDataWithGetServiceWithParams(name: WSManage.WSGetSingleUser, parameters: dictParam, isPost: true) { isError, dict in
            if isError == false {
                if let str = dict?["walletBalance"] {
                    self.balance = "\(str)"
                }
            }
        }
    }
}

extension BiddingPayController: BiddingPayFooterViewDelegate {
    func didTapPay() {
        hud.show(in: self.view, animated: true)
        var type : PostPurchaseType = .postRegistrationPrice
        var amount : Double = self.amountForRegi
        var reqBody1 : [String:Any] = [:]
        var pType : String = ""
        if isForBiddingPay == true {
            type = .normalBidding
            pType = self.biddingItem.postBaseType.rawValue
            amount = biddingItem.currentBid?.price ?? 0
            reqBody1["hidden"] = ""
            reqBody1["walletAmountUsed"] = false
            reqBody1["currentWalletAmount"] = 0
            reqBody1["purchaseType"] = biddingItem.postBaseType.rawValue
            reqBody1["amount"] = (biddingItem.currentBid?.price ?? 0)
            reqBody1["paymentMethodId"] = 1
            reqBody1["PostId"] = biddingItem.id
            reqBody1["deliveryCharges"] = 0
//            reqBody1["DeliveryAddressId"] = ""
            reqBody1["paymentType"] = "knet"
            reqBody1["walletAmount"] = 0
        } else {
            pType = "biddingPostRegistrationPrice"
            reqBody1["hidden"] = ""
            reqBody1["walletAmountUsed"] = false
            reqBody1["currentWalletAmount"] = 0
            reqBody1["purchaseType"] = "biddingPostRegistrationPrice"
            reqBody1["amount"] = amount
            reqBody1["paymentMethodId"] = 1
            reqBody1["PostId"] = biddingItem.id
            reqBody1["deliveryCharges"] = 0
//            reqBody1["DeliveryAddressId"] = ""
            reqBody1["paymentType"] = "knet"
            reqBody1["walletAmount"] = 0
        }
        
        Service.shared.addPurchase(type: type, forPostId: biddingItem.id, amount: amount, walletAmount: 0, deliveryCharges: 0, paymentType: self.paymentMethod ?? .knet, purchaseType: pType) { status, purchaseData, message in
            self.hud.dismiss(animated: true)
            if status {
                guard let details = purchaseData else { return }
                if details.objPayment?.PaymentURL == "" {
                    let obj = BiddingThankyouController(forPurchase: details, isSuccess: true)
                    obj.isForBiddingPay = self.isForBiddingPay
                    self.navigationController?.pushViewController(obj, animated: true)
                } else {
                    let obj = KnetViewController()
                    obj.hidesBottomBarWhenPushed = true
                    obj.dictForBidding = reqBody1
                    obj.isForCart = false
                    obj.objItem = details
                    obj.isForBiddingPay = self.isForBiddingPay
                    self.navigationController?.pushViewController(obj, animated: true)
                }

//                self.navigationController?.pushViewController(BiddingThankyouController(forPurchase: details), animated: true)
            } else {
                guard let message = message else { return }
                self.showAlert(withMsg: "Failed: \(message)")
            }
        }
    }
}


extension URL {
    func valueOf(_ queryParameterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParameterName })?.value
    }
}

extension BiddingPayController : BiddingPaySectionsTypesDelegate {
    func getPaymentMethod(paymentMethod method: BiddingPayPaymentTypes) {
        self.paymentMethod = method
    }
}
