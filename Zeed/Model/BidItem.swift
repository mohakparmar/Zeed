//
//  BidItem.swift
//  Zeed
//
//  Created by Shrey Gupta on 02/04/21.
//

import Foundation

enum BidItemStatus: String {
    case upcoming = "upcoming"
    case ongoing = "ongoing"
    case completed = "completed"
}

struct BidItem {
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
    
    var status: BidItemStatus

    var initialPrice: Double
    var endingPrice: Double
    
    var currentBid: CurrentBidItem?
    
    var minPostIncrementPrice: Double
    var registrationAmount: Double
    var hasPaidRegistrationPrice: Bool
    var countRegistrationUsers: Int
    
    var biddingStatistics: BiddingStatistics

    var displayStatus: BidItemStatus
    
    var isLiked: Bool
    var isReported: Bool
    var isActive: Bool

    var likeCount: Int
    var reportCount: Int
    var commentCount: Int
    var viewCount: Int
    
    var startDate: Date
    var endDate: Date
    
    var creationDate: Date
    var arrPurchaseBy: [User]

    var purchasedBy: User


    // purchase nil
    //

    init(dict: [String: Any]) {
        self.id = dict["id"] as? String ?? ""
        
        let userData = dict["User"] as? [String: Any] ?? [String: Any]()
        self.owner = Zeed.User(dictionary: userData)
        
        let typeString = dict["type"] as? String ?? ""
        self.type = PostType(rawValue: typeString) ?? .fixed
        
        let baseType = dict["postBaseType"] as? String ?? ""
        self.postBaseType = PostBaseType(rawValue: baseType) ?? .normalBidding
        
        self.title = dict["title"] as? String ?? ""
        self.title_ar = dict["title_ar"] as? String ?? ""
        self.about = dict["about"] as? String ?? ""
        self.location = dict["location"] as? String ?? ""
        
        let statusType = dict["status"] as? String ?? ""
        self.status = BidItemStatus(rawValue: statusType) ?? .ongoing
        
        let displayStatusString = dict["displayStatus"] as? String ?? ""
        self.displayStatus = BidItemStatus(rawValue: displayStatusString) ?? .ongoing
        
        let categoryData = dict["Category"] as? [String: Any] ?? [String: Any]()
        self.category = ItemCategory(dict: categoryData)

        let subCate = dict["subCategory"] as? [String: Any] ?? [String: Any]()
        self.subCategory = ItemSubCategory(dict: subCate)

        let allMediaData = dict["Media"] as? [[String: Any]] ?? [[String: Any]]()
        var allMedia = [ItemMedia]()
        allMediaData.forEach { (mediaData) in
            let media = ItemMedia(dict: mediaData)
            allMedia.append(media)
        }
        self.medias = allMedia
        
        self.initialPrice = dict["startBiddingPrice"] as? Double ?? 0
        self.endingPrice = dict["endBiddingPrice"] as? Double ?? 0
        
        self.minPostIncrementPrice = dict["minPostIncrementPrice"] as? Double ?? 0
        self.registrationAmount = dict["registrationAmount"] as? Double ?? 0
        self.hasPaidRegistrationPrice = dict["PaidRegistrationPrice"] as? Bool ?? false
        self.countRegistrationUsers = dict["countRegistrationUsers"] as? Int ?? 0
        
        let biddingStatsData = dict["biddingStatistics"] as? [String: Any] ?? [String: Any]()
        self.biddingStatistics = BiddingStatistics(dict: biddingStatsData)
        
        let currentBidData = dict["currentBid"] as? [String: Any] ?? nil
        if let currentBidData = currentBidData {
            self.currentBid = CurrentBidItem(dict: currentBidData)
        } else {
            self.currentBid = nil
        }
        
        self.isActive = dict["active"] as? Bool ?? false
        
        self.isLiked = dict["liked"] as? Bool ?? false
        self.isReported = dict["reported"] as? Bool ?? false
        
        self.likeCount = dict["likeCount"] as? Int ?? 0
        self.reportCount = dict["reportCount"] as? Int ?? 0
        self.commentCount = dict["commentCount"] as? Int ?? 0
        self.viewCount = dict["views"] as? Int ?? 0
        
        
        var startDateInt = dict["startDate"] as? Int ?? 0
        startDateInt = startDateInt/1000
        self.startDate = Date(timeIntervalSince1970: TimeInterval(startDateInt))
        
        var endDateInt = dict["endDate"] as? Int ?? 0
        endDateInt = endDateInt/1000
        self.endDate = Date(timeIntervalSince1970: TimeInterval(endDateInt))
        
        let createdAtInt = dict["createdAt"] as? Int ?? 0
        self.creationDate = Date(timeIntervalSince1970: TimeInterval(createdAtInt))
        
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

struct CurrentBidItem {
    let id: String
    var price: Double
    let isWinner: Bool
    let type: String
    let creationDate: Date
    let postId: String
    
    let owner: CurrentBidUser
    
    init(dict: [String: Any]) {
        self.id = dict["id"] as? String ?? ""
        self.price = dict["Price"] as? Double ?? 0
        self.isWinner = dict["isWinner"] as? Bool ?? false
        self.type = dict["type"] as? String ?? ""
        
        self.postId = dict["PostId"] as? String ?? ""
        
        let createdAtInt = dict["createdAt"] as? Int ?? 0
        self.creationDate = Date(timeIntervalSince1970: TimeInterval(createdAtInt))
        
        let ownerData = dict["User"] as? [String: Any] ?? [String: Any]()
        self.owner = CurrentBidUser(dict: ownerData)
    }
}

struct CurrentBidUser {
    let id: String
    let fullName: String
    let userName: String
    let email: String
    let isSeller: Bool
    let isVerified: Bool
    var isPublic: Bool
    var media: [ItemMedia]
    
    init(dict: [String: Any]) {
        self.id = dict["id"] as? String ?? ""
        self.fullName = dict["fullName"] as? String ?? ""
        
        self.userName = dict["userName"] as? String ?? ""
        self.email = dict["email"] as? String ?? ""
        
        self.isSeller = dict["isSeller"] as? Bool ?? false
        self.isVerified = dict["isVerified"] as? Bool ?? false
        self.isPublic = dict["public"] as? Bool ?? false
        
        let allMediaData = dict["Media"] as? [[String: Any]] ?? [[String: Any]]()
        var allMedia = [ItemMedia]()
        allMediaData.forEach { (mediaData) in
            let media = ItemMedia(dict: mediaData)
            allMedia.append(media)
        }
        self.media = allMedia
    }
}

struct BiddingStatistics {
    let startPrice: Double
    let endPrice: Double
    let views: Int
    let totalBiddings: Int
    let postStatus: BidItemStatus
    
    init(dict: [String: Any]) {
        self.startPrice = dict["startPrice"] as? Double ?? 0
        self.endPrice = dict["endPrice"] as? Double ?? 0
        self.views = dict["views"] as? Int ?? 0
        self.totalBiddings = dict["totalBidding"] as? Int ?? 0
        
        let statusString = dict["postStatus"] as? String ?? ""
        self.postStatus = BidItemStatus(rawValue: statusString) ?? .upcoming
    }
}

struct BidMadeUser {
    let id: String
    let email: String
    let fullName: String
    let about: String
    let isSeller: Bool
    let isVerified: Bool
    var isPublic: Bool
    let mobileNumber: String
    let userName: String
    let image: UserImage
    let bidAmount: Double
    
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.fullName = dictionary["fullName"] as? String ?? ""
        self.about = dictionary["about"] as? String ?? ""
        self.isSeller = dictionary["isSeller"] as? Bool ?? false
        self.isVerified = dictionary["isVerified"] as? Bool ?? false
        self.mobileNumber = dictionary["mobileNumber"] as? String ?? ""
        self.userName = dictionary["userName"] as? String ?? ""
        self.isPublic = dictionary["public"] as? Bool ?? true
        
        let imageDict = dictionary["Media"] as? [[String: Any]] ?? [[String: Any]]()
        if imageDict.count > 0 {
            self.image = UserImage(dictionary: imageDict.first!)
        } else {
            image = UserImage(dictionary: [:])
        }
        
        self.bidAmount = dictionary["bidMade"] as? Double ?? 0
    }
}
