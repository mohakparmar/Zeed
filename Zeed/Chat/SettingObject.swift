//
//  SettingObject.swift
//  Post
//
//  Created by hemant agarwal on 23/01/20.
//  Copyright © 2020 hemant agarwal. All rights reserved.
//

import UIKit

class SettingObject: NSObject {

    @objc dynamic var str_title = ""
    @objc dynamic var str_img = ""
    @objc dynamic var tagForItem = 0

    init(text:String, img:String, tag:Int) {
        str_title = text
        str_img = img
        tagForItem = tag
    }
}
