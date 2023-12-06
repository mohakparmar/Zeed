//
//  OrderItem.swift
//  Zeed
//
//  Created by Shrey Gupta on 16/09/21.
//

import Foundation

struct OrderItem {
    let id: String
    let deliveryNotes: String
    let deliveryCartId: String
    let deliveryTimeSlot: String
    let orderFailedMessage: String
    let deliveryCharges: Double
    let subTotal: Double
    let discountAmount: Double
    let grandTotal: Double
    let couponCode: String
    let couponAmount: Double
    let invoiceNumber: String
    let sellerInvoiceId: String
    let orderStatus: String
    let paymentType: String
    let paymentStatus: String
    let reasonOfCancellation: String
    let reasonOfDelayed: String
    let transaction: String
    let refundDetails: String
    let refundStatus: String
    let totalItems: Int
    let createdAt: Date
    let UserId: String
    let purchaseId: String
    let addressDetails: Address
    let items: [CartItem]
    
    init(dict: [String: Any]) {
        self.id = dict["id"] as? String ?? "id not fetched"
        self.deliveryNotes = dict["delivery_notes"] as? String ?? "deliveryNotes not fetched"
        self.deliveryCartId = dict["deliveryCartId"] as? String ?? "deliveryCartId not fetched"
        self.deliveryTimeSlot = dict["deliveryTimeSlot"] as? String ?? "deliveryTimeSlot not fetched"
        self.orderFailedMessage = dict["orderFailedMessage"] as? String ?? "orderFailedMessage not fetched"
        self.deliveryCharges = dict["deliveryCharge"] as? Double ?? 0
        self.subTotal = dict["subTotal"] as? Double ?? 0
        self.discountAmount = dict["discountAmount"] as? Double ?? 0
        self.grandTotal = dict["grandTotal"] as? Double ?? 0
        self.couponCode = dict["couponCode"] as? String ?? "couponCode not fetched"
        self.couponAmount = dict["couponAmount"] as? Double ?? 0
        self.invoiceNumber = dict["invoice_number"] as? String ?? "invoiceNumber not fetched"
        self.sellerInvoiceId = dict["seller_invoiceId"] as? String ?? "sellerInvoiceId not fetched"
        self.orderStatus = dict["orderStatus"] as? String ?? "orderStatus not fetched"
        self.paymentType = dict["paymentType"] as? String ?? "paymentType not fetched"
        self.paymentStatus = dict["paymentStatus"] as? String ?? "paymentStatus not fetched"
        self.reasonOfCancellation = dict["reasonOfCancellation"] as? String ?? "reasonOfCancellation not fetched"
        self.reasonOfDelayed = dict["reasonOfDelayed"] as? String ?? "reasonOfDelayed not fetched"
        self.transaction = dict["transaction"] as? String ?? "transaction not fetched"
        self.refundDetails = dict["refundDetails"] as? String ?? "refundDetails not fetched"
        self.refundStatus = dict["refundStatus"] as? String ?? "refundStatus not fetched"
        self.totalItems = dict["totalItems"] as? Int ?? 0
        
        let createdAtInt = dict["createdAt"] as? Int ?? 0
        self.createdAt = Date(timeIntervalSince1970: TimeInterval(createdAtInt/1000))
        
        self.UserId = dict["UserId"] as? String ?? "UserId not fetched"
        self.purchaseId = dict["PurchaseId"] as? String ?? "purchaseId not fetched"
        let addressDetailsDict = dict["addressDetails"] as? [String: Any] ?? [String: Any]()
        self.addressDetails = Address(dict: addressDetailsDict)
        
        
        var allItems = [CartItem]()
        let itemsDict = dict["items"] as? [[String: Any]] ?? [[String: Any]]()
        itemsDict.forEach { itemDict in
            allItems.append(CartItem(dict: itemDict))
        }
        self.items = allItems
    }
}
