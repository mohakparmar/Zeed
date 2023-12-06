//
//  ChatObject.swift
//  FFlash
//
//  Created by hemant agarwal on 06/04/20.
//  Copyright © 2020 hemant agarwal. All rights reserved.
//

import UIKit

class ChatObject: NSObject {
    
    @objc dynamic var UserId: String! = ""
    @objc dynamic var createdAt: String! = ""
    @objc dynamic var id: String! = ""
    @objc dynamic var objMedia: UploadImageObject! = UploadImageObject()
    @objc dynamic var targetGroupId: String! = ""
    @objc dynamic var targetUserId: String! = ""
    @objc dynamic var text: String! = ""
    @objc dynamic var updatedAt: String! = ""
    @objc dynamic var dateToShow: String! = ""
    @objc dynamic var isSendByMe: Bool = false
    @objc dynamic var heightForText: CGFloat = 30
    @objc dynamic var heightForTable: CGFloat = 0
    @objc dynamic var widthForText: CGFloat = 30
    @objc dynamic var typeOfMessage: String! = "1"
    @objc dynamic var MediumId: String! = ""
    dynamic var objPost: PostItem?
    @objc dynamic var roomId: String! = ""
    @objc dynamic var arrChild: [ChatObject] = []
    @objc dynamic var likeCount: String! = ""
    @objc dynamic var isLiked: String! = ""
    @objc dynamic var isChild: Bool = false
    @objc dynamic var arrForUsers: [String] = []
    @objc dynamic var arrRange: [NSRange] = []
    @objc dynamic var attTextToDisplay: NSAttributedString = NSAttributedString()

    override init() {
        
    }
    
    init(dict:[String : AnyObject]) {
        print(dict)
        MediumId = Utility.getValue(dict: dict, key: "MediumId")
        UserId = Utility.getValue(dict: dict, key: "UserId")
        createdAt = Utility.getValue(dict: dict, key: "createdAt")
        id = Utility.getValue(dict: dict, key: "id")
        targetGroupId = Utility.getValue(dict: dict, key: "targetGroupId")
        targetUserId = Utility.getValue(dict: dict, key: "targetUserId")
        text = Utility.getValue(dict: dict, key: "text").decode()
        updatedAt = Utility.getValue(dict: dict, key: "updatedAt")

        dateToShow = Date().getFormattedDate(string: createdAt, formatter: "dd-MM-yyyy, hh:mm a")
        
        if let media = dict["userId"] {
            UserId = media as? String
        }
        
        if let media = dict["Medium"] as? [String:AnyObject] {
            objMedia = UploadImageObject(dict: media)
        }

        if let post = dict["Post"] as? [String:AnyObject] {
            objPost = PostItem(dict: post)
        }

        if AppUser.shared.getDefaultUser()!.id == UserId {
            isSendByMe = true
        }
        
        let objFrame = ChatObject.getHeightfromText(str: text)
        heightForText = objFrame.height
        widthForText = objFrame.width

        if MediumId.checkEmpty() == false {
            if MediumId != "<null>" {
                typeOfMessage = "2"
                heightForText = 270
                if objMedia.type.contains("image") {
                    text = "Image"
                } else if objMedia.type.contains("video") {
                    text = "Video"
                } else if objMedia.type.contains("audio") {
                    typeOfMessage = "3"
                    heightForText = 100
                    text = "Audio"
                }
            }
        }
    
        print(objPost?.id)
        if objPost?.id.checkEmpty() == false  {
            typeOfMessage = "5"
            heightForText = 330
        }

        
        
        
    }
    
    class func getHeightfromText(str:String) -> (height:CGFloat, width:CGFloat) {
        var rect:CGRect
        let font:UIFont = UIFont(name: "AvenirNextLTPro-Demi", size: 16) ?? UIFont()
        rect = Utility.heightForView(text: str, font: font, width: screenWidth - 90)
        var height:CGFloat = 0
        if rect.height < 40 {
            height = 40
        }
        height = rect.height + 60
        return (height,rect.width)
    }

    class func getHeightfromText1(str:String) -> (height:CGFloat, width:CGFloat) {
        var rect:CGRect
        let font:UIFont = UIFont(name: "AvenirNextLTPro-Demi", size: 16) ?? UIFont()
        rect = Utility.heightForView(text: str, font: font, width: screenWidth - 155)
        var height:CGFloat = 0
        if rect.height < 40 {
            height = 40
        }
        height = rect.height + 60
        return (height,rect.width)
    }

    
    class func addBoldText(fullString: String, boldPartsOfString: [String], font: UIFont!, boldFont: UIFont!) -> (NSAttributedString, [NSRange]) {

        let attributedString = NSMutableAttributedString(string:fullString)
        var rangeArray : [NSRange] = []
        let rangeOfFullString = NSRange(location: 0, length: fullString.count)//fullString.range(of: fullString)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: rangeOfFullString)
        attributedString.addAttribute(NSAttributedString.Key.font, value: font, range: rangeOfFullString)

        for i in 0 ..< boldPartsOfString.count {
            let rangeOfSubString = (fullString as NSString).range(of: boldPartsOfString[i])
            rangeArray.append(rangeOfSubString)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor().setColor(hex: "97F9D6", alphaValue: 1), range: rangeOfSubString)
            attributedString.addAttribute(NSAttributedString.Key.font, value: boldFont, range: rangeOfSubString)

        }
        
        return (attributedString, rangeArray)
    }

    

    class func getNames(str:String) -> [String] {
        let fullNameArr = str.components(separatedBy: " ")
        
        if fullNameArr.count > 0 {
            let filteredStrings = fullNameArr.filter({(item: String) -> Bool in
                let stringMatch = item.lowercased().range(of: "@")
                return stringMatch != nil ? true : false
            })
            return filteredStrings
        } else {
            return []
        }
    }
}
