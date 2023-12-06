//
//  ChatListObject.swift
//  FFlash
//
//  Created by hemant agarwal on 27/05/20.
//  Copyright © 2020 hemant agarwal. All rights reserved.
//

import UIKit

class ChatListObject: NSObject {
    @objc dynamic var objUser: UserObject = UserObject()
    @objc dynamic var wasAnonymous: String! = ""
    @objc dynamic var anonymous: String! = ""
    @objc dynamic var type: String! = ""
    @objc dynamic var unSeen: String! = ""
    @objc dynamic var objChat: ChatObject = ChatObject()
    
    override init() {
        
    }
    
    init(dict:[String : AnyObject]) {
        print(dict)
        unSeen = Utility.getValue(dict: dict, key: "unSeen")
        type = Utility.getValue(dict: dict, key: "type")
        anonymous = Utility.getValue(dict: dict, key: "anonymous")
        wasAnonymous = Utility.getValue(dict: dict, key: "wasAnonymous")
        if type.uppercased() == "GROUP" {
            objUser.id =  Utility.getValue(dict: dict, key: "id")
            if let dictMedia = dict["media"] as? [String:AnyObject] {
                objUser.objImage = UploadImageObject(dict: dictMedia)
            }
            objUser.username =  Utility.getValue(dict: dict, key: "name")
            objUser.type = type
        } else {
            if let dictUser = dict["user"] as? [String:AnyObject] {
                objUser = UserObject(dict: dictUser)
            }
        }

        if let dictChat = dict["Message"] as? [String:AnyObject] {
            objChat = ChatObject(dict: dictChat)
        }
    }
}
