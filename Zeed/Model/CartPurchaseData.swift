//
//  CartPurchaseData.swift
//  Zeed
//
//  Created by Shrey Gupta on 10/09/21.
//

import Foundation

struct CartPurchase {
    let data: CartPurchaseData
    let url: String
    let amountToBePaid: Double
    
    init(dict: [String: Any]) {
        let purchaseDataDict = dict["data"] as? [String: Any] ?? [String: Any]()
        self.data = CartPurchaseData(dict: purchaseDataDict)
        
        self.url = dict["url"] as? String ?? ""
        self.amountToBePaid = dict["totalAmtToBePaid"] as? Double ?? 0
    }
}

struct CartPurchaseData {
    let id: String
    let transaction: Int
    let status: String
    let paymentType: String
    let purchaseType: PostPurchaseType
    let userId: String
    let walletAmount: Double
    let amount: Double
    let deliveryCharges: Double
    let isHidden: Bool
    let creationDate: Date
    
    init(dict: [String: Any]) {
        self.id = dict["id"] as? String ?? ""
        self.transaction = dict["transaction"] as? Int ?? 0
        self.status = dict["status"] as? String ?? ""
        self.paymentType = dict["paymentType"] as? String ?? ""
        
        let purchaseTypeString = dict["purchaseType"] as? String ?? ""
        self.purchaseType = PostPurchaseType(rawValue: purchaseTypeString)!
        
        self.amount = dict["amount"] as? Double ?? 0
        self.deliveryCharges = dict["deliveryCharges"] as? Double ?? 0
        self.userId = dict["UserId"] as? String ?? ""
        self.walletAmount = dict["walletAmount"] as? Double ?? 0
        self.isHidden = dict["hidden"] as? Bool ?? false
        
        let creationDateString = dict["createdAt"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: creationDateString)
    }
}


struct CartPurchaseBlock {
    let amount: String
    let deliveryCharges: String
    let paymentMethodId: String
    let paymentType: String
    let purchaseType: String
    let status: String
    let totalAmtToBePaid: String
    let walletAmount: String
    let walletAmountUsed: String

    let objPaymentData: paymentDataObject

    init(dict: [String: Any]) {
        self.amount = "\(dict["amount"]  ?? "")"
        self.deliveryCharges = "\(dict["deliveryCharges"]  ?? "")"
        self.paymentMethodId = "\(dict["paymentMethodId"]  ?? "")"
        self.paymentType = "\(dict["paymentType"]  ?? "")"
        self.purchaseType = "\(dict["purchaseType"]  ?? "")"
        self.status = "\(dict["status"]  ?? "")"
        self.totalAmtToBePaid = "\(dict["totalAmtToBePaid"]  ?? "")"
        self.walletAmount = "\(dict["walletAmount"]  ?? "")"
        self.walletAmountUsed = "\(dict["walletAmountUsed"]  ?? "")"

        self.objPaymentData = paymentDataObject(dict: dict["paymentData"] as? [String:Any] ?? [:])
    }
}


struct paymentDataObject {
    let CustomerReference: String
    let InvoiceId: String
    let IsDirectPayment: String
    let PaymentURL: String
    let RecurringId: String
    let UserDefinedField: String

    init(dict: [String: Any]) {
        self.CustomerReference = "\(dict["CustomerReference"]  ?? "")"
        self.InvoiceId = "\(dict["InvoiceId"]  ?? "")"
        self.IsDirectPayment = "\(dict["IsDirectPayment"]  ?? "")"
        self.PaymentURL = "\(dict["PaymentURL"]  ?? "")"
        self.RecurringId = "\(dict["RecurringId"]  ?? "")"
        self.UserDefinedField = "\(dict["UserDefinedField"]  ?? "")"

    }
}

