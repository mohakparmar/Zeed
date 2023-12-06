//
//  MyBiddingItem.swift
//  Zeed
//
//  Created by Shrey Gupta on 31/10/21.
//

import Foundation

struct MyBiddingItem {
    let id: String
    
    let owner: User

    let type: PostType
    let postBaseType: PostBaseType

    let title: String
    let title_ar: String
    
    let about: String
    let location: String

    let categoryId: String
    let medias: [ItemMedia]
    
    let status: BidItemStatus

    let initialPrice: Double
    let endingPrice: Double
    
    let quantity: Int
    let quantitySold: Int
    
    let currentBid: CurrentBidItem?
    let myBid: MyBid
    
    let minPostIncrementPrice: Double
    let registrationAmount: Double
    var hasPaidRegistrationPrice: Bool
    let countRegistrationUsers: Int
    
    let biddingStatistics: BiddingStatistics

    let displayStatus: String
    
    var isLiked: Bool
    var isReported: Bool
    var isActive: Bool
    var isPurchased: Bool

    let likeCount: Int
    let reportCount: Int
    let commentCount: Int
    let viewCount: Int
    
    let startDate: Date
    let endDate: Date
    
    let creationDate: Date
    

    init(dict: [String: Any]) {
        self.id = dict["id"] as? String ?? ""
        
        let userData = dict["User"] as? [String: Any] ?? [String: Any]()
        self.owner = Zeed.User(dictionary: userData)
        
        let typeString = dict["type"] as! String
        self.type = PostType(rawValue: typeString)!
        
        let baseType = dict["postBaseType"] as? String ?? ""
        self.postBaseType = PostBaseType(rawValue: baseType)!
        
        self.title = dict["title"] as? String ?? ""
        self.title_ar = dict["title_ar"] as? String ?? ""
        
        self.about = dict["about"] as? String ?? ""
        self.location = dict["location"] as? String ?? ""
        
        let statusType = dict["status"] as? String ?? ""
        self.status = BidItemStatus(rawValue: statusType)!
        
        self.displayStatus = dict["displayStatus"] as? String ?? ""
        
        self.categoryId = dict["CategoryId"] as? String ?? ""
        
        let allMediaData = dict["PostMedia"] as? [[String: Any]] ?? [[String: Any]]()
        var allMedia = [ItemMedia]()
        allMediaData.forEach { (mediaData) in
            let media = ItemMedia(dict: mediaData)
            allMedia.append(media)
        }
        self.medias = allMedia
        
        self.initialPrice = dict["startBiddingPrice"] as? Double ?? 0
        self.endingPrice = dict["endBiddingPrice"] as? Double ?? 0
        
        self.quantity = dict["quantity"] as? Int ?? 0
        self.quantitySold = dict["quantitySold"] as? Int ?? 0

        
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
        
        let myBidData = dict["myBid"] as? [String: Any] ?? [String: Any]()
        self.myBid = MyBid(dict: myBidData)
        
        
        self.isActive = dict["active"] as? Bool ?? false
        
        self.isLiked = dict["liked"] as? Bool ?? false
        self.isReported = dict["reported"] as? Bool ?? false
        self.isPurchased = dict["isPurchased"] as? Bool ?? false
        
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
    }
    
    struct MyBid {
        let id: String
        let price: Double
        let isWinner: Bool
        let type: String
        
        init(dict: [String: Any]) {
            self.id = dict["id"] as? String ?? ""
            self.price = dict["Price"] as? Double ?? 0
            self.isWinner = dict["isWinner"] as? Bool ?? false
            self.type = dict["type"] as? String ?? ""
        }
    }
}

