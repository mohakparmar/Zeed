//
//  UserNotification.swift
//  Zeed
//
//  Created by Shrey Gupta on 30/03/21.
//

import Foundation

enum UserNotificationType: String, CaseIterable {
    case like = "like"
    case comment = "comment"
    case follow = "follow"
}

struct UserNotification {
    let type: UserNotificationType
    
    let fromUserId: String
    let fromUsername: String
    let fromUserPicture: String
    
    let onPostImage: String
    let onPostId: String
    
    var atTime: Date
    
    
//    init(dictionary: [String: Any]) {
//        let typeString = dictionary["type"] as? String ?? ""
//
//        self.type = UserNotificationType(rawValue: typeString)!
//        self.fromUserId = dictionary["fromUserId"] as? String ?? ""
//        self.fromUsername = dictionary["fromUsername"] as? String ?? ""
//        self.fromUserPicture = dictionary["fromUserPicture"] as? String ?? ""
//        self.onPostImage = dictionary["onPostImage"] as? String ?? ""
//        self.onPostId = dictionary["onPostId"] as? String ?? ""
//
//        let creationDateRaw = dictionary["atTime"] as? Double ?? 0
//        self.atTime = Date(timeIntervalSince1970: creationDateRaw)
//    }
}


class GeneralNotification : NSObject {
    
    var text : String = ""
    var atTime: Date
    var userName:String = ""
    var userImage:String = ""

    init(dict: [String: Any]) {
        self.text = "\(dict["text"] ?? "")"
        let creationDateRaw = dict["createdAt"] as? Double ?? 0
        self.atTime = Date(timeIntervalSince1970: creationDateRaw)

        if let dictUser = dict["from"] as? [String:Any] {
            self.userName = "\(dictUser["userName"] ?? "")"
            if let userImage = dictUser["image"] as? [String:Any] {
                self.userImage = "\(userImage["url"] ?? "")"
            }
        }
    }
    
}
