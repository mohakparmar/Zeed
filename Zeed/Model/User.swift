//
//  User.swift
//  Zeed
//
//  Created by Shrey Gupta on 12/04/21.
//

import UIKit

struct User: Codable {
    var id: String
    let auth: String
    let email: String
    let password: String
    let fullName: String
    let about: String
    var isSeller: Bool
    var isVerified: Bool
    var isPublic: Bool
    var isPurchaseHidden: Bool
    let mobileNumber: String
    var userName: String
    var followStatus: Bool
    var requestStatus: Bool
    var image: UserImage
    var walletBalance: Float
    
    let deviceId: String
    let deviceToken: String
    let deviceName: String
    let deviceType: String
    let voIPToken: String
    
    let registrationType: String
    
    let storeDetails: RegisterSellerInfo
    let liveDetails: LiveSellerItem
    let followers: Int
    let following: Int
    let numberOfProducts: Int
    let numberOfAuctions: Int
    
    let cityId: String
    var urlImage: String

    
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.auth = dictionary["auth"] as? String ?? ""
        self.userName = dictionary["userName"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.password = dictionary["password"] as? String ?? ""
        self.fullName = dictionary["firstName"] as? String ?? ""
        self.mobileNumber = dictionary["mobileNumber"] as? String ?? ""

        let imageDict = dictionary["image"] as? [String: Any] ?? [String: Any]()
        self.image = UserImage(dictionary: imageDict)
        
        self.about = dictionary["about"] as? String ?? ""
        self.isSeller = dictionary["isSeller"] as? Bool ?? false
        self.isPublic = dictionary["public"] as? Bool ?? true
        self.isVerified = dictionary["isVerified"] as? Bool ?? false
        self.followStatus = dictionary["followStatus"] as? Bool ?? false
        self.requestStatus = dictionary["requestStatus"] as? Bool ?? false
        self.isPurchaseHidden = dictionary["isPurchaseHidden"] as? Bool ?? false
        
        self.registrationType = dictionary["registrationType"] as? String ?? ""
        
        let storeDetailsDict = dictionary["storeDetails"] as? [String: Any] ?? [String: Any]()
        self.storeDetails = RegisterSellerInfo(dict: storeDetailsDict)
        
        let liveInfoDict = dictionary["Live"] as? [String: Any] ?? [String: Any]()
        self.liveDetails = LiveSellerItem(dict: liveInfoDict)
        
        self.followers = dictionary["followers"] as? Int ?? 0
        self.following = dictionary["following"] as? Int ?? 0
        self.numberOfProducts  = dictionary["numberOfProducts"] as? Int ?? 0
        self.numberOfAuctions  = dictionary["numberOfAuctions"] as? Int ?? 0
        
        self.walletBalance = dictionary["walletBalance"] as? Float ?? 0
        
        self.deviceId = dictionary["deviceId"] as? String ?? ""
        self.deviceToken = dictionary["deviceToken"] as? String ?? ""
        self.deviceName = dictionary["deviceName"] as? String ?? ""
        self.deviceType = dictionary["deviceType"] as? String ?? ""
        self.voIPToken = dictionary["voIPToken"] as? String ?? ""
        
        self.cityId = dictionary["cityId"] as? String ?? ""

        self.urlImage = ""
    }
    
}

struct UserImage: Codable {
    let id: String
    let url: String
    
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.url = dictionary["url"] as? String ?? ""
    }
}

struct LiveSellerItem: Codable {
    let userId: String
    let postId: String
    let recording: String
    var isLive: Bool
    var isPurchased: Bool
    
    init(dict: [String: Any]) {
        self.userId = dict["UserId"] as? String ?? ""
        self.postId = dict["PostId"] as? String ?? ""
        self.recording = dict["recording"] as? String ?? ""
        self.isLive = dict["isLive"] as? Bool ?? false
        self.isPurchased = dict["isPurchased"] as? Bool ?? true
    }
}



struct PaymentMethodObject: Codable {
    let CurrencyIso: String
    let ImageUrl: String
    let IsDirectPayment: String
    var PaymentMethodAr: String
    var PaymentMethodEn: String

    var ServiceCharge: String
    var TotalAmount: String
    var createdAt: String
    var id: String

    
    init(dict: [String: Any]) {
        self.CurrencyIso = dict["CurrencyIso"] as? String ?? ""
        self.ImageUrl = dict["ImageUrl"] as? String ?? ""
        self.IsDirectPayment = dict["IsDirectPayment"] as? String ?? ""
        self.PaymentMethodAr = "\(dict["PaymentMethodAr"] ?? "")"
        self.PaymentMethodEn = "\(dict["PaymentMethodEn"] ?? "")"
        self.ServiceCharge = "\(dict["ServiceCharge"] ?? "")"
        self.TotalAmount = "\(dict["TotalAmount"] ?? "")"
        self.createdAt = "\(dict["createdAt"] ?? "")"
        self.id = "\(dict["id"] ?? "")"
    }
}
