//
//  ImageObject.swift
//  FFlash
//
//  Created by hemant agarwal on 28/02/20.
//  Copyright © 2020 hemant agarwal. All rights reserved.
//

import UIKit
import Photos

class ImageObject: NSObject {

    @objc dynamic var selected = false
    @objc dynamic var image:UIImage = UIImage()
    @objc dynamic var videoUrl:URL!
    @objc dynamic var dataVideo:Data!
    @objc dynamic var strType:String? = ""
    @objc dynamic var strURL:String? = ""
    @objc dynamic var assert:PHAsset?
    @objc dynamic var objuser:UserObject?
    @objc dynamic var arrTags:[UserObject] = []

    override init() {
        
    }
    
    init(img:UIImage) {
        image = img
        selected = false
    }

    class func initWithPh(ass:PHAsset, type:String) -> ImageObject {
        let obj = ImageObject()
        obj.assert = ass
        obj.strType = type
        obj.strURL = ass.getPathOfAssert()
        obj.selected = false
        return obj
    }
    
}
