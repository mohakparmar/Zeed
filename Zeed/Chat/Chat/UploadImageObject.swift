//
//  UploadImageObject.swift
//  FFlash
//
//  Created by hemant agarwal on 04/04/20.
//  Copyright © 2020 hemant agarwal. All rights reserved.
//

import UIKit

class UploadImageObject: NSObject {

    @objc dynamic var UserId: String! = ""
    @objc dynamic var createdAt: String! = ""
    @objc dynamic var id: String! = ""
    @objc dynamic var min: String! = ""
    @objc dynamic var type: String! = ""
    @objc dynamic var updatedAt: String! = ""
    @objc dynamic var url: String! = ""
    dynamic var arrForTaggedUser: [User] = []

    
    
    override init() {
        
    }
    
    init(dict:[String : AnyObject]) {
        // print(dict)
        UserId = Utility.getValue(dict: dict, key: "UserId")
        createdAt = Utility.getValue(dict: dict, key: "createdAt")
        id = Utility.getValue(dict: dict, key: "id")
        min = Utility.getValue(dict: dict, key: "min")
        type = Utility.getValue(dict: dict, key: "type")
        updatedAt = Utility.getValue(dict: dict, key: "updatedAt")
        url = Utility.getValue(dict: dict, key: "url")
        
        if let arr = dict["mediaTagPost"] as? [[String : AnyObject]] {
            for item in arr {
                arrForTaggedUser.append(User(dictionary: item))
            }
        }
        
    }
}
