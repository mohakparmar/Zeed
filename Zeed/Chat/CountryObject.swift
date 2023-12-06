//
//  CountryObject.swift
//  FFlash
//
//  Created by hemant agarwal on 04/04/20.
//  Copyright © 2020 hemant agarwal. All rights reserved.
//

import UIKit

class CountryObject: NSObject {

    @objc dynamic var capital: String! = ""
    @objc dynamic var code: String! = ""
    @objc dynamic var continent: String! = ""
    @objc dynamic var currency: String! = ""
    @objc dynamic var emoji: String! = ""
    @objc dynamic var emojiU: String! = ""
    @objc dynamic var languages: [String] = []
    @objc dynamic var name: String! = ""
    @objc dynamic var native: String! = ""
    @objc dynamic var phone: String! = ""

    override init() {
        
    }
    
    init(dict:[String : AnyObject]) {
        capital = Utility.getValue(dict: dict, key: "capital")
        code = Utility.getValue(dict: dict, key: "code")
        continent = Utility.getValue(dict: dict, key: "continent")
        currency = Utility.getValue(dict: dict, key: "currency")
        emoji = Utility.getValue(dict: dict, key: "emoji")
        emojiU = Utility.getValue(dict: dict, key: "emojiU")
        name = Utility.getValue(dict: dict, key: "name")
        native = Utility.getValue(dict: dict, key: "native")
        phone = Utility.getValue(dict: dict, key: "phone")

        

    }

}
