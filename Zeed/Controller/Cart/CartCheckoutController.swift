//
//  CartCheckoutController.swift
//  Zeed
//
//  Created by Shrey Gupta on 07/04/21.
//

import UIKit
import JGProgressHUD
import Network
import MFSDK

enum CartCheckoutControllerSections: Int, CaseIterable {
    case getDiscount
    case deliveryTime
    case hideMyPurchase
    case address
    case orderSummary
    case paymentMethod
    case totalAmount
    
    var description: String {
        switch self {
        case .getDiscount:
            return appDele!.isForArabic ? Get_Discount_ar : Get_Discount_en
        case .deliveryTime:
            return appDele!.isForArabic ? Preferred_Time_for_Delivery_ar : Preferred_Time_for_Delivery_en
        case .hideMyPurchase:
            return ""
        case .address:
            return appDele!.isForArabic ? Address_ar : Address_en
        case .orderSummary:
            return appDele!.isForArabic ? Order_Summary_ar : Order_Summary_en
        case .paymentMethod:
            return appDele!.isForArabic ? Payment_Method_ar : Payment_Method_en
        case .totalAmount:
            return ""
        }
    }
    
    var height: CGFloat {
        switch self {
        case .getDiscount:
            return 50
        case .deliveryTime:
            return 50
        case .hideMyPurchase:
            return 60
        case .address:
            return 130
        case .orderSummary:
            return 240
        case .paymentMethod:
            return 220
        case .totalAmount:
            return 100
        }
    }
}


class CartCheckoutController: UITableViewController {
    //MARK: - Properties
    let allCartItems: [CartItem]
    
    var hud = JGProgressHUD(style: .dark)
    
    var deliveryPicker = DeliveryTimeSlotPicker()
    var blackView = UIView()
    
    var intDirectBuyQty: Int = 1
    var deliveryCharges: Double? {
        didSet {
            self.setupCheckoutSummary()
            tableView.reloadData()
        }
    }
    
    var subTotalAmount: Double? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var couponCode: String? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var totalAmount: Double? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var appliedCoupon: Coupon? {
        didSet {
            setupCheckoutSummary()
            tableView.reloadData()
        }
    }
    
    var allTimeSlots = [TimeSlot]()
    var selectedTimeSlot: TimeSlot? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var isPurchaseHidden = true {
        didSet {
            tableView.reloadData()
        }
    }
    
    var selectedAddress: Address? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var paymentMethod: CartCheckoutPaymentMethodTypes? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var arrPaymentMethod: [PaymentMethodObject] = []
    
    var discountAmount: Double = 0 {
        didSet {
            
        }
    }
    //MARK: - UI Elements
    
    
    //MARK: - Lifecycle
    init(forCartItems cartItems: [CartItem]) {
        self.allCartItems = cartItems
        super.init(style: .plain)
        
        setupCheckoutSummary()
    }
    
    var applePayButton: MFApplePayButton?
    
    var isDirectBuy : Bool = false
    var postId : String = ""
    var variantId : String = ""
    var productDirectBuyAmount : String = ""
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar(largeTitleColor: .appPrimaryColor, backgoundColor: .appBackgroundColor, tintColor: .appPrimaryColor, title: appDele!.isForArabic ? Checkout_ar : Checkout_en, preferredLargeTitle: false)
        
        Utility.openScreenView(str_screen_name: "CheckOut", str_nib_name: self.nibName ?? "")
        
        tableView.backgroundColor = .white
        
        tableView.allowsMultipleSelection = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        deliveryPicker.delegate = self
        
        tableView.register(CartCheckoutGetDiscountCell.self, forCellReuseIdentifier: CartCheckoutGetDiscountCell.reuseIdentifier)
        tableView.register(CartCheckoutDeliveryTimeCell.self, forCellReuseIdentifier: CartCheckoutDeliveryTimeCell.reuseIdentifier)
        tableView.register(CartCheckoutHideMyPurchasesCell.self, forCellReuseIdentifier: CartCheckoutHideMyPurchasesCell.reuseIdentifier)
        tableView.register(CartCheckoutAddressCell.self, forCellReuseIdentifier: CartCheckoutAddressCell.reuseIdentifier)
        tableView.register(CartCheckoutOrderSummaryCell.self, forCellReuseIdentifier: CartCheckoutOrderSummaryCell.reuseIdentifier)
        tableView.register(CartCheckoutPaymentMethodCell.self, forCellReuseIdentifier: CartCheckoutPaymentMethodCell.reuseIdentifier)
        tableView.register(CartCheckoutTotalAmountCell.self, forCellReuseIdentifier: CartCheckoutTotalAmountCell.reuseIdentifier)
        
        configureUI()
        setupToHideKeyboardOnTapOnView()
        WSForGetPackagedetails()
        fetchTimeSlots()
        getMyWalletBalance()
        fetchAddress()
        getPaymentMethod()
        WSForGetPackagedetails()
    }
    
    
    func WSForGetPackagedetails() {
        let params: Dictionary<String, String> = [:]
        WSManage.getDataWithGetServiceWithParams(name: WSManage.WSPackageGet, parameters: params, isPost: true) { (isSuccess, dict) in
            print(dict)
            if let str = dict?["status"] as? Int {
                if str == 1 {
                    if let arr = dict?["data"] as? [[String:AnyObject]] {
                        for item in arr {
                            let obj = PackageObject(dict: item)
                            if obj.name == "deliveryCharges" {
                                self.deliveryCharges = Double(obj.amount)
                            }
                        }
                    }
                } else if str == 0 {
                }
            }
        }
    }
    
    
    //MARK: - API
    func fetchAddress() {
        Service.shared.fetchAllAddress { status, allAddress, message in
            if status {
                guard let allAddress = allAddress else { return }
                if allAddress.count > 0 {
                    self.selectedAddress = allAddress[0]
                }
            }
        }
    }
    
    
    
    //MARK: - Selectors
    @objc func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissPicker() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.blackView.alpha = 0
            self.deliveryPicker.frame.origin.y = UIScreen.main.bounds.height
        } completion: { (_) in
            self.blackView.removeFromSuperview()
            self.deliveryPicker.removeFromSuperview()
        }
    }
    
    //MARK: - API's
    func fetchTimeSlots() {
        hud.show(in: self.view, animated: true)
        Service.shared.getDeliveryTimeSlots { timeSlots, status, message in
            self.hud.dismiss(animated: true)
            if status {
                guard let timeSlots = timeSlots else { return }
                self.allTimeSlots = timeSlots
                for index in self.allTimeSlots.indices {
                    print(self.allTimeSlots[index].slot)
                    if self.allTimeSlots[index].slot == "Afternoon 4 PM to 7 PM" {
                        self.allTimeSlots[index].slot = "بعد الظهر من 4 مساءً إلى 7 مساءً"
                    } else if self.allTimeSlots[index].slot == "Evening  7 PM to 10 PM" {
                        self.allTimeSlots[index].slot = "مساءً من 7 مساءً إلى 10 مساءً"
                    }
                }
            } else {
                //                guard let message = message else { return }
                //                self.showAlert(withMsg: "Failed fetching timeslots: \(message)")
            }
        }
    }
    
    
    var balance : String? {
        didSet {
            tableView.reloadData()
        }
    }
    func getMyWalletBalance() {
        var dictParam : [String:Any] = [:]
        dictParam["userId"] = loggedInUser?.id
        WSManage.getDataWithGetServiceWithParams(name: WSManage.WSGetSingleUser, parameters: dictParam, isPost: true) { isError, dict in
            if isError == false {
                if let str = dict?["walletBalance"]  {
                    self.balance = "\(str)"
                }
            } else {
                
            }
        }
    }
    
    func getPaymentMethod() {
        Service.shared.getPaymentMethod { obj, isTrue, msg in
            if let arr = obj {
                self.arrPaymentMethod = arr
            }
        }
    }
    
    
    func fetchDeliveryCharges() {
        //        self.deliveryCharges = 2
    }
    
    //MARK: - Helper Funtions
    func setupCheckoutSummary() {
        fetchDeliveryCharges()
        self.discountAmount = 0
        var subtotalAmount: Double = 0
        for item in allCartItems {
            subtotalAmount += item.totalPrice
        }
        self.subTotalAmount = subtotalAmount
        if self.isDirectBuy == true {
            self.subTotalAmount = self.productDirectBuyAmount.doubleValue * Double(self.intDirectBuyQty)
            subtotalAmount = self.productDirectBuyAmount.doubleValue * Double(self.intDirectBuyQty)
        }
        self.totalAmount = subtotalAmount + (deliveryCharges ?? 0)
        guard let appliedCoupon = appliedCoupon else { return }
        let discountAmount = appliedCoupon.discountType == .amount ? appliedCoupon.discountValue : subtotalAmount * (appliedCoupon.discountValue/100)
        self.totalAmount = subtotalAmount + (deliveryCharges ?? 0) - discountAmount
        self.discountAmount = discountAmount
    }
    
    func configureUI() {
        tableView.backgroundColor = .appBackgroundColor
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().tranFormingView(toArabic: self.view)
        }
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
    
    func bringDeliveryPicker() {
        deliveryPicker.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2.5)
        deliveryPicker.allTimeSlots = allTimeSlots
        
        bringBlackView()
        
        UIApplication.shared.keyWindow?.addSubview(deliveryPicker)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.blackView.alpha = 1
            self.deliveryPicker.frame.origin.y = UIScreen.main.bounds.height - (UIScreen.main.bounds.height/2.5)
        }
    }
    //MARK: - DataSource & Delegate UITableViewDataSource, UITableViewDelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return CartCheckoutControllerSections.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionType = CartCheckoutControllerSections(rawValue: section)!
        
        let customView = UIView()
        customView.backgroundColor = .appBackgroundColor
        customView.alpha = 0.7
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = sectionType.description
        
        customView.addSubview(label)
        label.anchor(left: customView.leftAnchor, right: customView.rightAnchor, paddingLeft: 10, paddingRight: 10)
        
        label.centerY(inView: customView)
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: customView)
        }
        
        
        return customView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionType = CartCheckoutControllerSections(rawValue: section)!
        if sectionType == .hideMyPurchase || sectionType == .totalAmount {
            return 0
        } else {
            return 28
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionType = CartCheckoutControllerSections(rawValue: indexPath.section)!
        return sectionType.height
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = CartCheckoutControllerSections(rawValue: indexPath.section)!
        
        switch sectionType {
        case .getDiscount:
            let cell = tableView.dequeueReusableCell(withIdentifier: CartCheckoutGetDiscountCell.reuseIdentifier, for: indexPath) as! CartCheckoutGetDiscountCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.couponCode = self.couponCode
            return cell
        case .deliveryTime:
            let cell = tableView.dequeueReusableCell(withIdentifier: CartCheckoutDeliveryTimeCell.reuseIdentifier, for: indexPath) as! CartCheckoutDeliveryTimeCell
            cell.selectionStyle = .none
            cell.timeSlot = selectedTimeSlot
            return cell
        case .hideMyPurchase:
            let cell = tableView.dequeueReusableCell(withIdentifier: CartCheckoutHideMyPurchasesCell.reuseIdentifier, for: indexPath) as! CartCheckoutHideMyPurchasesCell
            cell.selectionStyle = .none
            cell.isSelected = isPurchaseHidden
            return cell
        case .address:
            let cell = tableView.dequeueReusableCell(withIdentifier: CartCheckoutAddressCell.reuseIdentifier, for: indexPath) as! CartCheckoutAddressCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.address = selectedAddress
            return cell
        case .orderSummary:
            let cell = tableView.dequeueReusableCell(withIdentifier: CartCheckoutOrderSummaryCell.reuseIdentifier, for: indexPath) as! CartCheckoutOrderSummaryCell
            cell.selectionStyle = .none
            cell.subtotalAmount = subTotalAmount
            cell.deliveryChargesAmount = deliveryCharges
            cell.appliedCoupon = appliedCoupon
            cell.totalAmount = totalAmount
            return cell
        case .paymentMethod:
            let cell = tableView.dequeueReusableCell(withIdentifier: CartCheckoutPaymentMethodCell.reuseIdentifier, for: indexPath) as! CartCheckoutPaymentMethodCell
            cell.delegate = self
            cell.balance = self.balance
            cell.selectionStyle = .none
            return cell
        case .totalAmount:
            let cell = tableView.dequeueReusableCell(withIdentifier: CartCheckoutTotalAmountCell.reuseIdentifier, for: indexPath) as! CartCheckoutTotalAmountCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.totalAmount = totalAmount
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionType = CartCheckoutControllerSections(rawValue: indexPath.section)!
        
        switch sectionType {
        case .deliveryTime:
            bringDeliveryPicker()
        case .hideMyPurchase:
            self.isPurchaseHidden.toggle()
        default:
            break
        }
    }
}

//MARK: - Delegate CartCheckoutGetDiscountCellDelegate
extension CartCheckoutController: CartCheckoutGetDiscountCellDelegate {
    func handleVerifyTapped(forCode couponCode: String) {
        guard let totalAmount = totalAmount else { return }
        
        hud.show(in: self.view, animated: true)
        Service.shared.verifyCoupon(couponCode: couponCode, onAmount: totalAmount) { status, coupon, message in
            self.hud.dismiss(animated: true)
            if status {
                guard let coupon = coupon else { return }
                self.appliedCoupon = coupon
                let alert = UIAlertController(title: "Coupon Applied!", message: "\(coupon.description)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                guard let message = message else { return }
                self.showAlert(withMsg: "Failed: \(message.firstCapitalized)")
            }
        }
        
    }
}

//MARK: - Delegate DeliveryTimeSlotPickerDelegate
extension CartCheckoutController: DeliveryTimeSlotPickerDelegate {
    func deliveryTimeSlotPicker(_ deliveryTimeSlotPicker: DeliveryTimeSlotPicker, didSelectTimeSlot timeSlot: TimeSlot, at indexPath: IndexPath) {
        self.selectedTimeSlot = timeSlot
        dismissPicker()
    }
}

extension CartCheckoutController: CartCheckoutAddressCellDelegate {
    func didTapChangeAddress() {
        let obj = MyAddressVC()
        obj.rootController = self
        self.navigationController?.pushViewController(obj, animated: true)
        
        
        //        let controller = CartCheckoutSelectAddressController()
        //        controller.rootController = self
        //        self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
}

//MARK: - Delegate CartCheckoutTotalAmountCellDelegate
extension CartCheckoutController: CartCheckoutTotalAmountCellDelegate {
    func didPressPay() {
        guard let timeSlot = selectedTimeSlot else {
            self.showAlert(withMsg: appDele!.isForArabic ? Please_select_delivery_time_slot_ar : Please_select_delivery_time_slot_en)
            return
        }
        
        guard let deliveryCharges = deliveryCharges else {
            self.showAlert(withMsg: "fetching delivery charges...")
            return }
        
        guard let addres = selectedAddress else {
            self.showAlert(withMsg: appDele!.isForArabic ? Please_select_delivery_Address_ar : Please_select_delivery_Address_en)
            return }
        
        hud.show(in: self.view, animated: true)
        if isDirectBuy == true {
            Service.shared.directBuy(postId: postId, variantId: variantId, quantity: "\(self.intDirectBuyQty)", delivery_notes: "", deliveryAddressId: addres.id, AddressId: addres.id, deliveryTimeSlot: timeSlot.id, deliveryCharge: "\(deliveryCharges)", couponCode: "", couponAmount: "", paymentType: "online", paymentMethod:paymentMethod, amount: "\(self.totalAmount ?? 0)", paymendId: "1", isHidden: isPurchaseHidden) { status, cartPurchase, message in
                
                var reqBody : [String : Any] = [:]
                reqBody["PostId"] = self.postId
                if self.variantId != "" {
                    reqBody["variantId"] = self.variantId
                }
                reqBody["quantity"] = "1"
                reqBody["delivery_notes"] = ""
                reqBody["DeliveryAddressId"] = addres.id
                reqBody["AddressId"] = addres.id
                reqBody["deliveryTimeSlot"] = timeSlot.id
                reqBody["deliveryCharge"] = "\(deliveryCharges)"
                reqBody["couponCode"] = ""
                reqBody["couponAmount"] = "\(self.discountAmount)"
                reqBody["paymentType"] = "online"
                reqBody["paymentMethodId"] = "1"
                reqBody["purchaseType"] = "normalSelling"
                if self.paymentMethod != nil {
                    if self.paymentMethod == .wallet {
                        reqBody["wallatAmount"] = "\(self.totalAmount ?? 0)"
                        reqBody["walletAmountUsed"] = true
                    }
                }
                self.hud.dismiss(animated: true)
                if status {
                    guard let cartPurchase = cartPurchase else { return }
                    reqBody["amount"] = cartPurchase.totalAmtToBePaid
                    Utility.CheckOut(transaction_id: cartPurchase.objPaymentData.InvoiceId, content_type: "Product", productPrice: "\(cartPurchase.amount)", item_id: "")
                    if cartPurchase.objPaymentData.PaymentURL == "" {
                        self.navigationController?.pushViewController(CartThankyouController(purchaseInfo: cartPurchase, isSuccess: true), animated: true)
                        Utility.Purchased(transaction_id: cartPurchase.objPaymentData.InvoiceId, content_type: "Product", productPrice: "\(cartPurchase.amount)", item_id: "")
                    } else {
                        if self.paymentMethod == .applePay {
                            self.payWithApple(price: self.totalAmount ?? 0)
                        } else {
                            let objKnet = KnetViewController()
                            objKnet.hidesBottomBarWhenPushed = true
                            objKnet.dictForCartItem = reqBody
                            objKnet.isForCart = true
                            objKnet.objCart = cartPurchase
                            self.navigationController?.pushViewController(objKnet, animated: true)
                        }
                    }
                    
                } else {
                    guard let message = message else { return }
                    self.showAlert(withMsg: "Error checkout: \(message)")
                }
            }
        } else {
            Service.shared.cartCheckout(deliveryAddress: addres.id, deliveryTimeSlot: timeSlot, deliveryCharge: deliveryCharges, isHidden: isPurchaseHidden, paymentMethod: paymentMethod, amount: "\(self.totalAmount ?? 0)", paymentId: "1", discountAmount: "\(self.discountAmount)") { status, cartPurchase, message  in
                self.hud.dismiss(animated: true)
                if status {
                    guard let cartPurchase = cartPurchase else { return }
                    Utility.CheckOut(transaction_id: cartPurchase.objPaymentData.InvoiceId, content_type: "Product", productPrice: "\(cartPurchase.amount)", item_id: "")
                    if cartPurchase.objPaymentData.PaymentURL == "" {
                        self.navigationController?.pushViewController(CartThankyouController(purchaseInfo: cartPurchase, isSuccess: true), animated: true)
                        Utility.Purchased(transaction_id: cartPurchase.objPaymentData.InvoiceId, content_type: "Product", productPrice: "\(cartPurchase.amount)", item_id: "")
                    } else {
                        if self.paymentMethod == .applePay {
                            self.payWithApple(price: self.totalAmount ?? 0)
                        } else {
                            let objKnet = KnetViewController()
                            objKnet.hidesBottomBarWhenPushed = true
                            objKnet.isForCart = true
                            objKnet.objCart = cartPurchase
                            self.navigationController?.pushViewController(objKnet, animated: true)
                        }
                    }
                    //                    self.navigationController?.pushViewController(CartThankyouController(purchaseInfo: cartPurchase), animated: true)
                } else {
                    guard let message = message else { return }
                    self.showAlert(withMsg: "Error checkout: \(message)")
                }
            }
        }
    }
    
    func payWithApple(price: Double) {
        
        guard let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 6)) as? CartCheckoutTotalAmountCell else {
            return
        }
        
        let invoiceValue = Decimal(string: "\(price)") ?? 0
        let request = MFExecutePaymentRequest(invoiceValue: invoiceValue, displayCurrencyIso: .kuwait_KWD)
        MFPaymentRequest.shared.initiateSession(apiLanguage: .english) { [weak self] response in
            switch response {
            case .success(let session):
                cell.showApplePayButton(isShow: true)
                cell.applePayButton.load(session, request, .english, startLoading: {
                    
                }, completion: { response, invoiceId in
                    switch response {
                    case .success(let executePaymentResponse):
                        self?.directApplePay(isSuccess: true)
                    case .failure(let error):
                        self?.directApplePay(isSuccess: false)
                        break
                    }
                })
            case .failure(let error):
                print("#initiate session", error.localizedDescription)
            }
        }
    }
    
    func directApplePay(isSuccess: Bool) {
        
        guard let addres = selectedAddress else {
            self.showAlert(withMsg: appDele!.isForArabic ? Please_select_delivery_Address_ar : Please_select_delivery_Address_en)
            return }
        
        guard let timeSlot = selectedTimeSlot else {
            self.showAlert(withMsg: appDele!.isForArabic ? Please_select_delivery_time_slot_ar : Please_select_delivery_time_slot_en)
            return
        }
        
        guard let deliveryCharges = deliveryCharges else {
            self.showAlert(withMsg: "fetching delivery charges...")
            return }
        
        
        var reqBody = [:] as [String: Any]
        reqBody["paymentSuccess"] = isSuccess
        reqBody["deliveryCharge"] = "\(deliveryCharges)"
        reqBody["paymentType"] = "applepay"
        reqBody["couponCode"] = ""
        reqBody["couponAmount"] = "\(self.discountAmount)"
        reqBody["paymentMethodId"] = 3
        reqBody["hidden"] = isPurchaseHidden
        reqBody["walletAmount"] = 0
        reqBody["deliveryTimeSlot"] = timeSlot.id
        reqBody["deliveryAddressId"] = addres.id
        reqBody["delivery_notes"] = ""
        reqBody["AddressId"] = addres.id
        
        let alert = UIAlertController(title: Cart_Apple_Pay, message: "\(reqBody)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) {_ in
            
        })
        self.present(alert, animated: true)

        Service.shared.directBuyForApplePay(paymentSuccess: isSuccess, deliveryCharge: "\(deliveryCharges)", couponCode: "", couponAmount: "\(self.discountAmount)", isHidden: isPurchaseHidden, amount: "\(self.totalAmount ?? 0)", deliveryTimeSlot: timeSlot.id, deliveryAddressId: addres.id, delivery_notes: "") { status, cartPurchase, message in
            self.hud.dismiss(animated: true)
            if status {
                guard let cartPurchase = cartPurchase else { return }
                self.navigationController?.pushViewController(CartThankyouController(purchaseInfo: cartPurchase, isSuccess: true), animated: true)

            } else {
                guard let cartPurchase = cartPurchase else { return }
                self.navigationController?.pushViewController(CartThankyouController(purchaseInfo: cartPurchase, isSuccess: false), animated: true)
            }
        }
    }
}




//curl --location 'localhost:8042/cart/buy' \
//--header 'Content-Type: application/json' \
//--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.ODc2NjQzOGYtMDEyNy00OTJlLTkxMjAtZTMxOGI4YzYzOTkw.-y1YwIA9O9c5o5vMoqy-lTzmqqP8dSZgy-sX4ZKlnIY' \
//--data '{
//    "paymentSuccess": true, // true or false
//    "deliveryCharge": 2,
//    "paymentType": "applepay",
//    "couponCode": "",  // if any coupon code is used
//    "couponAmount": 0,  // if any coupon code is used
//    "paymentMethodId": 3,
//    "hidden": 0,
//    "walletAmount": 0,
//    "deliveryTimeSlot": "385cd0f4-4bb0-4537-8bc2-dae781de4ad4",
//    "deliveryAddressId": "e94887b6-8e8d-4d65-bda3-3bf9e58bc260",
//    "delivery_notes": "some"
//}'



class PackageObject: NSObject {
    
    @objc dynamic var id: String! = ""
    @objc dynamic var createdAt: String! = ""
    @objc dynamic var name: String! = ""
    @objc dynamic var amount: String! = ""
    @objc dynamic var type: String! = ""
    @objc dynamic var currency: String! = ""
    @objc dynamic var updatedAt: String! = ""
    
    override init() {
        
    }
    
    init(dict:[String : AnyObject]) {
        // print(dict)
        id = Utility.getValue(dict: dict, key: "id")
        name = Utility.getValue(dict: dict, key: "name")
        amount = Utility.getValue(dict: dict, key: "amount")
        type = Utility.getValue(dict: dict, key: "type")
        currency = Utility.getValue(dict: dict, key: "currency")
        createdAt = Utility.getValue(dict: dict, key: "createdAt")
        updatedAt = Utility.getValue(dict: dict, key: "updatedAt")
        
    }
    
}

//MARK: - Delegate CartCheckoutTotalAmountCellDelegate
extension CartCheckoutController: CartCheckoutPaymentMethodTypesDelegate {
    func getPaymentMethod(paymentMethod method: CartCheckoutPaymentMethodTypes) {
        paymentMethod = method
        guard let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 6)) as? CartCheckoutTotalAmountCell else {
            return
        }
        cell.showApplePayButton(isShow: false)

    }
}
