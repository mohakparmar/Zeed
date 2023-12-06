//
//  UserObject.swift
//  FFlash
//
//  Created by hemant agarwal on 26/03/20.
//  Copyright © 2020 hemant agarwal. All rights reserved.
//

import UIKit

class UserObject: NSObject {

    @objc dynamic var admin : String! = ""
    @objc dynamic var deviceToken : String! = ""
    @objc dynamic var mobileNumber : String! = ""
    @objc dynamic var dob : String! = ""
    @objc dynamic var deviceName: String! = ""
    @objc dynamic var password: String! = ""
    @objc dynamic var status: String! = ""
    @objc dynamic var username: String! = ""
    @objc dynamic var public1: String! = ""
    @objc dynamic var createdAt: String! = ""
    @objc dynamic var countryId: String! = ""
    @objc dynamic var image: String! = ""
    @objc dynamic var updatedAt: String! = ""
    @objc dynamic var email: String! = ""
    @objc dynamic var id: String! = ""
    @objc dynamic var emailVerified: String! = ""
    @objc dynamic var auth: String! = ""
    @objc dynamic var gender: String! = ""
    @objc dynamic var deviceType: String! = ""
    @objc dynamic var countryCode: String! = ""
    @objc dynamic var deviceId: String! = ""
    @objc dynamic var gendr: String! = ""
    @objc dynamic var about: String! = ""
    @objc dynamic var objImage: UploadImageObject! = UploadImageObject()
    @objc dynamic var objCountry: CountryObject! = CountryObject()
    @objc dynamic var objChat: ChatObject! = ChatObject()
    @objc dynamic var following: String! = ""
    @objc dynamic var followers: String! = ""
    @objc dynamic var followStatus: String! = ""
    var isSelectedForGroup:Bool = false
    var isTyping:Bool = false
    @objc dynamic var type: String! = ""
    @objc dynamic var isBlockByUser: String! = ""

    @objc dynamic var muted: String! = ""
    @objc dynamic var accepted: String! = ""
    @objc dynamic var rejected: String! = ""
    @objc dynamic var acceptedCohost: String! = ""
    @objc dynamic var rejectedCohost: String! = ""
    @objc dynamic var invited: String! = ""

    override init() {
        
    }
    
    init(dict:[String : AnyObject]) {
        //print(dict)
        rejected = Utility.getValue(dict: dict, key: "rejected")
        accepted = Utility.getValue(dict: dict, key: "accepted")
        muted = Utility.getValue(dict: dict, key: "muted")
        invited = Utility.getValue(dict: dict, key: "invited")
        acceptedCohost = Utility.getValue(dict: dict, key: "acceptedCohost")
        rejectedCohost = Utility.getValue(dict: dict, key: "rejectedCohost")

        admin = Utility.getValue(dict: dict, key: "admin")
        following = Utility.getValue(dict: dict, key: "following")
        followers = Utility.getValue(dict: dict, key: "followers")
        about = Utility.getValue(dict: dict, key: "about")
        deviceToken = Utility.getValue(dict: dict, key: "deviceToken")
        mobileNumber = Utility.getValue(dict: dict, key: "mobileNumber")
        dob = Utility.getValue(dict: dict, key: "dob")
        deviceName = Utility.getValue(dict: dict, key: "deviceName")
        password = Utility.getValue(dict: dict, key: "password")
        status = Utility.getValue(dict: dict, key: "status")
        public1 = Utility.getValue(dict: dict, key: "public")
        createdAt = Utility.getValue(dict: dict, key: "createdAt")
        countryId = Utility.getValue(dict: dict, key: "countryId")
        image = Utility.getValue(dict: dict, key: "image")
        updatedAt = Utility.getValue(dict: dict, key: "updatedAt")
        email = Utility.getValue(dict: dict, key: "email")
        id = Utility.getValue(dict: dict, key: "id")
        emailVerified = Utility.getValue(dict: dict, key: "emailVerified")
        auth = Utility.getValue(dict: dict, key: "auth")
        gender = Utility.getValue(dict: dict, key: "gender")
        deviceType = Utility.getValue(dict: dict, key: "deviceType")
        countryCode = Utility.getValue(dict: dict, key: "countryCode")
        deviceId = Utility.getValue(dict: dict, key: "deviceId")
        username = Utility.getValue(dict: dict, key: "userName")
        followStatus = Utility.getValue(dict: dict, key: "followStatus")
        type = Utility.getValue(dict: dict, key: "type")
        isBlockByUser = Utility.getValue(dict: dict, key: "isBlockByUser")

        if let dictImae = dict["image"] as? [String:AnyObject] {
            objImage = UploadImageObject(dict: dictImae)
        }
        
        if let dictImae = dict["country"] as? [String:AnyObject] {
            objCountry = CountryObject(dict: dictImae)
        }
        
        if let dictImae = dict["Message"] as? [String:AnyObject] {
            objChat = ChatObject(dict: dictImae)
        }
    }

}


struct SellerTransaction {
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
