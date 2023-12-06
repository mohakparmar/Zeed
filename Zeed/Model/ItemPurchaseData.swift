//
//  ItemPurchaseData.swift
//  Zeed
//
//  Created by Shrey Gupta on 29/08/21.
//

import Foundation

//struct ItemPurchaseData {
//    let id: String
//    let transaction: Int
//    let status: String
//    let paymentType: BiddingPayPaymentTypes?
//    let invoice: String
//    let amount: Double
//    let deliveryCharges: Double
//    let postId: String
//    let userId: String
//    let walletAmount: Double
//    let isHidden: Bool
//    let creationDate: Date
////    let purchaseType: PostPurchaseType
//
//    init(dict: [String: Any]) {
//        print("DEBUG:- DICT: \(dict)")
//        self.id = dict["id"] as? String ?? ""
//        self.transaction = dict["transaction"] as? Int ?? 0
//        self.status = dict["status"] as? String ?? ""
//
//        let paymentTypeString = dict["paymentType"] as? String ?? ""
//        self.paymentType = BiddingPayPaymentTypes(rawValue: paymentTypeString)
//
//        self.invoice = dict["invoice"] as? String ?? ""
//        self.amount = dict["amount"] as? Double ?? 0
//        self.deliveryCharges = dict["deliveryCharges"] as? Double ?? 0
//        self.postId = dict["PostId"] as? String ?? ""
//        self.userId = dict["UserId"] as? String ?? ""
//        self.walletAmount = dict["walletAmount"] as? Double ?? 0
//        self.isHidden = dict["hidden"] as? Bool ?? false
//
//        let creationDateString = dict["createdAt"] as? Double ?? 0
//        self.creationDate = Date(timeIntervalSince1970: creationDateString)
//
//    }
//}




struct ItemPurchaseData {
    let purchaseType: String?
    let amount: String?
    let PostId: String?
    let walletAmount: String?
    let paymentType: String?
    let totalAmtToBePaid: String?
    let deliveryCharges: String?
    let walletAmountUsed: String?
    let paymentMethodId: String?
    let objPayment: PaymentMehodUsed?

    init(dict: [String: Any]) {
        print("DEBUG:- DICT: \(dict)")
        self.purchaseType = "\(dict["purchaseType"] ?? "")"
        self.amount = "\(dict["amount"] ?? "")"
        self.PostId = "\(dict["PostId"] ?? "")"
        self.walletAmount = "\(dict["walletAmount"] ?? "")"
        self.paymentType = "\(dict["paymentType"] ?? "")"
        self.totalAmtToBePaid = "\(dict["totalAmtToBePaid"] ?? "")"
        self.deliveryCharges = "\(dict["deliveryCharges"] ?? "")"
        self.walletAmountUsed = "\(dict["walletAmountUsed"] ?? "")"
        self.paymentMethodId = "\(dict["paymentMethodId"] ?? "")"
        self.objPayment = PaymentMehodUsed(dict: dict["paymentData"] as? [String:Any] ?? [:])
    }
}




struct PaymentMehodUsed {
    let CustomerReference: String?
    let InvoiceId: String?
    let IsDirectPayment: String?
    let PaymentURL: String?
    let RecurringId: String?

    init(dict: [String: Any]) {
        print("DEBUG:- DICT: \(dict)")
        self.CustomerReference = "\(dict["CustomerReference"] ?? "")"
        self.InvoiceId = "\(dict["InvoiceId"] ?? "")"
        self.IsDirectPayment = "\(dict["IsDirectPayment"] ?? "")"
        self.PaymentURL = "\(dict["PaymentURL"] ?? "")"
        self.RecurringId = "\(dict["RecurringId"] ?? "")"

    }
}


