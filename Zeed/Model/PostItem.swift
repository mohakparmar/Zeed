//
//  PostItem.swift
//  Zeed
//
//  Created by Shrey Gupta on 15/04/21.
//

import Foundation

enum PostType: String {
    case fixed = "Fixed"
    case auction = "Auction"
}


struct PostItem {
    var id: String
    
    var owner: User

    var type: PostType
    var postBaseType: PostBaseType

    var title: String
    var title_ar: String
    var about: String
    var location: String

    var category: ItemCategory
    var subCategory: ItemSubCategory
    var medias: [ItemMedia]
    var variants: [ItemVariant]
    
    var attributes: [ItemAttribute]
    
    // FIXME: - which to use?
    var status: String
    var displayStatus: String
    
    var price: Double
    var quantity: Int

    var isLiked: Bool
    var isReported: Bool
    var isActive: Bool

    var likeCount: Int
    var reportCount: Int
    var commentCount: Int
    var viewCount: Int

    var quantitySold: Int
    
    var creationDate: Date
    
    var startDate: Date
    var endDate: Date
    
    var arrPurchaseBy: [User]
    var purchasedBy: User

    
        
    init(dict: [String: Any]) {
        self.id = dict["id"] as? String ?? ""
        
        let userData = dict["User"] as? [String: Any] ?? [String: Any]()
        self.owner = Zeed.User(dictionary: userData)
        
        let typeString = dict["type"] as? String ?? ""
        self.type = PostType(rawValue: typeString) ?? .fixed
        
        let baseType = dict["postBaseType"] as? String ?? ""
        self.postBaseType = PostBaseType(rawValue: baseType) ?? .normalSelling
        
        self.title = dict["title"] as? String ?? ""
        self.title_ar = dict["title_ar"] as? String ?? ""
        if appDele?.isForArabic == true {
            self.about = dict["location"] as? String ?? ""
        } else {
            self.about = dict["about"] as? String ?? ""
        }
        self.location = dict["location"] as? String ?? ""
        
        self.status = dict["status"] as? String ?? ""
        self.displayStatus = dict["displayStatus"] as? String ?? ""
        
        
        let categoryData = dict["Category"] as? [String: Any] ?? [String: Any]()
        self.category = ItemCategory(dict: categoryData)
        
        let subCategory = dict["subCategory"] as? [String: Any] ?? [String: Any]()
        self.subCategory = ItemSubCategory(dict: subCategory)

        
        let allMediaData = dict["Media"] as? [[String: Any]] ?? [[String: Any]]()
        var allMedia = [ItemMedia]()
        allMediaData.forEach { (mediaData) in
            let media = ItemMedia(dict: mediaData)
            allMedia.append(media)
        }
        self.medias = allMedia.reversed()
        
        self.price = dict["price"] as? Double ?? 0
        self.quantity = dict["quantity"] as? Int ?? 0

        
        let allVarientData = dict["variants"] as? [[String: Any]] ?? [[String: Any]]()
        var allVarients = [ItemVariant]()
        allVarientData.forEach { (varientData) in
            let varient = ItemVariant(dict: varientData)
            allVarients.append(varient)
        }
        self.variants = allVarients
        if self.variants.count > 0 {
            self.price = self.variants[0].price
            for obj in self.variants {
                if obj.price < self.price {
                    self.price = obj.price
                }
            }
        }
        
        
        let allAttributeData = dict["attributes"] as? [[String: Any]] ?? [[String: Any]]()
        var allAttribute = [ItemAttribute]()
        allAttributeData.forEach { (attributeData) in
            let attribute = ItemAttribute(dict: attributeData)
            allAttribute.append(attribute)
        }
        self.attributes = allAttribute
        
    
        self.isActive = dict["active"] as? Bool ?? false
        self.isLiked = dict["liked"] as? Bool ?? false
        self.isReported = dict["reported"] as? Bool ?? false
        
        self.likeCount = dict["likeCount"] as? Int ?? 0
        self.reportCount = dict["reportCount"] as? Int ?? 0
        self.commentCount = dict["commentCount"] as? Int ?? 0
        self.viewCount = dict["views"] as? Int ?? 0
        self.quantitySold = dict["quantitySold"] as? Int ?? 0
        
        let createdAtInt = dict["createdAt"] as? Int ?? 0
        self.creationDate = Date(timeIntervalSince1970: TimeInterval(createdAtInt))
        
        let startDateInt = dict["startDate"] as? Int ?? 0
        self.startDate = Date(timeIntervalSince1970: TimeInterval(startDateInt))
        
        let endDateInt = dict["endDate"] as? Int ?? 0
        self.endDate = Date(timeIntervalSince1970: TimeInterval(endDateInt))
        
        self.arrPurchaseBy = []
        if let arr = dict["purchasedBy"] as? [[String:Any]] {
            for item in arr {
                var obj = User(dictionary: [:])
                obj.id = "\(item["userId"] ?? "")"
                obj.userName = "\(item["userName"] ?? "")"
                obj.urlImage = "\(item["url"] ?? "")"
                self.arrPurchaseBy.append(obj)
            }
        }
        self.purchasedBy = User(dictionary: [:])
    }
}

struct ItemCategory {
    let id: String
    let name: String
    var name_ar: String
    let createdAt: Date
    
    init(dict: [String: Any]) {
        self.id = dict["id"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
        self.name_ar = dict["name_ar"] as? String ?? ""
        
        if self.name_ar == "" {
            self.name_ar = self.name
        }
        
        let createdAtInt = dict["createdAt"] as? Int ?? 0
      
        self.createdAt = Date(timeIntervalSince1970: TimeInterval(createdAtInt))
    }
    
}

struct ItemAttribute {
    let id: String
    let name: String
    let categoryId: String
    let createdAt: Date
    var options = [ItemAttributeOption]()
    var selectedOption: ItemAttributeOption? = nil
    
    init(dict: [String: Any]) {
        self.id = dict["id"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
        self.categoryId = dict["CategoryId"] as? String ?? ""
        
        let allOptions = dict["AttributeOptions"] as? [[String: Any]] ?? [[String: Any]]()
        
        for option in allOptions {
            let attributeOption = ItemAttributeOption(dict: option)
            self.options.append(attributeOption)
        }
        
        let createdAtInt = dict["createdAt"] as? Int ?? 0
        self.createdAt = Date(timeIntervalSince1970: TimeInterval(createdAtInt))
    }
}

struct ItemAttributeOption: Equatable {
    let id: String
    let name: String
    let parentAttributeId: String
    let createdAt: Date
    
    init(dict: [String: Any]) {
        self.id = dict["id"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
        self.parentAttributeId = dict["AttributeId"] as? String ?? ""
        
        let createdAtInt = dict["createdAt"] as? Int ?? 0
        self.createdAt = Date(timeIntervalSince1970: TimeInterval(createdAtInt))
    }
}

struct ItemVariant {
    let id: String
    let price: Double
    var quantity: Int
    let postId: String
    let active: Bool
    var attributes = [ItemVariantAttribute]()
    let attributeValueString: String
    let createdAt: Date
    let variantComboString: String
    var ItemName : String = ""
    
    init(dict: [String: Any]) {
        self.id = dict["id"] as? String ?? ""
        self.price = dict["price"] as? Double ?? 0
        self.quantity = dict["quantity"] as? Int ?? 0
        self.postId = dict["PostId"] as? String ?? ""
        self.active = dict["active"] as? Bool ?? false

        let allAttributesData = dict["VariantAttributes"] as? [[String: Any]] ?? [[String: Any]]()
        
        
        for attributeData in allAttributesData {
            let variantAttribute = ItemVariantAttribute(dict: attributeData)
            if self.ItemName == "" {
                self.ItemName = appDele!.isForArabic ? variantAttribute.type.name_ar : variantAttribute.type.name
            } else {
                self.ItemName = self.ItemName + " - " + (appDele!.isForArabic ? variantAttribute.type.name_ar : variantAttribute.type.name)
            }
            self.attributes.append(variantAttribute)
        }
        
        self.attributeValueString = dict["attributeValueString"] as? String ?? ""
        self.variantComboString = dict["variantComboString"] as? String ?? ""
        
        let createdAtInt = dict["createdAt"] as? Int ?? 0
        self.createdAt = Date(timeIntervalSince1970: TimeInterval(createdAtInt))
    }
}

struct ItemVariantAttribute {
    let id: String
    let type: ItemVariantAttributeType
    let option: ItemVariantAttributeOption
    let createdAt: Date
    var newAtt : ItemAttribute? = nil
    
    init(dict: [String: Any]) {
        self.id = dict["id"] as? String ?? ""
        
        let typeDict = dict["Attribute"] as? [String: Any] ?? [String: Any]()
        self.type = ItemVariantAttributeType(dict: typeDict)
        
        let optionDict = dict["AttributeOption"] as? [String: Any] ?? [String: Any]()
        self.option = ItemVariantAttributeOption(dict: optionDict)
        
        let createdAtInt = dict["createdAt"] as? Int ?? 0
        self.createdAt = Date(timeIntervalSince1970: TimeInterval(createdAtInt))
    }
}

struct ItemVariantAttributeType {
    let id: String
    let name: String
    let name_ar: String
    let categoryId: String
    let createdAt: Date
    
    init(dict: [String: Any]) {
        self.id = dict["id"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
        self.name_ar = dict["name_ar"] as? String ?? ""
        self.categoryId = dict["CategoryId"] as? String ?? ""
        let createdAtInt = dict["createdAt"] as? Int ?? 0
        self.createdAt = Date(timeIntervalSince1970: TimeInterval(createdAtInt))
    }
}

struct ItemVariantAttributeOption {
    let id: String
    let name: String
    let attributeId: String
    let createdAt: Date
    
    init(dict: [String: Any]) {
        self.id = dict["id"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
        self.attributeId = dict["AttributeId"] as? String ?? ""
        
        let createdAtInt = dict["createdAt"] as? Int ?? 0
        self.createdAt = Date(timeIntervalSince1970: TimeInterval(createdAtInt))
    }
}


struct SellerStatastics {
    let activePosts: String
    let cancelledCount: String
    let completedAuction: String
    let completedLiveAuction: String
    let deliveredCount: String
    let inactivePosts: String
    let ongoingAuction: String
    let ongoingLiveAuction: String
    let pendingCount: String
    let totalSales: String

    init(dict: [String: Any]) {
        self.activePosts = "\(dict["activePosts"] ?? "0")"
        self.cancelledCount = "\(dict["cancelledCount"] ?? "0")"
        self.completedAuction = "\(dict["completedAuction"] ?? "0")"
        self.completedLiveAuction = "\(dict["completedLiveAuction"] ?? "0")"
        self.deliveredCount = "\(dict["deliveredCount"] ?? "0")"
        self.inactivePosts = "\(dict["inactivePosts"] ?? "0")"
        self.ongoingAuction = "\(dict["ongoingAuction"] ?? "0")"
        self.ongoingLiveAuction = "\(dict["ongoingLiveAuction"] ?? "0")"
        self.pendingCount = "\(dict["pendingCount"] ?? "0")"
        self.totalSales = "\(dict["totalSales"] ?? "0")"
    }
}


struct ItemSubCategory {
    let id: String
    let nameEn: String
    let nameAr: String
    let createdAt: Date
    let CategoryId: String

    init(dict: [String: Any]) {
        self.id = dict["id"] as? String ?? ""
        self.nameEn = dict["nameEn"] as? String ?? ""
        self.nameAr = dict["nameAr"] as? String ?? ""
        let createdAtInt = dict["createdAt"] as? Int ?? 0
        self.createdAt = Date(timeIntervalSince1970: TimeInterval(createdAtInt))
        self.CategoryId = dict["CategoryId"] as? String ?? ""

    }
    
}
