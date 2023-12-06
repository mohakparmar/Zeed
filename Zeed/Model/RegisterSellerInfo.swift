//
//  RegisterSellerInfo.swift
//  Zeed
//
//  Created by Shrey Gupta on 19/04/21.
//

import Foundation

enum RegisterSellerType: String, Codable {
    case store = "Store"
    case home = "Home"
}

struct RegisterSellerInfo: Codable {
    var shopName: String = ""
    var type: RegisterSellerType = .home
    var address: String = ""
    var aboutBusiness: String = ""
    var license: ItemMedia = ItemMedia()
    var bankName: String = ""
    var civilId: String = ""
    var IBAN: String = ""
    var isStoreVerified: Bool = false
    
    init() {
        
    }
    
    init(dict: [String: Any]) {
        self.shopName = dict["shopName"] as? String ?? ""
        let storeType = dict["type"] as? String  ?? ""
        self.type = RegisterSellerType(rawValue: storeType) ?? .home
        self.address = dict["address"] as? String ?? ""
        self.aboutBusiness = dict["aboutBusiness"] as? String ?? ""
        
        let licenseDict = dict["licence"] as? [String: Any] ?? [String: Any]()
        self.license = ItemMedia(dict: licenseDict)
        
        self.bankName = dict["bankName"] as? String ?? ""
        self.IBAN = dict["IBAN"] as? String ?? ""
        self.civilId = dict["civilId"] as? String ?? ""
        self.isStoreVerified = dict["isStoreVerified"] as? Bool ?? false
    }
}
