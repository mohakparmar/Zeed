//
//  Service.swift
//  Zeed
//
//  Created by Shrey Gupta on 28/02/21.
//

// FIXME: - live aution create post add date and time and remove variants, price

import Foundation
import Alamofire
import Network

let defaults = UserDefaults.standard
var loggedInUser: User? = nil

//let REF_SERVER = "https://zeed.infoware.xyz/"
//let SOCKETURL = "https://zeed.infoware.xyz/"

let REF_SERVER: String = "https://api.zeedco.co/"
let SOCKETURL: String = "https://api.zeedco.co/"


let REF_REGISTER_USER = REF_SERVER + "user/register"
let REF_VERIFY_EMAIL = REF_SERVER + "user/verifyEmail"
let REF_LOGIN_USER = REF_SERVER + "user/login"
let REF_UPDATE_USER = REF_SERVER + "user/update"
let REF_CHANGE_PASSWORD = REF_SERVER + "user/changePassword"
let REF_FORGOT_PASSWORD = REF_SERVER + "user/forgotPassword"




let REF_HIDE_PURCHASE = REF_SERVER + "purchase/hide"

let REF_USER_GET_ONE = REF_SERVER + "user/getOne"
let REF_USER_GET_ALL = REF_SERVER + "user/getAll"

let RED_USER_SET_PUBLIC = REF_SERVER + "user/setPublic"
let RED_USER_HIDDEN_PURCHASE = REF_SERVER + "purchase/unhideAll"

let REF_USER_FOLLOW_LIST = REF_SERVER + "user/followList"
let REF_USER_REQUEST_LIST = REF_SERVER + "user/requestList"

let REF_USER_PERFORM_ACTION = REF_SERVER + "user/follow"

let REF_USER_MY_PURCHASES = REF_SERVER + "user/myPurchases"
let REF_USER_Other_PURCHASES = REF_SERVER + "purchase/get"
let REF_USER_MY_POSTS = REF_SERVER + "user/myPosts"
let REF_USER_VIEWED = REF_SERVER + "user/getViewedPosts"
let REF_USER_LIKED = REF_SERVER + "user/getLikedPosts"

let REF_VARIANT_EDITADD = REF_SERVER + "variant/custom/add"

let REF_USER_RECENT_LIVE_SELLERS = REF_SERVER + "user/recentLiveSellers"

let REF_CATEGORY_GET = REF_SERVER + "category/get"
let REF_SUBCATEGORY_GET = REF_SERVER + "subCategory/get"

let REF_POST_UPDATE = REF_SERVER + "post/update"
let REF_POST_ADD = REF_SERVER + "post/add"
let REF_POST_GET_ALL = REF_SERVER + "post/getAll"
let REF_POST_DELETE = REF_SERVER + "post/delete"
let REF_POST_LIKE = REF_SERVER + "post/like"
let REF_POST_DISLIKE = REF_SERVER + "post/dislike"
let REF_POST_DETAILS = REF_SERVER + "post/getpostdetails"

let REF_POST_REPORT = REF_SERVER + "post/report"

let REF_POST_ADD_COMMENT = REF_SERVER + "post/addComment"
let REF_POST_DELETE_COMMENT = REF_SERVER + "post/deleteComment"
let REF_POST_GET_COMMENT = REF_SERVER + "post/getComments"
let REF_POST_LIKE_COMMENT = REF_SERVER + "post/likeComment"
let REF_POST_DISLIKE_COMMENT = REF_SERVER + "post/dislikeComment"

let REF_BIDDING_MYBIDDING = REF_SERVER + "user/myBiddings"

let REF_CART_GET = REF_SERVER + "cart/get"
let REF_CART_ADD = REF_SERVER + "cart/add"
let REF_CART_DELETE = REF_SERVER + "cart/delete"
let REF_CART_CHECKOUT = REF_SERVER + "cart/checkout"

let REF_COUPON_VERIFY = REF_SERVER + "coupon/verify"

let REF_SELLER_REGISTER = REF_SERVER + "seller/register"
let REF_SELLER_UPDATE = REF_SERVER + "seller/update"

let REF_MEDIA_ADD = REF_SERVER + "media/add"
let REF_MEDIA_GET = REF_SERVER + "media/get"

let REF_CONFIG_GET_ATTRIBUTES = REF_SERVER + "config/getAttributes"
let REF_CONFIG_GET_TIMESLOTS = REF_SERVER + "config/getTimeSlots"

let REF_PURCHASE_ADD = REF_SERVER + "purchase/add"

let REF_MY_ORDERS = REF_SERVER + "order/myOrders"

let REF_ADDRESS_LIST = REF_SERVER + "address/list"
let REF_ADDRESS_EDIT = REF_SERVER + "address/edit"
let REF_ADDRESS_ADD = REF_SERVER + "address/add"
let REF_ADDRESS_DELETE = REF_SERVER + "address/delete"

let WSCityList = REF_SERVER + "city/list"
let WSStateList = REF_SERVER + "state/list"
let WSForDirectBuy = REF_SERVER + "cart/directBuy"
let WSForGetAllTransaction = REF_SERVER + "order/sellerOrderDashboard"
let WSNotificationList = REF_SERVER + "notification/getAll"
let REF_ACCOUNT_Verification = REF_SERVER + "user/requestVerification"
let REF_POST_ACTIVE_STATUS = REF_SERVER + "post/active"

let REF_VARIANT_ADD = REF_SERVER + "variant/add"
let REF_VARIANT_UPDATE = REF_SERVER + "variant/update"
let REF_VARIANT_DELETE = REF_SERVER + "variant/delete"

let REF_GET_PAYMENTMETHOD = REF_SERVER + "purchase/getPaymentMethods"

let REF_GET_SUCCESS = REF_SERVER + "purchase/success-callback"
let REF_GET_FAILED = REF_SERVER + "purchase/failed-callback"

let REF_ADD_SUB_CATEGORY = REF_SERVER + "subCategory/add"
let REF_GET_SUB_CATEGORY = REF_SERVER + "subCategory/list"

let DEACTIVATE_USER = REF_SERVER + "user/deactivateAccount"
let Interest_Get = REF_SERVER + "interest/get"

let Cart_Apple_Pay = REF_SERVER + "cart/buy"








enum UserActionType: String, CaseIterable {
    case follow = "follow"
    case unfollow = "unfollow"
    case accept = "accept"
    case reject = "reject"
}

enum UserRequestListType: String, CaseIterable {
    case requested = "requested"
    case recieved = "recieved"
}

enum PostBaseType: String, CaseIterable {
    case normalSelling = "normalSelling"
    case normalBidding = "normalBidding"
    case liveBidding = "liveBidding"
}

enum PostPurchaseType: String {
    case normalBidding = "normalBidding"
    case postRegistrationPrice = "biddingPostRegistrationPrice"
    case normalSelling = "normalSelling"
}

enum MyBiddingType: String {
    case ongoing = "ongoing"
    case won = "won"
    case lost = "lost"
}

class Service {
    static let shared = Service()
    
    func  registerUser(fullname: String, username: String, email: String, password: String, phone: String, about:String, imageId:String, completion: @escaping(Bool, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        var reqBody = ["email": email, "userName": username, "password": password, "mobileNumber": phone, "firstName": fullname] as [String: Any]
        
        reqBody["deviceID"] = Utility.getDeviceId()
        reqBody["deviceName"] = Utility.getDeviceId()
        reqBody["deviceToken"] = appDele?.fcm_Token
        reqBody["deviceType"] = "ios"
        
        reqBody["about"] = about
        if imageId != "" {
            reqBody["image"] = imageId
        }
        
        var request = URLRequest(url: URL(string: REF_REGISTER_USER)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as! [String: Any]
            print(jsonData)
            let status = jsonData["status"] as? Bool ?? false
            
            if status {
                let user = User(dictionary: jsonData)
                let encodeStatus = AppUser.shared.setDefaultUser(user: user)
                self.verifyEmail(withAuth: user.auth)
                completion(encodeStatus, nil)
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(status, message)
            }
        }
    }
    
    func directBuy(postId: String, variantId: String, quantity: String, delivery_notes: String, deliveryAddressId: String, AddressId:String, deliveryTimeSlot:String, deliveryCharge:String, couponCode:String, couponAmount:String, paymentType:String, paymentMethod:CartCheckoutPaymentMethodTypes?, amount:String ,paymendId:String, isHidden: Bool, completion: @escaping(Bool, CartPurchaseBlock?, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        var reqBody = [:] as [String: Any]
        reqBody["postId"] = postId
        if variantId != "" {
            reqBody["variantId"] = variantId
        }
        reqBody["quantity"] = quantity
        reqBody["delivery_notes"] = delivery_notes
        reqBody["deliveryAddressId"] = deliveryAddressId
        reqBody["AddressId"] = AddressId
        reqBody["deliveryTimeSlot"] = deliveryTimeSlot
        reqBody["deliveryCharge"] = deliveryCharge
        reqBody["couponCode"] = couponCode
        reqBody["couponAmount"] = couponAmount
        reqBody["paymentType"] = "online"
        reqBody["paymentMethodId"] = paymentMethod == .knet ? 1 : 2
        reqBody["hidden"] = isHidden
        
        if paymentMethod != nil {
            if paymentMethod == .wallet {
                reqBody["walletAmount"] = amount
                reqBody["paymentType"] = "wallet"
            }
        }
        
        
        var request = URLRequest(url: URL(string: WSForDirectBuy)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            let status = jsonData["status"] as? Bool ?? false
            if status {
                let purchaseDataDict = jsonData["Purchase"] as! [String: Any]
                let purchaseData = CartPurchaseBlock(dict: purchaseDataDict)
                completion(status, purchaseData, nil)
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(status, nil, message)
            }
        }
    }

    func directBuyForApplePay(paymentSuccess: Bool, deliveryCharge:String, paymentType:String = "applepay", couponCode:String, couponAmount:String, paymentMethodId: String = "3", isHidden: Bool, amount:String, deliveryTimeSlot:String, deliveryAddressId: String, delivery_notes: String, completion: @escaping(Bool, CartPurchaseBlock?, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        var reqBody = [:] as [String: Any]
        reqBody["paymentSuccess"] = paymentSuccess
        reqBody["deliveryCharge"] = deliveryCharge
        reqBody["paymentType"] = paymentType
        reqBody["couponCode"] = couponCode
        reqBody["couponAmount"] = couponAmount
        reqBody["paymentMethodId"] = 3
        reqBody["hidden"] = isHidden
        reqBody["walletAmount"] = 0
        reqBody["deliveryTimeSlot"] = deliveryTimeSlot
        reqBody["deliveryAddressId"] = deliveryAddressId
        reqBody["delivery_notes"] = delivery_notes
        reqBody["AddressId"] = deliveryAddressId
        
        var request = URLRequest(url: URL(string: Cart_Apple_Pay)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            print(jsonData)
            let status = jsonData["status"] as? Bool ?? false
            if status {
                let purchaseDataDict = jsonData["Purchase"] as! [String: Any]
                let purchaseData = CartPurchaseBlock(dict: purchaseDataDict)
                completion(status, purchaseData, nil)
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(status, nil, message)
            }
        }
    }

    
    func  forgorPassword(email: String, completion: @escaping(Bool, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        let reqBody = ["email": email] as [String: Any]
        
        var request = URLRequest(url: URL(string: REF_FORGOT_PASSWORD)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        print(request.url?.absoluteString)
        print(reqBody)
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as! [String: Any]
            print(jsonData)
            print(jsonData)
            let status = jsonData["status"] as? Bool ?? false
            
            if status {
                let user = User(dictionary: jsonData)
                let encodeStatus = AppUser.shared.setDefaultUser(user: user)
                completion(encodeStatus, nil)
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(status, message)
            }
        }
    }
    
    
    
    func  loginUser(email: String, password: String, completion: @escaping(Bool, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }
        
        var reqBody = ["email": email, "password": password] as [String: Any]
        
        reqBody["deviceID"] = Utility.getDeviceId()
        reqBody["deviceName"] = Utility.getDeviceId()
        reqBody["deviceToken"] = appDele?.fcm_Token
        reqBody["deviceType"] = "ios"
        
        
        var request = URLRequest(url: URL(string: REF_LOGIN_USER)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as! [String: Any]
            print(jsonData)
            print(jsonData)
            let status = jsonData["status"] as? Bool ?? false
            
            if status {
                let user = User(dictionary: jsonData)
                let encodeStatus = AppUser.shared.setDefaultUser(user: user)
                completion(encodeStatus, nil)
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(status, message)
            }
        }
    }
    
    func verifyEmail(withAuth auth: String) {
        
        var request = URLRequest(url: URL(string: REF_VERIFY_EMAIL)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(auth, forHTTPHeaderField: "Authorization")
        
        AF.request(request).responseJSON { _ in
            
        }
    }
    
    // FIXME: - working but not used!
    func updateUserName(username: String, completion: @escaping(User?, Bool, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        let reqBody = ["userName": username] as [String: Any]
        
        var request = URLRequest(url: URL(string: REF_UPDATE_USER)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as! [String: Any]
            print(jsonData)
            
            let status = jsonData["status"] as? Bool ?? false
            
            if status {
                let user = User(dictionary: jsonData)
                completion(user, status, nil)
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(nil, status, message)
            }
        }
    }
    
    
    // FIXME: - working but not used!
    func getPaymentMethod(completion: @escaping([PaymentMethodObject]?, Bool, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        var request = URLRequest(url: URL(string: REF_GET_PAYMENTMETHOD)!)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        print(request.url?.absoluteString)
        
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as! [String: Any]
            print(jsonData)
            
            let status = jsonData["status"] as? Bool ?? false
            
            if status {
                var arrFinal : [PaymentMethodObject] = []
                if let arr = jsonData["data"] as? [[String:Any]] {
                    for item in arr {
                        arrFinal.append(PaymentMethodObject(dict: item))
                    }
                }
                completion(arrFinal, status, nil)
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(nil, status, message)
            }
        }
    }
    
    
    
    // FIXME: - working but not used!
    func updateUserDetails(username: String, name:String, mobile:String, countryCode:String, about:String, imageId:String, completion: @escaping(User?, Bool, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        var reqBody : [String: Any] =  [:]
        
        reqBody["userName"] = username
        reqBody["firstName"] = name
        reqBody["mobileNumber"] = mobile
        reqBody["countryCode"] = countryCode
        reqBody["about"] = about
        if imageId != "" {
            reqBody["image"] = imageId
        }
        
        var request = URLRequest(url: URL(string: REF_UPDATE_USER)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as! [String: Any]
            print(jsonData)
            
            let status = jsonData["status"] as? Bool ?? false
            
            if status {
                let user = User(dictionary: jsonData)
                completion(user, status, nil)
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(nil, status, message)
            }
        }
    }
    
    // FIXME: - working but not used!
    func changeUserPassword(currentPassword: String, newPassword: String, completion: @escaping(Bool?, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }
        let reqBody = ["oldPassword": currentPassword, "newPassword": newPassword] as [String: Any]
        var request = URLRequest(url: URL(string: REF_CHANGE_PASSWORD)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        print(request.url?.absoluteString)
        print(reqBody)
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as! [String: Any]
            print(jsonData)
            
            let status = jsonData["status"] as? Bool ?? false
            
            if status {
                completion(true, nil)
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(false, message)
            }
        }
    }

    func makeMyPurchaseHidden(setHidden isHidden: Bool, completion: @escaping(Bool) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        let reqBody = ["hidden": isHidden ? true : false] as [String: Any]
        var request = URLRequest(url: URL(string: RED_USER_HIDDEN_PURCHASE)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        print(request.url?.absoluteString)
        print(reqBody)
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            print(jsonData)
            let status = jsonData["status"] as? Bool ?? false
            completion(status)
        }
    }
    
    
    func makeSinglePurchaseHidden(setHidden isHidden: Bool, purchaseId:String, completion: @escaping(Bool) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        let reqBody = ["hidden": isHidden ? "1" : "0", "purchaseId" : purchaseId] as [String: Any]
        var request = URLRequest(url: URL(string: REF_HIDE_PURCHASE)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        print(request.url?.absoluteString)
        print(reqBody)
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            print(jsonData)
            let status = jsonData["status"] as? Bool ?? false
            completion(status)
        }
    }
    
    
    
    func setUserPublic(setPublic isPublic: Bool, completion: @escaping(Bool) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        let reqBody = ["status": isPublic] as [String: Any]
        
        var request = URLRequest(url: URL(string: RED_USER_SET_PUBLIC)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            
            let status = jsonData["status"] as? Bool ?? false
            
            completion(status)
        }
    }
    
    // FIXME: - working but not used!
    func registerSeller(info: RegisterSellerInfo, licenseImage: UIImage?, completion: @escaping(Bool, String) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        if let licenseImage = licenseImage {
            self.uploadSingleImage(image: licenseImage) { status, itemMedias, message in
                if status {
                    guard let licenseMedia = itemMedias?.first else { return }
                    
                    let reqBody = ["shopName": info.shopName, "type": info.type.rawValue, "address": info.address, "aboutBusiness": info.aboutBusiness, "bankName": info.bankName, "IBAN": info.IBAN, "licence": licenseMedia.id, "civilId": info.civilId] as [String: Any]
                    
                    var request = URLRequest(url: URL(string: REF_SELLER_REGISTER)!)
                    request.httpMethod = HTTPMethod.post.rawValue
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
                    
                    let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
                    request.httpBody = jsonBody
                    
                    print(request.url?.absoluteString)
                    print(reqBody)
                    
                    
                    AF.request(request).responseJSON { (response) in
                        let jsonData = response.value as! [String: Any]
                        print(jsonData)
                        
                        let status = jsonData["status"] as? Bool ?? false
                        let message = jsonData["message"] as? String ?? ""
                        
                        completion(status, message)
                    }
                } else {
                    guard let message = message else { return }
                    completion(status, message)
                }
            }
        } else {
            let reqBody = ["shopName": info.shopName, "type": info.type.rawValue, "address": info.address, "aboutBusiness": info.aboutBusiness, "bankName": info.bankName, "IBAN": info.IBAN, "civilId": info.civilId] as [String: Any]
            
            var request = URLRequest(url: URL(string: REF_SELLER_REGISTER)!)
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
            
            let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
            request.httpBody = jsonBody
            
            print(request.url?.absoluteString)
            print(reqBody)
            
            
            AF.request(request).responseJSON { (response) in
                let jsonData = response.value as! [String: Any]
                print(jsonData)
                
                let status = jsonData["status"] as? Bool ?? false
                let message = jsonData["message"] as? String ?? ""
                
                completion(status, message)
            }
        }
    }
    
    // FIXME: - working but not used!
    func updateRegisteredSeller(info: RegisterSellerInfo, completion: @escaping(Bool, String) -> Void) {
        let reqBody = ["shopName": info.shopName, "type": info.type.rawValue, "address": info.address, "aboutBusiness": info.aboutBusiness, "bankName": info.bankName, "IBAN": info.IBAN] as [String: Any]
        
        var request = URLRequest(url: URL(string: REF_SELLER_UPDATE)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as! [String: Any]
            print(jsonData)
            
            let status = jsonData["status"] as? Bool ?? false
            let message = jsonData["message"] as? String ?? ""
            
            completion(status, message)
        }
    }
    
    func getUserData(forUserId id: String, completion: @escaping(User?, Bool, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        let reqBody = ["userId": id] as [String: Any]
        
        var request = URLRequest(url: URL(string: REF_USER_GET_ONE)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as! [String: Any]
            print(jsonData)
            
            let status = jsonData["status"] as? Bool ?? false
            
            if status {
                let user = User(dictionary: jsonData)
                completion(user, status, nil)
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(nil, status, message)
            }
        }
    }
    
    func getFollowList(forUser user: User, type: UserProfileStatsCellTypes, count: Int = 1000, startRange: Int = 0, completion: @escaping([User]?, Bool, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        let reqBody = ["userId": user.id, "type": type.text.lowercased(), "startRange": startRange, "count": count] as [String: Any]
        
        var request = URLRequest(url: URL(string: REF_USER_FOLLOW_LIST)!)
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        print(request.url?.absoluteString)
        print(reqBody)
        
        AF.request(request).responseJSON { (response) in
            if let jsonData = response.value as? [String: Any] {
                print(jsonData)
                let status = jsonData["status"] as? Bool ?? false
                
                if status {
                    let allUsersData = jsonData["data"] as! [[String: Any]]
                    
                    var allUsers = [User]()
                    
                    for userData in allUsersData {
                        let user = User(dictionary: userData)
                        allUsers.append(user)
                    }
                    
                    completion(allUsers, status, nil)
                } else {
                    let message = jsonData["message"] as? String ?? ""
                    completion(nil, status, message)
                }
            }
        }
    }
    
    func getRequestedList(ofType type: UserRequestListType, count: Int = 1000, startRange: Int = 0, completion: @escaping([User]?, Bool, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        let reqBody = ["type": type.rawValue, "startRange": startRange, "count": count] as [String: Any]
        
        var request = URLRequest(url: URL(string: REF_USER_REQUEST_LIST)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as? [String: Any]
            print(jsonData)
            
            let status = jsonData?["status"] as? Bool ?? false
            
            if status {
                let allUsersData = jsonData?["data"] as! [[String: Any]]
                
                var allUsers = [User]()
                
                for userData in allUsersData {
                    let user = User(dictionary: userData)
                    allUsers.append(user)
                }
                
                completion(allUsers, status, nil)
            } else {
                let message = jsonData?["message"] as? String ?? ""
                completion(nil, status, message)
            }
        }
    }
    
    func getAllUsers(byKeyword keyword: String = "", count: Int = 1000, startRange: Int = 0, completion: @escaping([User]?, Bool, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        let reqBody = ["startRange": startRange, "count": count, "keyword": keyword] as [String: Any]
        
        var request = URLRequest(url: URL(string: REF_USER_GET_ALL)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as! [String: Any]
            
            let status = jsonData["status"] as? Bool ?? false
            print(response)
            if status {
                let allUsersData = jsonData["data"] as! [[String: Any]]
                
                var allUsers = [User]()
                
                for userData in allUsersData {
                    let user = User(dictionary: userData)
                    allUsers.append(user)
                }
                
                completion(allUsers, status, nil)
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(nil, status, message)
            }
        }
    }
    
    func getAllPosts(byKeyword keyword: String = "", count: Int = 10000, startRange: Int = 0, userId: String = "", isHighLow: Bool?,  completion: @escaping([PostItem]?, Bool, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        var reqBody = ["type": "Fixed", "startRange": startRange, "count": count, "keyword": keyword] as [String: Any]
        
        if userId != "" {
            reqBody["userId"] = userId
        } else {
            reqBody["all"] = true
        }
        
        if let b = isHighLow {
            reqBody["priceSort"] = b ? "ascending" : "descending"
        }

        
        var request = URLRequest(url: URL(string: REF_POST_GET_ALL)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")

         let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        
        AF.request(request).responseJSON { (response) in
            if let jsonData = response.value as? [String: Any] {
                print(jsonData)
                let status = jsonData["status"] as? Bool ?? false
                if status {
                    let allPostsData = jsonData["data"] as! [[String: Any]]
                    var allPosts = [PostItem]()
                    for postData in allPostsData {
                        let post = PostItem(dict: postData)
                        allPosts.append(post)
                    }
                    completion(allPosts, status, nil)
                } else {
                    let message = jsonData["message"] as? String ?? ""
                    completion(nil, status, message)
                }
            } else {
                completion(nil, false, "")
            }
        }
    }
    
    func getAllCategories(isPurchaseItem: Bool = false, isMyProduct:Bool = false, completion: @escaping([ItemCategory]?, Bool, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        var request = URLRequest(url: URL(string: REF_CATEGORY_GET)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        if isPurchaseItem == true {
            let reqBody = ["isPurchasedProduct": true, "userId": AppUser.shared.getDefaultUser()?.id ?? ""] as [String: Any]
            let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
            request.httpBody = jsonBody
            print(jsonBody)
            
        } else if isMyProduct == true {
            let reqBody = ["isProductAvailable": true, "userId": AppUser.shared.getDefaultUser()?.id ?? ""] as [String: Any]
            let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
            request.httpBody = jsonBody
            print(jsonBody)
            
        }
        
        print(request.url?.absoluteString)
        
        AF.request(request).responseJSON { (response) in
            guard let jsonData = response.value as? [String: Any] else {
                return
            }
            print(jsonData)
            let status = jsonData["status"] as? Bool ?? false
            
            if status {
                let allCategoryData = jsonData["data"] as! [[String: Any]]
                var allCategories = [ItemCategory]()
                
                for categoryData in allCategoryData {
                    let category = ItemCategory(dict: categoryData)
                    allCategories.append(category)
                }
                
                completion(allCategories, status, nil)
            } else {
                let message = jsonData["data"] as? String ?? ""
                completion(nil, status, message)
            }
        }
    }
    
    func getAllSubCategories(isPurchaseItem: Bool = false, isMyProduct:Bool = false, userId:String, completion: @escaping([ItemSubCategory]?, Bool, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        var request = URLRequest(url: URL(string: REF_SUBCATEGORY_GET)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        if isPurchaseItem == true {
            let reqBody = ["isPurchasedProduct": true, "sellerId": userId.count > 0 ? userId : AppUser.shared.getDefaultUser()?.id ?? ""] as [String: Any]
            let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
            request.httpBody = jsonBody
            print(jsonBody)
            
        } else if isMyProduct == true {
            let reqBody = ["isProductAvailable": true, "sellerId": userId.count > 0 ? userId : AppUser.shared.getDefaultUser()?.id ?? ""] as [String: Any]
            let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
            request.httpBody = jsonBody
            print(jsonBody)
            
        }
        
        print(request.url?.absoluteString)
        
        AF.request(request).responseJSON { (response) in
            guard let jsonData = response.value as? [String: Any] else {
                return
            }
            print(jsonData)
            let status = jsonData["status"] as? Bool ?? false
            
            if status {
                let allCategoryData = jsonData["data"] as! [[String: Any]]
                var allCategories = [ItemSubCategory]()
                
                for categoryData in allCategoryData {
                    let category = ItemSubCategory(dict: categoryData)
                    allCategories.append(category)
                }
                
                completion(allCategories, status, nil)
            } else {
                let message = jsonData["data"] as? String ?? ""
                completion(nil, status, message)
            }
        }
    }
    
    func uploadMultipleImages(allImages: [UIImage], completion: @escaping(Bool, [ItemMedia]?, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        let totalNumberOfImages = allImages.count
        
        var allMediaObjects = [ItemMedia]()
        
        for index in 0 ..< totalNumberOfImages {
            Service.shared.uploadSingleImage(image: allImages[index]) { status, itemMedia, message in
                if status {
                    guard let itemMedia = itemMedia?.first else { return }
                    allMediaObjects.append(itemMedia)
                    
                    if allMediaObjects.count == totalNumberOfImages {
                        completion(status, allMediaObjects, nil)
                    }
                } else {
                    guard let message = message else { return }
                    completion(status, nil, message)
                }
            }
        }
    }
    
    func uploadSingleImage(image: UIImage, completion: @escaping(Bool, [ItemMedia]?, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataContent: Data, boundary: String) -> Data? {
            var theBody = Data();
            if parameters != nil {
                for (key, value) in parameters! {
                    
                    theBody.append("--\(boundary)\r\n".data(using: .utf8, allowLossyConversion: false)!)
                    theBody.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8, allowLossyConversion: false)!)
                    theBody.append("\(value)\r\n".data(using: .utf8, allowLossyConversion: false)!)
                }
            }
            
            let filename = "nameString.jpg"
            
            let mimetype = "image/jpg".data(using: .utf8, allowLossyConversion: false)!
            theBody.append("--\(boundary)\r\n".data(using: .utf8, allowLossyConversion: false)!)
            theBody.append("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n".data(using: .utf8, allowLossyConversion: false)!)
            theBody.append("Content-Type: \(mimetype)\r\n\r\n".data(using: .utf8, allowLossyConversion: false)!)
            theBody.append(imageDataContent)
            theBody.append("\r\n".data(using: .utf8, allowLossyConversion: false)!)
            theBody.append("--\(boundary)--\r\n".data(using: .utf8, allowLossyConversion: false)!)
            
            return theBody
        }
        
        
        let myUrl = URL(string: REF_MEDIA_ADD)!
        var request = URLRequest(url:myUrl)
        request.httpMethod = "POST"
        
        let boundaryString = "Boundary--\(NSUUID().uuidString)"
        let contentType : String? = "multipart/form-data; boundary=\(boundaryString)"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        let imageData = image.jpegData(compressionQuality: 0.8)!
        
        request.httpBody = createBodyWithParameters(parameters: nil, filePathKey: "media", imageDataContent: imageData, boundary: boundaryString)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                guard let error = error else { return }
                completion(false, nil, error.localizedDescription)
                return
            }
            
            
            if let jsonData = try? JSONSerialization.jsonObject(with: data!, options: []) {
                guard let jsonData = jsonData as? [String: Any] else { return }
                let status = jsonData["status"] as? Bool ?? false
                
                if status {
                    let allMediaData = jsonData["data"] as! [[String: Any]]
                    var allMedias = [ItemMedia]()
                    
                    for mediaData in allMediaData {
                        let Media = ItemMedia(dict: mediaData)
                        allMedias.append(Media)
                    }
                    
                    completion(status, allMedias, nil)
                } else {
                    let message = jsonData["message"] as? String ?? ""
                    completion(status, nil, message)
                }
            }
        }
        task.resume()
        
    }
    
    // FIXME: - working but not used!
    func getMedia(forMediaId id: String, count: Int = 1000, startRange: Int = 0, completion: @escaping(Bool, [ItemMedia]?, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        let reqBody = ["startRange": startRange, "count": count, "mediaId": id] as [String: Any]
        
        var request = URLRequest(url: URL(string: REF_MEDIA_GET)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as! [String: Any]
            print(jsonData)
            let status = jsonData["status"] as? Bool ?? false
            
            if status {
                let allMediaData = jsonData["data"] as! [[String: Any]]
                var allMedias = [ItemMedia]()
                
                for mediaData in allMediaData {
                    let Media = ItemMedia(dict: mediaData)
                    allMedias.append(Media)
                }
                
                completion(status, allMedias, nil)
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(status, nil, message)
            }
        }
    }

    // FIXME: - working but not used!
    func updatePostDetails(forPost id: String, about: String, location: String, cateId:String, subCateId:String, quantity:Int, title:String, titleAr:String, price:Double, media:[String], completion: @escaping(Bool, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        
        let reqBody = ["postId": id,
                       "about": about,
                       "location": location,
                       "categoryId": cateId,
                       "subCategoryId": subCateId,
                       "quantity": quantity,
                       "title": title,
                       "title_ar": titleAr,
                       "price": price,
                       "media": media,
                       "taggedUsers": []] as [String: Any]
        
        var request = URLRequest(url: URL(string: REF_POST_UPDATE)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as! [String: Any]
            print(jsonData)
            let status = jsonData["status"] as? Bool ?? false
            if status {
                completion(true, nil)
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(status, message)
            }
        }
    }

    
    
    func uploadPost(ofType postType: PostBaseType, allImages: [UIImage], category: ItemCategory, title: String, details: String, detailAr: String, price: Double, quantity: Int, variants: [CreateItemVariant], arrVariant:[VariantObject] = [], itemSub : ItemSubCategory?, titleAr:String, completion: @escaping(Bool, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        uploadMultipleImages(allImages: allImages) { status, itemMedias, message in
            if status {
                guard let itemMedias = itemMedias else { return }
                
                var params: Parameters = ["type": "Fixed", "about": details, "location": detailAr, "categoryId": category.id, "title": title, "postBaseType": postType.rawValue, "price": price, "quantity": quantity, "subCategoryId": itemSub?.id ?? "", "title_ar": titleAr]
                
                
                var allItemVariantsDict = [[String: Any]]()
                
                variants.forEach { variant in
                    var itemVariantDict = [String: Any]()
                    itemVariantDict["price"] = variant.getPrice()
                    itemVariantDict["quantity"] = variant.getQuantity()
                    
                    guard let variantOne = variant.getVariantOne()?.selectedOption else { return }
                    guard let variantTwo = variant.getVariantTwo()?.selectedOption else { return }
                    
                    var attributes = [[String: Any]]()
                    
                    let firstAttribute: [String: Any] = ["attributeId": variantOne.parentAttributeId, "attributeOptionId": variantOne.id]
                    let secondAttribute: [String: Any] = ["attributeId": variantTwo.parentAttributeId, "attributeOptionId": variantTwo.id]
                    
                    attributes.append(firstAttribute)
                    attributes.append(secondAttribute)
                    
                    itemVariantDict["attributes"] = attributes
                    
                    allItemVariantsDict.append(itemVariantDict)
                }
                
                params["variants"] = allItemVariantsDict
                
                var allVariants = [[String: Any]]()

                arrVariant.forEach { variant in
                    var itemVariantDict = [String: Any]()
                    itemVariantDict["price"] = variant.strPrice
                    itemVariantDict["quantity"] = variant.strQuantity
                    
                    
                    var allAtt = [[String: Any]]()

                    var dictData1 = [String: Any]()
                    dictData1["nameEn"] = variant.strV1Eng
                    dictData1["nameAr"] = variant.strV1Ar
                    allAtt.append(dictData1)

                    if variant.strV2Eng != "" {
                        var dictData2 = [String: Any]()
                        dictData2["nameEn"] = variant.strV2Eng
                        dictData2["nameAr"] = variant.strV2Ar
                        allAtt.append(dictData2)
                    }
                    itemVariantDict["attributes"] = allAtt
                    
                    allVariants.append(itemVariantDict)
                }
                
                params["variants"] = allVariants

                var allMedia = [String]()
                for index in 0 ..< itemMedias.count {
                    let media = itemMedias[index]
                    allMedia.append(media.id)
                }
                params["media"] = allMedia
                
                print(REF_POST_ADD)
                print(params)
                
                var request = URLRequest(url: URL(string: REF_POST_ADD)!)
                request.httpMethod = HTTPMethod.post.rawValue
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
                
                let data = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                
                let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                request.httpBody = json!.data(using: String.Encoding.utf8.rawValue);
                
                
                AF.request(request).responseJSON { (response) in
                    let jsonData = response.value as! [String: Any]
                    print(jsonData)
                    
                    let status = jsonData["status"] as? Bool ?? false
                    let message = jsonData["message"] as? String ?? ""
                    completion(status, message)
                }
            } else {
                guard let message = message else { return }
                completion(status, "An error occoured while uploading images: \(message)")
            }
        }
        
    }
    
    func uploadAuction(ofType postType: PostBaseType, allImages: [UIImage], category: ItemCategory, title: String, details: String, initialPrice: Double, startDate: Date, duration:Int, itemSub : ItemSubCategory?, titleAr:String, completion: @escaping(Bool, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        uploadMultipleImages(allImages: allImages) { status, itemMedias, message in
            if status {
                guard let itemMedias = itemMedias else { return }
                
                var params: Parameters = ["type": "Auction", "about": details, "location": "HARDCODED-DATA", "categoryId": category.id, "title": title, "postBaseType": postType.rawValue, "startBiddingPrice": initialPrice, "duration" : duration, "startDate" : startDate.timeIntervalSince1970 * 1000, "subCategoryId": itemSub?.id ?? "", "title_ar": titleAr] as [String: Any]
                
                var allMedia = [String]()
                for index in 0 ..< itemMedias.count {
                    let media = itemMedias[index]
                    allMedia.append(media.id)
                }
                params["media"] = allMedia
                
                print(REF_POST_ADD)
                print(params)
                
                var request = URLRequest(url: URL(string: REF_POST_ADD)!)
                
                print(request.urlRequest?.url?.absoluteString)
                print(params)
                
                request.httpMethod = HTTPMethod.post.rawValue
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
                
                let data = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                
                let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                request.httpBody = json!.data(using: String.Encoding.utf8.rawValue);
                
                
                AF.request(request).responseJSON { (response) in
                    let jsonData = response.value as! [String: Any]
                    print(jsonData)
                    
                    let status = jsonData["status"] as? Bool ?? false
                    let message = jsonData["message"] as? String ?? ""
                    completion(status, message)
                }
            } else {
                guard let message = message else { return }
                completion(status, "An error occoured while uploading images: \(message)")
            }
        }
    }
    
    func getALlSellerTransaction(completion: @escaping(SellerStatastics?, Bool, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        var request = URLRequest(url: URL(string: WSForGetAllTransaction)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        print(request.url?.absoluteString)
        AF.request(request).responseJSON { response in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            let status = jsonData["success"] as? Bool ?? false
            print(jsonData)
            if status {
                let allAttributesData = jsonData["data"] as! [String: Any]
                let attribute = SellerStatastics(dict: allAttributesData)
                completion(attribute, status, nil)
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(nil, status, message)
            }
        }
    }
    
    func getAllNotification(count: Int = 1000, startRange: Int = 0, completion: @escaping([GeneralNotification]?, Bool, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        let reqBody = ["startRange": "\(startRange)", "count": "\(count)", "xPast": "1000"] as [String: Any]
        
        var request = URLRequest(url: URL(string: WSNotificationList)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            let status = jsonData["status"] as? Bool ?? false
            print(jsonData)
            if status {
                let allPostData = jsonData["data"] as! [[String: Any]]
                var allPosts = [GeneralNotification]()
                for postData in allPostData {
                    let post = GeneralNotification(dict: postData)
                    allPosts.append(post)
                }
                completion(allPosts, status, nil)
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(nil, status, message)
            }
        }
    }
    
    
    
    
    func fetchAllAttributes(completion: @escaping([ItemAttribute]?, Bool, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        var request = URLRequest(url: URL(string: REF_CONFIG_GET_ATTRIBUTES)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        AF.request(request).responseJSON { response in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            let status = jsonData["status"] as? Bool ?? false
            
            if status {
                let allAttributesData = jsonData["data"] as! [[String: Any]]
                var allAttributes = [ItemAttribute]()
                
                for attributeData in allAttributesData {
                    let attribute = ItemAttribute(dict: attributeData)
                    allAttributes.append(attribute)
                }
                
                completion(allAttributes, status, nil)
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(nil, status, message)
            }
        }
    }
    
    func fetchAllPost(postId: String = "", userId: String = "", count: Int = 5000, startRange: Int = 0, isEngaged: Bool = false, type:String = "", cID:String = "",isRandom: Bool = true , completion: @escaping([PostItem]?, Bool, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        //        var reqBody = ["type": "Fixed", "all": false, "startRange": startRange, "count": count, "postId": postId, "userId": userId] as [String: Any]
        var reqBody = ["startRange": startRange, "count": count, "postId": postId, "userId": userId] as [String: Any]
        
        if isEngaged {
            reqBody["orderBy"] = "engagement"
        }
        
        if type != "" {
            reqBody["postBaseType"] = type
        }
        
        if cID != "" {
            reqBody["subCategoryId"] = cID
        }

        if isRandom == false {
            reqBody["randomise"] = false
        } else {
            reqBody["randomise"] = true
        }

        var request = URLRequest(url: URL(string: REF_POST_GET_ALL)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        print(loggedInUser?.auth ?? "")
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        
        
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            let status = jsonData["status"] as? Bool ?? false
            
            print(jsonData)
            
            if status {
                let allPostData = jsonData["data"] as! [[String: Any]]
                var allPosts = [PostItem]()
                
                for postData in allPostData {
                    let post = PostItem(dict: postData)
                    allPosts.append(post)
                }
                
                completion(allPosts, status, nil)
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(nil, status, message)
            }
        }
    }
    
    func fetchSinglePost(forPostId postId: String, userId: String = "", completion: @escaping(PostItem?, Bool, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        var reqBody = ["startRange": 0, "count": 50, "postId": postId] as [String: Any]
        
        if userId != "" {
            reqBody["userId"] = userId
        }
        var request = URLRequest(url: URL(string: REF_POST_GET_ALL)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        
        
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            let status = jsonData["status"] as? Bool ?? false
            
            print(jsonData)
            
            if status {
                let allPostData = jsonData["data"] as! [[String: Any]]
                guard let postData = allPostData.first else {
                    completion(nil, false, "No Data Found")
                    return
                }
                let post = PostItem(dict: postData)
                completion(post, status, nil)
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(nil, status, message)
            }
        }
    }
    
    func updatePostActiveStatus(forPostId postId: String, status: Bool, completion: @escaping(Bool, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        let reqBody = ["active": "\(status)", "postId": postId] as [String: Any]
        var request = URLRequest(url: URL(string: REF_POST_ACTIVE_STATUS)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        print(request.url?.absoluteString)
        print(reqBody)
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            let status = jsonData["status"] as? Bool ?? false
            print(jsonData)
            if status {
                completion(true, "")
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(status, message)
            }
        }
    }
    
    func deletePost(forPostId postId: String, completion: @escaping(Bool, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        let reqBody = ["postId": postId] as [String: Any]
        var request = URLRequest(url: URL(string: REF_POST_DELETE)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        print(request.url?.absoluteString)
        print(reqBody)
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            let status = jsonData["status"] as? Bool ?? false
            print(jsonData)
            if status {
                completion(true, "")
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(status, message)
            }
        }
    }
    
    
    func fetchAllExplorePosts(all: Bool, isEngaged: Bool, count: Int = 20, startRange: Int = 0, categoryId:String = "", isPriceLowTohigh:Bool = true, isPriceSortNeeded:Bool = false , completion: @escaping([PostItem]?, Bool, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        var reqBody = ["all": all, "startRange": startRange, "count": count] as [String: Any]
        
        if isEngaged {
            reqBody["orderBy"] = "engagement"
            reqBody["randomise"] = true
        }
        
        if categoryId != "" {
            reqBody["categoryId"] = categoryId
        }
        
        if isPriceSortNeeded == true {
//            reqBody["priceSort"] = isPriceLowTohigh ? "ascending" : "descending"
        }
        
        var request = URLRequest(url: URL(string: REF_POST_GET_ALL)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        
        
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            let status = jsonData["status"] as? Bool ?? false
            print(jsonData)
            
            if status {
                let allPostData = jsonData["data"] as! [[String: Any]]
                var allPosts = [PostItem]()
                
                for postData in allPostData {
                    let post = PostItem(dict: postData)
                    allPosts.append(post)
                }
                
                completion(allPosts, status, nil)
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(nil, status, message)
            }
        }
    }
    
    func fetchAllBiddingPost(postId: String = "", userId: String = "", count: Int = 10000, startRange: Int = 0, completion: @escaping([BidItem]?, Bool, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        let reqBody = ["type": "Auction", "startRange": startRange, "count": count, "postId": postId, "userId": userId, "all": false, "liveSort": true] as [String: Any]
        
        var request = URLRequest(url: URL(string: REF_POST_GET_ALL)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        
        
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            let status = jsonData["status"] as? Bool ?? false
            
            print(jsonData)
            
            if status {
                let allBidData = jsonData["data"] as! [[String: Any]]
                var allBids = [BidItem]()
                
                for bidData in allBidData {
                    let bid = BidItem(dict: bidData)
                    allBids.append(bid)
                }
                
                completion(allBids, status, nil)
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(nil, status, message)
            }
        }
    }
    
    
    func fetchPostDetail(postId: String = "", userId:String, completion: @escaping([BidItem]?, Bool, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        var reqBody = ["postId": postId] as [String: Any]
        
        if userId != "" {
            reqBody["userId"] = userId
        }
        
        var request = URLRequest(url: URL(string: REF_POST_DETAILS)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        print(loggedInUser?.auth ?? "")

        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            let status = jsonData["status"] as? Bool ?? false
            
            print(jsonData)
            
            if status {
                let allBidData = jsonData["data"] as! [[String: Any]]
                var allBids = [BidItem]()
                
                for bidData in allBidData {
                    let bid = BidItem(dict: bidData)
                    allBids.append(bid)
                }
                
                completion(allBids, status, nil)
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(nil, status, message)
            }
        }
    }

    
    func fetchPostDetailNormal(postId: String = "", userId:String, completion: @escaping([PostItem]?, Bool, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        var reqBody = ["postId": postId] as [String: Any]
        
        if userId != "" {
            reqBody["userId"] = userId
        }
        
        var request = URLRequest(url: URL(string: REF_POST_DETAILS)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        print(loggedInUser?.auth ?? "")
        
        
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            let status = jsonData["status"] as? Bool ?? false
            
            print(jsonData)
            
            if status {
                let allBidData = jsonData["data"] as! [[String: Any]]
                var allBids = [PostItem]()
                
                for bidData in allBidData {
                    let bid = PostItem(dict: bidData)
                    allBids.append(bid)
                }
                
                completion(allBids, status, nil)
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(nil, status, message)
            }
        }
    }

    //    func fetchAllMyPosts(completion: @escaping([PostItem]?, Bool, String?) -> Void) {
    //        let reqBody = ["requestType": "", "postLive": ""] as [String: Any]
    //
    //        var request = URLRequest(url: URL(string: REF_USER_MY_POSTS)!)
    //        request.httpMethod = HTTPMethod.post.rawValue
    //        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
    //
    //
    //        AF.request(request).responseJSON { (response) in
    //            let jsonData = response.value as? [String: Any] ?? [String: Any]()
    //            let status = jsonData["status"] as? Bool ?? false
    //
    //            if status {
    //                let allPostData = jsonData["data"] as! [[String: Any]]
    //                var allPosts = [PostItem]()
    //
    //                for postData in allPostData {
    //                    let post = PostItem(dict: postData)
    //                    allPosts.append(post)
    //                }
    //
    //                completion(allPosts, status, nil)
    //            } else {
    //                let message = jsonData["message"] as? String ?? ""
    //                completion(nil, status, message)
    //            }
    //        }
    //    }
    
    func fetchAllMyPurchases(forUserId userId: String, cID: String = "", completion: @escaping([PurchasedPostItem]?, Bool, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        var reqBody = ["UserId": userId] as [String: Any]
        
        if cID != "" {
            reqBody["subCategoryId"] = cID
        }
        
        var request = URLRequest(url: URL(string: loggedInUser?.id == userId ? REF_USER_MY_PURCHASES : REF_USER_Other_PURCHASES)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            let status = jsonData["status"] as? Bool ?? false
            print(jsonData)

            if status {
                let allPostData = jsonData["data"] as! [[String: Any]]
                var allPosts = [PurchasedPostItem]()
                
                for postData in allPostData {
                    print("DEBUG:- POST FDATA: \(postData)")
                    let post = PurchasedPostItem(dict: postData)
                    allPosts.append(post)
                }
                
                completion(allPosts, status, nil)
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(nil, status, message)
            }
        }
    }
    
    // FIXME: - working but not used!
    func deletePost(withPostId postId: String, completion: @escaping(Bool) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        let reqBody = ["postId": postId]
        
        var request = URLRequest(url: URL(string: REF_POST_DELETE)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as! [String: Any]
            print(jsonData)
            let status = jsonData["status"] as? Bool ?? false
            
            print("DEBUG:- stats: \(status)")
            completion(status)
        }
    }
    
    func likePost(withPostId postId: String, completion: @escaping(Bool) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        let reqBody = ["postId": postId]
        
        var request = URLRequest(url: URL(string: REF_POST_LIKE)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as! [String: Any]
            print(jsonData)
            let status = jsonData["status"] as? Bool ?? false
            
            completion(status)
        }
    }
    
    func dislikePost(withPostId postId: String, completion: @escaping(Bool) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        let reqBody = ["postId": postId]
        
        var request = URLRequest(url: URL(string: REF_POST_DISLIKE)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as! [String: Any]
            print(jsonData)
            let status = jsonData["status"] as? Bool ?? false
            
            completion(status)
        }
    }
    
    func getAllStates(completion: @escaping([AddressState]?, Bool, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        let reqBody = [:] as [String: Any]
        var request = URLRequest(url: URL(string: WSStateList)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            let status = jsonData["success"] as? Bool ?? false
            
            if status {
                let allPostData = jsonData["data"] as! [[String: Any]]
                var allCities = [AddressState]()
                
                for postData in allPostData {
                    print("DEBUG:- POST FDATA: \(postData)")
                    let post = AddressState(dict: postData)
                    allCities.append(post)
                }
                completion(allCities, status, nil)
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(nil, status, message)
            }
        }
    }
    
    
    
    func getAllCities(stateId: String, completion: @escaping([AddressCity]?, Bool, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        var reqBody = [:] as [String: Any]
        reqBody["stateId"] = stateId
        
        var request = URLRequest(url: URL(string: WSCityList)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            let status = jsonData["success"] as? Bool ?? false
            
            if status {
                let allPostData = jsonData["data"] as! [[String: Any]]
                var allCities = [AddressCity]()
                
                for postData in allPostData {
                    print("DEBUG:- POST FDATA: \(postData)")
                    let post = AddressCity(dict: postData)
                    allCities.append(post)
                }
                completion(allCities, status, nil)
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(nil, status, message)
            }
        }
    }
    
    
    func addComment(toPostWithId postId: String, comment commentText: String, parentCommentId: String? = nil, completion: @escaping(Bool) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        let reqBody: [String: Any]
        
        if let parentCommentId = parentCommentId {
            reqBody = ["postId": postId, "text": commentText, "parentId": parentCommentId]
        } else {
            reqBody = ["postId": postId, "text": commentText]
        }
        
        
        var request = URLRequest(url: URL(string: REF_POST_ADD_COMMENT)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as! [String: Any]
            print(jsonData)
            let status = jsonData["status"] as? Bool ?? false
            
            completion(status)
        }
    }
    
    func deleteComment(withCommentId commentId: String, completion: @escaping(Bool) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        let reqBody = ["commentId": commentId]
        
        var request = URLRequest(url: URL(string: REF_POST_DELETE_COMMENT)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as! [String: Any]
            print(jsonData)
            let status = jsonData["status"] as? Bool ?? false
            
            completion(status)
        }
    }
    
    
    func getComments(forPostWithId postId: String, count: Int = 1000, startRange: Int = 0, completion: @escaping([Comment]?, Bool, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        let reqBody = ["startRange": startRange, "count": count, "postId": postId] as [String: Any]
        
        var request = URLRequest(url: URL(string: REF_POST_GET_COMMENT)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as! [String: Any]
            print(jsonData)
            let status = jsonData["status"] as? Bool ?? false
            
            if status {
                let allCommentData = jsonData["data"] as! [[String: Any]]
                var allComments = [Comment]()
                
                for commentData in allCommentData {
                    let comment = Comment(dictionary: commentData)
                    allComments.append(comment)
                }
                
                completion(allComments, status, nil)
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(nil, status, message)
            }
        }
    }
    
    func likeComment(forComment comment: Comment, completion: @escaping(Bool) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        let reqBody = ["commentId": comment.id] as [String: Any]
        
        var request = URLRequest(url: URL(string: REF_POST_LIKE_COMMENT)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as! [String: Any]
            print(jsonData)
            let status = jsonData["status"] as? Bool ?? false
            
            completion(status)
        }
    }
    
    func dislikeComment(forComment comment: Comment, completion: @escaping(Bool) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        let reqBody = ["commentId": comment.id] as [String: Any]
        
        var request = URLRequest(url: URL(string: REF_POST_DISLIKE_COMMENT)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as! [String: Any]
            print(jsonData)
            let status = jsonData["status"] as? Bool ?? false
            
            completion(status)
        }
    }
    
    func performAction(ofType type: UserActionType, onUser user: User, completion: @escaping(Bool) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        let reqBody = ["userId": user.id, "status": type.rawValue] as [String: Any]
        
        var request = URLRequest(url: URL(string: REF_USER_PERFORM_ACTION)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as! [String: Any]
            print(jsonData)
            let status = jsonData["status"] as? Bool ?? false
            
            completion(status)
        }
    }
    
    func getDeliveryTimeSlots(completion: @escaping([TimeSlot]?, Bool, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        var request = URLRequest(url: URL(string: REF_CONFIG_GET_TIMESLOTS)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        print(request.url?.absoluteString)
        
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            print(jsonData)
            let status = jsonData["status"] as? Bool ?? false
            
            if status {
                let allTimeSlotsData = jsonData["data"] as! [[String: Any]]
                var allTimeSlots = [TimeSlot]()
                
                for timeSlotData in allTimeSlotsData {
                    let timeSlot = TimeSlot(dict: timeSlotData)
                    allTimeSlots.append(timeSlot)
                }
                
                completion(allTimeSlots, status, nil)
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(nil, status, message)
            }
        }
    }
    
    func addToCart(post: PostItem, variant: ItemVariant? = nil, quantity: Int, cartId:String = "", completion: @escaping(Bool, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        let reqBody: [String: Any]
        
        if let unwrappedVariant = variant {
            let item = ["postId": post.id, "variantId": unwrappedVariant.id, "price": unwrappedVariant.price, "quantity": quantity] as [String : Any]
            reqBody = ["item": item]
        } else {
            let item = ["postId": post.id, "price": post.price, "quantity": quantity] as [String : Any]
            reqBody = ["item": item]
        }
        
        var request = URLRequest(url: URL(string: REF_CART_ADD)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as! [String: Any]
            print(jsonData)
            let status = jsonData["status"] as? Bool ?? false
            
            if status {
                completion(status, nil)
            } else {
                let message = jsonData["err"] as? String
                completion(status, message)
            }
            
        }
    }
    
    func getCartItems(completion: @escaping([CartItem]?, Bool, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        var request = URLRequest(url: URL(string: REF_CART_GET)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        print(request.url?.absoluteString)

        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            let status = jsonData["status"] as? Bool ?? false
            
            print(response)
            
            if status {
                let allCartItemData = jsonData["data"] as! [[String: Any]]
                var allCartItems = [CartItem]()
                
                for cartItemData in allCartItemData {
                    let cartItem = CartItem(dict: cartItemData)
                    allCartItems.append(cartItem)
                }
                
                completion(allCartItems, status, nil)
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(nil, status, message)
            }
        }
    }
    
    func deleteCartItem(cartItem: CartItem, completion: @escaping(Bool) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        let reqBody: [String: Any]
        
        print("DEBUG:- cartItem: \(cartItem)")
        
        if let variant = cartItem.selectedVariant {
            reqBody = ["variantId": variant.id]
        } else {
            reqBody = ["postId": cartItem.id]
            print("DEBUG:- post wala")
        }
        
        print("DEBUG:- req: \(reqBody)")
        
        var request = URLRequest(url: URL(string: REF_CART_DELETE)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as! [String: Any]
            print(jsonData)
            let status = jsonData["status"] as? Bool ?? false
            
            completion(status)
        }
    }
    
    func cartCheckout(deliveryAddress: String, deliveryTimeSlot timeSlot: TimeSlot, deliveryCharge: Double, isHidden: Bool, paymentMethod:CartCheckoutPaymentMethodTypes?, amount:String, paymentId:String, discountAmount: String, completion: @escaping(Bool, CartPurchaseBlock?, String?)-> Void) {
        if self.checkIneterNet() == false {
            return
        }

        var reqBody = ["deliveryAddressId": deliveryAddress, "deliveryTimeSlot": timeSlot.id, "deliveryCharge": deliveryCharge, "paymentType": "online", "hidden": isHidden, "paymentMethodId" : paymentMethod == .knet ? 1 : 2,  "couponAmount": discountAmount] as [String: Any]
        
        if paymentMethod != nil {
            if paymentMethod == .wallet {
                reqBody["walletAmount"] = amount
                reqBody["paymentType"] = "wallet"
            }
        }
        
        print("DEBUG:- reqBody: \(reqBody)")
        
        var request = URLRequest(url: URL(string: REF_CART_CHECKOUT)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        
        AF.request(request).responseJSON { response in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            let status = jsonData["status"] as? Bool ?? false
            print(jsonData)
            if status {
                let purchaseDataDict = jsonData["Purchase"] as! [String: Any]
                let purchaseData = CartPurchaseBlock(dict: purchaseDataDict)
                completion(status, purchaseData, nil)
            } else {
                let message = jsonData["message"] as? String ?? ""
                let message1 = jsonData["msg"] as? String ?? ""
                if message1 != "" {
                    completion(status, nil, message1)
                }
                completion(status, nil, message)
            }
        }
    }
    
    
    func verifyCoupon(couponCode: String, onAmount amount: Double, completion: @escaping(Bool, Coupon?, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        let reqBody = ["couponCode": couponCode, "totalAmount": amount] as [String: Any]
        
        var request = URLRequest(url: URL(string: REF_COUPON_VERIFY)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        
        AF.request(request).responseJSON { response in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            let status = jsonData["success"] as? Bool ?? false
            
            if status {
                let couponData = jsonData["data"] as! [String: Any]
                let coupon = Coupon(dict: couponData)
                
                completion(status, coupon, nil)
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(status, nil, message)
            }
        }
    }
    
    func addPurchase(type: PostPurchaseType, forPostId postId: String, amount: Double, walletAmount: Double = 0, deliveryCharges: Double, paymentType: BiddingPayPaymentTypes, purchaseType: String, completion: @escaping(Bool, ItemPurchaseData?, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        var reqBody = ["PostId": postId, "amount": amount, "paymentType": paymentType.rawValue, "deliveryCharges": deliveryCharges, "purchaseType": type.rawValue, "walletAmount": walletAmount, "paymentMethodId" : paymentType == .knet ? 1 : 2] as [String: Any]
        reqBody["paymentType"] = "online"
        reqBody["purchaseType"] = purchaseType
        if paymentType == .wallet {
            reqBody["walletAmount"] = amount
            reqBody["paymentType"] = "wallet"
        }
        
        var request = URLRequest(url: URL(string: REF_PURCHASE_ADD)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        
        AF.request(request).responseJSON { response in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            let status = jsonData["status"] as? Bool ?? false
            print(jsonData)
            if status {
                if let dict = jsonData as? [String:Any] {
                    let purchaseData = ItemPurchaseData(dict: dict)
                    completion(status, purchaseData, nil)
                }
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(status, nil, message)
            }
        }
    }
    
    func reportPost(withId postId: String, message: String = "", completion: @escaping(Bool) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        let reqBody = ["postId": postId, "comment": message] as [String: Any]
        
        var request = URLRequest(url: URL(string: REF_POST_REPORT)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        
        AF.request(request).responseJSON { response in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            let status = jsonData["status"] as? Bool ?? false
            
            completion(status)
        }
    }
    
    
    func addPurchaseSuccesFailureForCart(paymentId: String, isSuccess:Bool, dict:[String:Any], completion: @escaping(Bool) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        var reqBody : [String:Any] = dict
        reqBody["paymentId"] = paymentId
        var request = URLRequest(url: URL(string: isSuccess ?  REF_GET_SUCCESS : REF_GET_FAILED)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        print(request.url?.absoluteString)
        print(reqBody)
        AF.request(request).responseJSON { response in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            var status = jsonData["success"] as? Bool ?? false
            if "\(jsonData["success"])" == "1" {
                status = true
            }
            print(jsonData)
            completion(status)
        }
    }
    
    
    
    func addPurchaseSuccesFailure(paymentId: String, isSuccess:Bool, dict:[String:Any], completion: @escaping(Bool) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        var reqBody : [String:Any] = dict
        reqBody["paymentId"] = paymentId
        reqBody["DeliveryAddressId"] = "4eee343e-3ef3-4357-aac7-155ea51c7c3e"
        
        var request = URLRequest(url: URL(string: isSuccess ?  REF_GET_SUCCESS : REF_GET_FAILED)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        
        AF.request(request).responseJSON { response in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            var status = jsonData["success"] as? Bool ?? false
            if "\(jsonData["success"])" == "1" {
                status = true
            }
            print(jsonData)
            completion(status)
        }
    }
    
    
    func fetchMyOrders(completion: @escaping(Bool, [OrderItem]?, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        let reqBody = ["startRange": 0, "recordLimit": 100] as [String: Any]
        
        var request = URLRequest(url: URL(string: REF_MY_ORDERS)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        
        AF.request(request).responseJSON { response in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            let status = jsonData["success"] as? Bool ?? false
            
            print(jsonData)
            if status {
                let allOrderItemData = jsonData["data"] as! [[String: Any]]
                var allOrderItems = [OrderItem]()
                
                for orderItemData in allOrderItemData {
                    let orderItem = OrderItem(dict: orderItemData)
                    allOrderItems.append(orderItem)
                }
                
                completion(status, allOrderItems, nil)
            } else {
                let message = jsonData["msg"] as? String ?? ""
                completion(status, nil, message)
            }
        }
    }
    
    func fetchViewedPosts(completion: @escaping(Bool, [Any]?, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        var request = URLRequest(url: URL(string: REF_USER_VIEWED)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        AF.request(request).responseJSON { response in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            let status = jsonData["status"] as? Bool ?? false
            
            if status {
                let allPostItemDicts = jsonData["data"] as! [[String: Any]]
                var allPostItems = [Any]()
                
                for postItemDict in allPostItemDicts {
                    let type = postItemDict["type"] as? String ?? ""
                    print("DEBUG:- RECEIVEED TYPR: \(type)")
                    guard let postType = PostType(rawValue: type) else { continue }
                    
                    switch postType {
                    case .fixed:
                        let postItem = PostItem(dict: postItemDict)
                        allPostItems.append(postItem)
                    case .auction:
                        let auctionItem = BidItem(dict: postItemDict)
                        allPostItems.append(auctionItem)
                    }
                }
                
                completion(status, allPostItems, nil)
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(status, nil, message)
            }
        }
    }
    
    func fetchLikedPosts(completion: @escaping(Bool, [Any]?, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        var request = URLRequest(url: URL(string: REF_USER_LIKED)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        AF.request(request).responseJSON { response in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            let status = jsonData["status"] as? Bool ?? false
            
            if status {
                let allPostItemDicts = jsonData["data"] as! [[String: Any]]
                var allPostItems = [Any]()
                
                for postItemDict in allPostItemDicts {
                    let type = postItemDict["type"] as? String ?? ""
                    let postType = PostType(rawValue: type)!
                    
                    switch postType {
                    case .fixed:
                        var postItem = PostItem(dict: postItemDict)
                        postItem.isLiked = true
                        allPostItems.append(postItem)
                    case .auction:
                        var auctionItem = BidItem(dict: postItemDict)
                        auctionItem.isLiked = true
                        allPostItems.append(auctionItem)
                    }
                }
                
                completion(status, allPostItems, nil)
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(status, nil, message)
            }
        }
    }
    
    
    func fetchAllAddress(completion: @escaping(Bool, [Address]?, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        var request = URLRequest(url: URL(string: REF_ADDRESS_LIST)!)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        AF.request(request).responseJSON { response in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            let status = jsonData["success"] as? Bool ?? false
            
            if status {
                let allAddressDicts = jsonData["data"] as! [[String: Any]]
                var allAddresses = [Address]()
                
                for addressDict in allAddressDicts {
                    let address = Address(dict: addressDict)
                    allAddresses.append(address)
                }
                
                completion(status, allAddresses, nil)
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(status, nil, message)
            }
        }
    }
    
    //    func updateAddress(withAddressId addressId: String, addressName: String, mobileNo: String, mobileAlternateNo: String, addressLane1Text: String, addressLane2Text: String, landmark: String, selectedCoordinates: SellingLocation, selectedCity: AddressCity?, selectedDesc: String, typeOfAddress: AddressType, isDefault: Bool, completion: @escaping(Bool) -> Void) {
    //
    //        let reqBody = [ "CityId": "9c95700f-d1e4-456d-95fd-aca1be8dd308", "addressId": addressId, "name": addressName, "address_line_1": addressLane1Text, "address_line_2": addressLane2Text, "landmark": landmark, "direction": selectedDesc, "mobile": mobileNo, "label": typeOfAddress.rawValue, "alternate_mobile": mobileAlternateNo, "default": isDefault, "lat": selectedCoordinates.coordinate.latitude, "long": selectedCoordinates.coordinate.longitude] as [String : Any]
    //
    //        var request = URLRequest(url: URL(string: REF_ADDRESS_EDIT)!)
    //        request.httpMethod = HTTPMethod.patch.rawValue
    //        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
    //
    //        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
    //        request.httpBody = jsonBody
    //
    //        print(request.url?.absoluteString)
    //        print(reqBody)
    //
    //        AF.request(request).responseJSON { response in
    //            let jsonData = response.value as? [String: Any] ?? [String: Any]()
    //            let status = jsonData["success"] as? Bool ?? false
    //
    //            completion(status)
    //        }
    //    }
    
    func addAddress(addressName: String, mobileNo: String, mobileAlternateNo: String, CityId: String, label: String, block: String, street: String, avenue: String, floor: String, flat: String, selectedCoordinates: SellingLocation, isDefault: Bool, direction: String, apartment: String, completion: @escaping(Bool) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        var reqBody : [String : Any] = [:]
        reqBody["name"] = addressName
        reqBody["mobile"] = mobileNo
        reqBody["alternate_mobile"] = mobileAlternateNo
        reqBody["CityId"] = CityId
        reqBody["label"] = label
        reqBody["block"] = block
        reqBody["street"] = street
        reqBody["avenue"] = avenue
        reqBody["floor"] = floor
        reqBody["flat"] = flat
        reqBody["lat"] = selectedCoordinates.coordinate.latitude
        reqBody["long"] = selectedCoordinates.coordinate.longitude
        reqBody["direction"] = direction
        reqBody["apartment"] = apartment

        
        var request = URLRequest(url: URL(string: REF_ADDRESS_ADD)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        AF.request(request).responseJSON { response in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            let status = jsonData["success"] as? Bool ?? false
            completion(status)
        }
    }
    
    func updateAddress(addressName: String, mobileNo: String, mobileAlternateNo: String, CityId: String, label: String, block: String, street: String, avenue: String, floor: String, flat: String, selectedCoordinates: SellingLocation, isDefault: Bool, addressId:String, direction: String, apartment: String, completion: @escaping(Bool) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        var reqBody : [String : Any] = [:]
        reqBody["name"] = addressName
        reqBody["mobile"] = mobileNo
        reqBody["alternate_mobile"] = mobileAlternateNo
        reqBody["CityId"] = CityId
        reqBody["label"] = label
        reqBody["block"] = block
        reqBody["street"] = street
        reqBody["avenue"] = avenue
        reqBody["floor"] = floor
        reqBody["flat"] = flat
        reqBody["lat"] = selectedCoordinates.coordinate.latitude
        reqBody["long"] = selectedCoordinates.coordinate.longitude
        reqBody["addressId"] = addressId
        reqBody["direction"] = direction
        reqBody["apartment"] = apartment

        var request = URLRequest(url: URL(string: REF_ADDRESS_EDIT)!)
        request.httpMethod = HTTPMethod.patch.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        AF.request(request).responseJSON { response in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            let status = jsonData["success"] as? Bool ?? false
            print(jsonData)
            completion(status)
        }
    }
    
    
    func accountVerificationRequest(completion: @escaping(Bool) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        let link = REF_ACCOUNT_Verification
        var request = URLRequest(url: URL(string: link)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        AF.request(request).responseJSON { response in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            let status = jsonData["success"] as? Bool ?? false
            completion(status)
        }
    }
    
    
    func deleteAddress(withAddressId addressId: String, completion: @escaping(Bool) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        let link = REF_ADDRESS_DELETE + "/\(addressId)"
        var request = URLRequest(url: URL(string: link)!)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        AF.request(request).responseJSON { response in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            let status = jsonData["success"] as? Bool ?? false
            
            completion(status)
        }
    }
    
    func fetchMyBiddings(ofType type: MyBiddingType, completion: @escaping(Bool, [MyBiddingItem]?, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        let reqBody = ["requestType": "active", "filterType": type.rawValue] as [String: Any]
        
        var request = URLRequest(url: URL(string: REF_BIDDING_MYBIDDING)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        
        AF.request(request).responseJSON { response in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            let status = jsonData["status"] as? Bool ?? false
            print(jsonData)
            if status {
                let allMyBiddingDicts = jsonData["data"] as! [[String: Any]]
                var allMyBiddinges = [MyBiddingItem]()
                
                for myBiddingDict in allMyBiddingDicts {
                    let myBidding = MyBiddingItem(dict: myBiddingDict)
                    allMyBiddinges.append(myBidding)
                }
                
                completion(status, allMyBiddinges, nil)
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(status, nil, message)
            }
        }
    }
    
    func fetchRecentLiveSellers(completion: @escaping(Bool, [User]?, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        var request = URLRequest(url: URL(string: REF_USER_RECENT_LIVE_SELLERS)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        print(request.url?.absoluteString)
        print(loggedInUser?.auth ?? "")
        
        AF.request(request).responseJSON { response in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            let status = jsonData["status"] as? Bool ?? false
            
            print(jsonData)
            
            if status {
                let allLiveSellerDicts = jsonData["data"] as! [[String: Any]]
                var allLiveSellers = [User]()
                
                for liveSellerDict in allLiveSellerDicts {
                    let liveSeller = User(dictionary: liveSellerDict)
                    allLiveSellers.append(liveSeller)
                }
                
                completion(status, allLiveSellers, nil)
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(status, nil, message)
            }
        }
    }
    
    
    
    
    func requestSalesReport(completion: @escaping(Bool, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        let reqBody = ["sendMail": true] as [String: Any]
        
        var request = URLRequest(url: URL(string: WSForGetAllTransaction)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        AF.request(request).responseJSON { response in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            let status = jsonData["success"] as? Bool ?? false
            print(jsonData)
            if status {
                completion(status, nil)
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(status, message)
            }
        }
    }
    
    
    // FIXME: - working but not used!
    func addNewCategory(cateId:String, nameEn:String, nameAr:String, completion: @escaping(Bool, ItemSubCategory?, String) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        let reqBody = ["categoryId": cateId,
                       "nameEn": nameEn,
                       "nameAr": nameAr,
                       "sellerId": AppUser.shared.getDefaultUser()?.id ?? ""] as [String: Any]
        
        
        var request = URLRequest(url: URL(string: REF_ADD_SUB_CATEGORY)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as! [String: Any]
            print(jsonData)
            
            let status = jsonData["status"] as? Bool ?? false
            let message = jsonData["error"] as? String ?? ""
            var itemData = ItemSubCategory(dict: [:])
            if let dict = jsonData["data"] as? [String:Any] {
                itemData = ItemSubCategory(dict: dict)
            }
            
            completion(status, itemData, message)
        }
    }
    
    
    // FIXME: - working but not used!
    func getSubCategoryList(cateId:String, completion: @escaping(Bool, [ItemSubCategory], String) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        let reqBody = ["categoryId": cateId,
                       "sellerId": AppUser.shared.getDefaultUser()?.id ?? ""] as [String: Any]
        
        
        var request = URLRequest(url: URL(string: REF_GET_SUB_CATEGORY)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as! [String: Any]
            print(jsonData)
            
            let status = jsonData["status"] as? Bool ?? false
            let message = jsonData["error"] as? String ?? ""
            var arr : [ItemSubCategory] = []
            if let dict = jsonData["data"] as? [[String:Any]] {
                for value in dict {
                    arr.append(ItemSubCategory(dict: value))
                }
            }
            
            completion(status, arr, message)
        }
    }

    // FIXME: - deacticvate users!
    func deactivateUser(completion: @escaping(Bool, String) -> Void) {
        if self.checkIneterNet() == false {
            return
        }
        var request = URLRequest(url: URL(string: DEACTIVATE_USER)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        print(request.url?.absoluteString)
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as! [String: Any]
            print(jsonData)
            let status = jsonData["status"] as? Bool ?? false
            let message = jsonData["error"] as? String ?? ""
            completion(status, message)
        }
    }

    
    // FIXME: - deacticvate users!
    func getSelectedInterrest(completion: @escaping(Bool, [CategoryObject], String) -> Void) {
        if self.checkIneterNet() == false {
            return
        }
        var request = URLRequest(url: URL(string: Interest_Get)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        print(request.url?.absoluteString)
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as! [String: Any]
            print(jsonData)
            let status = jsonData["status"] as? Bool ?? false
            let message = jsonData["error"] as? String ?? ""
            
            var arr : [CategoryObject] = []
            if let dict = jsonData["data"] as? [[String:Any]] {
                for value in dict {
                    arr.append(CategoryObject(dict: value))
                }
            }

            completion(status, arr, message)
        }
    }

    
    func addVariantSaprately(forPostId postId: String, arrVariant:[VariantObject], completion: @escaping([PurchasedPostItem]?, Bool, String?) -> Void) {
        if self.checkIneterNet() == false {
            return
        }

        var reqBody = ["postId": postId] as [String: Any]
        
        var allVariants = [[String: Any]]()
        arrVariant.forEach { variant in
            var itemVariantDict = [String: Any]()
            
            if variant.strId != "" {
                itemVariantDict["id"] = variant.strId
            }
            itemVariantDict["price"] = variant.strPrice
            itemVariantDict["quantity"] = variant.strQuantity
            
            var allAtt = [[String: Any]]()

            var dictData1 = [String: Any]()
            dictData1["nameEn"] = variant.strV1Eng
            dictData1["nameAr"] = variant.strV1Ar
            allAtt.append(dictData1)

            if variant.strV2Eng != "" {
                var dictData2 = [String: Any]()
                dictData2["nameEn"] = variant.strV2Eng
                dictData2["nameAr"] = variant.strV2Ar
                allAtt.append(dictData2)
            }

            itemVariantDict["attributes"] = allAtt
            
            allVariants.append(itemVariantDict)
        }
        
        reqBody["variants"] = allVariants

        
        var request = URLRequest(url: URL(string: REF_VARIANT_EDITADD)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loggedInUser?.auth ?? "", forHTTPHeaderField: "Authorization")
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: reqBody)
        request.httpBody = jsonBody
        
        print(request.url?.absoluteString)
        print(reqBody)
        
        
        AF.request(request).responseJSON { (response) in
            let jsonData = response.value as? [String: Any] ?? [String: Any]()
            let status = jsonData["status"] as? Bool ?? false
            
            if status {
                completion([], status, nil)
            } else {
                let message = jsonData["message"] as? String ?? ""
                completion(nil, status, message)
            }
        }
    }

    func checkIneterNet() -> Bool {
        if Connectivity.isConnectedToInternet == false {
            Utility.showISMessage(str_title: "Internet Unavailable", Message: "Please check your internet connection.", msgtype: .warning)
            return false
        }
        return true
    }
}



struct Connectivity {
  static let sharedInstance = NetworkReachabilityManager()!
  static var isConnectedToInternet:Bool {
      return self.sharedInstance.isReachable
    }
}
