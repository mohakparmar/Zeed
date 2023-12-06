//
//  CartItem.swift
//  Zeed
//
//  Created by Shrey Gupta on 01/04/21.
//

import Foundation

struct CartItem {
    let id: String
    let type: PostType
    let postBaseType: PostBaseType
    
    let startDate: Date
    let endDate: Date
    let about: String
    
    let status: String
    
    let viewCount: Int
    let title: String
    
    var isActive: Bool
    let location: String
    
    let price: Double
    let quantityAvailable: Int
    
    let quantitySold: Int

    let displayStatus: String
    
    let creationDate: Date
    
    let userId: String
    
    let medias: [ItemMedia]
    let categoryId: String
    
    let selectedQuantity: Int
    
    let totalPrice: Double
    
    let cartId: String
    
    let selectedVariant: ItemVariant?
    
    let outOfStock: Bool

    let storeId: String
    let storeName: String

    
    init(dict: [String: Any]) {
        self.id = dict["id"] as? String ?? ""
        self.cartId = dict["cartId"] as? String ?? ""
        self.quantityAvailable = dict["quantity"] as? Int ?? 0
        
        self.totalPrice = dict["totalPrice"] as? Double ?? 0
        
        if let variantData = dict["selectedVariant"] as? [String: Any] {
            self.selectedVariant = ItemVariant(dict: variantData)
        } else {
            self.selectedVariant = nil
        }
        
        if let storeData = dict["storeDetails"] as? [String: Any] {
            self.storeId = storeData["id"] as? String ?? ""
            self.storeName = storeData["userName"] as? String ?? ""
        } else {
            self.storeId = ""
            self.storeName = ""
        }
        let createdAtInt = dict["createdAt"] as? Int ?? 0
        self.creationDate = Date(timeIntervalSince1970: TimeInterval(createdAtInt))
        
        self.outOfStock = dict["outOfStock"] as? Bool ?? false
        
        
        let typeString = dict["type"] as! String
        self.type = PostType(rawValue: typeString)!
        
        let baseType = dict["postBaseType"] as? String ?? ""
        self.postBaseType = PostBaseType(rawValue: baseType)!
        
        self.title = dict["title"] as? String ?? ""
        self.about = dict["about"] as? String ?? ""
        self.location = dict["location"] as? String ?? ""
        
        self.status = dict["status"] as? String ?? ""
        self.displayStatus = dict["displayStatus"] as? String ?? ""
        
        self.selectedQuantity = dict["selectedQuantity"] as? Int ?? 0
        
        self.userId = dict["userId"] as? String ?? ""
        self.categoryId = dict["categoryId"] as? String ?? ""
        
        
        let allMediaData = dict["Media"] as? [[String: Any]] ?? [[String: Any]]()
        var allMedia = [ItemMedia]()
        allMediaData.forEach { (mediaData) in
            let media = ItemMedia(dict: mediaData)
            allMedia.append(media)
        }
        self.medias = allMedia
    
        self.price = dict["price"] as? Double ?? 0
        
        self.isActive = dict["active"] as? Bool ?? false
        self.viewCount = dict["views"] as? Int ?? 0
        self.quantitySold = dict["quantitySold"] as? Int ?? 0
        
        let startDateInt = dict["startDate"] as? Int ?? 0
        self.startDate = Date(timeIntervalSince1970: TimeInterval(startDateInt/1000))
        
        let endDateInt = dict["endDate"] as? Int ?? 0
        self.endDate = Date(timeIntervalSince1970: TimeInterval(endDateInt))

    }
}

