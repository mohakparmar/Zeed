//
//  Coupon.swift
//  Zeed
//
//  Created by Shrey Gupta on 09/09/21.
//

import Foundation

enum CouponDiscountType: String {
    case amount = "amount"
    case percent = "percent"
}

struct Coupon {
    let id: String
    let name: String
    let couponCode: String
    let description: String
    let discountType: CouponDiscountType
    let discountValue: Double
    let validFrom: Date
    let validTo: Date
    let minPurchaseAmount: Double
    let maxUser: Int
    let perUserLimit: Int
    let usedCount: Int
    let display: Bool
    let status: Bool
    let creationDate: Date
    
    init(dict: [String: Any]) {
        self.id = dict["id"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
        self.couponCode = dict["couponCode"] as? String ?? ""
        self.description = dict["description"] as? String ?? ""
        
        let discountTypeString = dict["discountType"] as? String ?? ""
        self.discountType = CouponDiscountType(rawValue: discountTypeString)!
        
        self.discountValue = dict["discountValue"] as? Double ?? 0
        self.minPurchaseAmount = dict["minPurchaseAmount"] as? Double ?? 0
        self.maxUser = dict["maxUser"] as? Int ?? 0
        self.perUserLimit = dict["perUserLimit"] as? Int ?? 0
        self.usedCount = dict["usedCount"] as? Int ?? 0
        self.display = dict["display"] as? Bool ?? false
        self.status = dict["status"] as? Bool ?? false
        
        let validFromInt = dict["validFrom"] as? Int ?? 0
        self.validFrom = Date(timeIntervalSince1970: TimeInterval(validFromInt/1000))
        
        let validToInt = dict["validTo"] as? Int ?? 0
        self.validTo = Date(timeIntervalSince1970: TimeInterval(validToInt/1000))
        
        let creationDateInt = dict["creationDate"] as? Int ?? 0
        self.creationDate = Date(timeIntervalSince1970: TimeInterval(creationDateInt))
    }
}
