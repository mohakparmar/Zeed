//
//  PurchasedPostItem.swift
//  Zeed
//
//  Created by Shrey Gupta on 10/09/21.
//

import Foundation

struct PurchasedPostItem {
    let id: String
    let postId: String

    let type: PostType
    let postBaseType: PostBaseType

    let title: String
    let title_ar: String
    let about: String
    let location: String

    let categoryId: String
    let userId: String
    let medias: [ItemMedia]
    
    let price: Double
    let quantity: Int

    var purchaseStatus: PurchasedItemStatus
    let quantitySold: Int
    
    let creationDate: Date
    
    let startDate: Date
    let endDate: Date
    

    init(dict: [String: Any]) {
        self.id = dict["id"] as? String ?? ""
        self.postId = dict["PostId"] as? String ?? ""
        let typeString = dict["type"] as? String ?? ""
        self.type = PostType(rawValue: typeString) ?? .fixed
        
        let baseType = dict["postBaseType"] as? String ?? ""
        self.postBaseType = PostBaseType(rawValue: baseType) ?? .normalSelling
        
        self.title = dict["title"] as? String ?? ""
        self.title_ar = dict["title_ar"] as? String ?? ""
        self.about = dict["about"] as? String ?? ""
        self.location = dict["location"] as? String ?? ""
        
        self.categoryId = dict["CategoryId"] as? String ?? ""
        self.userId = dict["UserId"] as? String ?? ""
        
        let allMediaData = dict["PostMedia"] as? [[String: Any]] ?? [[String: Any]]()
        var allMedia = [ItemMedia]()
        allMediaData.forEach { (mediaData) in
            let media = ItemMedia(dict: mediaData)
            allMedia.append(media)
        }
        if let dictPost = dict["Post"] as? [String:Any] {
            if let allData = dictPost["PostMedia1"] as? [[String: Any]] {
                if allData.count > 0 {
                    allData.forEach { (mediaData) in
                        let media = ItemMedia(dict: mediaData)
                        allMedia.append(media)
                    }
                }
            }
        }
        
        self.medias = allMedia

        self.price = dict["price"] as? Double ?? 0
        self.quantity = dict["quantity"] as? Int ?? 0
        
        self.quantitySold = dict["quantitySold"] as? Int ?? 0
        
        let createdAtInt = dict["createdAt"] as? Int ?? 0
        self.creationDate = Date(timeIntervalSince1970: TimeInterval(createdAtInt))
        
        let startDateInt = dict["startDate"] as? Int ?? 0
        self.startDate = Date(timeIntervalSince1970: TimeInterval(startDateInt))
        
        let endDateInt = dict["endDate"] as? Int ?? 0
        self.endDate = Date(timeIntervalSince1970: TimeInterval(endDateInt))
        
        let purchaseStatusDict = dict["purchaseStatus"] as? [String: Any] ?? [String: Any]()
        self.purchaseStatus = PurchasedItemStatus(dict: purchaseStatusDict)
    }
}

struct PurchasedItemStatus {
    var purchaseId: String
    let purchasedOn: Date
    let paymentType: String
    let purchaseAmount: Double
    let transactionId: String
    let status: String
    let Address: String
    var hidden: String

    init(dict: [String: Any]) {
        self.purchaseId = "\(dict["purchaseId"] ?? "")"
        if let name = dict["purchasedId"] as? String {
            self.purchaseId = name
        }
        self.paymentType = dict["paymentType"] as? String ?? ""
        self.purchaseAmount = dict["purchaseAmount"] as? Double ?? 0
        self.transactionId = dict["transactionId"] as? String ?? ""
        self.status = dict["status"] as? String ?? ""
        self.Address = dict["Address"] as? String ?? "need to be coded"
        self.hidden = "\(dict["hidden"] ?? "")"

        print("thjis is item", self.hidden)
        let purchasedOnInt = dict["purchasedOn"] as? Int ?? 0
        self.purchasedOn = Date(timeIntervalSince1970: TimeInterval(purchasedOnInt))
    }
}


