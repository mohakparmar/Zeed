

import UIKit
import Alamofire
import Photos
import SwiftUI


class WSManage: NSObject {
    
    // MARK:  -
    // MARK: Base Service URL
    //    static let BaseUrl: String = "http://204.48.26.50:8031/"
    //    static let SocketURL: String = "http://204.48.26.50:8031/"
    
//        static let BaseUrl: String = "http://dev.infoware.xyz:8042/"
//        static let SocketURL: String = "http://dev.infoware.xyz:8042/"

    
//    static let BaseUrl: String = "https://zeed.infoware.xyz/"
//    static let SocketURL: String = "https://zeed.infoware.xyz/"

    // live server
    static let BaseUrl: String = "https://api.zeedco.co/"
    static let SocketURL: String = "https://api.zeedco.co/"


    // staging server
//    static let BaseUrl: String = "http://77.68.6.165:8040/"
//    static let SocketURL: String = "http://77.68.6.165:8040/"
    
    // test server
    //    static let BaseUrl: String = "http://204.48.26.50:8040/"
    //    static let SocketURL: String = "http://204.48.26.50:8040/"
    
    
    // MARK:  -
    // MARK: WS Name
    static let WSUsrRegister: String = "user/register"
    static let WSUsrLogin: String = "user/login"
    static let WSUsrSearch: String = "user/search"
    static let WSUsrFollow: String = "user/follow"
    static let WSUsrForgotPassword: String = "user/forgotPassword"
    static let WSUsrChangePassword: String = "user/changePassword"
    static let WSUsrSetPublic: String = "user/setPublic"
    static let WSUsrUpdateProfile: String = "user/update"
    static let WSUsrAll: String = "user/getAll"
    static let WSUsrImage: String = "user/image"
    static let WSUsrEmailCheck: String = "user/findEmail"
    static let WSCountryList: String = "country/list"
    static let WSForGetFollowerList: String = "user/followList"
    
    static let WSForAddStory: String = "story/add"
    static let WSForGetAllStory: String = "story/getAll"
    static let WSForStoryMediaSeen: String = "story/seen"
    static let WSForReportStory: String = "story/report"
    static let WSForDeleteStory: String = "story/delete"
    static let WSForJoingLiveToken: String = "live/accessToken"
    
    static let WSDirectMessage: String = "message/direct"
    static let WSChatUserList: String = "message/users"
    
    static let WSAddGroup: String = "group/add"
    static let WSUpdateGroup: String = "group/update"
    static let WSGroupMessage: String = "message/group"
    static let WSGetGroupDetails: String = "group/getAll"
    static let WSMakeAdmin: String = "group/makeAdmin"
    static let WSRemoveAdmin: String = "group/removeAdmin"
    static let WSAddUser: String = "group/addUsers"
    static let WSRemoveUser: String = "group/removeUser"
    
    static let WSPostAdd: String = "post/add"
    static let WSPostUpdate: String = "post/update"
    static let WSGetPost: String = "post/getAll"
    static let WSGetPostComment: String = "post/getComments"
    static let WSAddPostComment: String = "post/addComment"
    static let WSGetMedias: String = "post/getMedia"
    
    static let WSGetSelectedCategory: String = "interest/get"
    static let WSGetCategory: String = "category/get"
    static let WSAddLike: String = "post/like"
    static let WSRemoveLike: String = "post/dislike"
    static let WSReportPost: String = "post/report"
    static let WSStorySeenUser: String = "story/getSeens"
    
    static let WSPostSave: String = "post/save"
    static let WSPostUnSave: String = "post/unSave"
    static let WSPostGet: String = "post/getSaved"
    static let WSRepost: String = "post/repost"
    static let WSGetSavePost: String = "post/getSaved"
    static let WSPostLikeComment: String = "post/likeComment"
    static let WSPostDislikeComment: String = "post/dislikeComment"
    static let WSPostPostDetails: String = "post/resolvePost"
    static let WSPostPostDeleteComment: String = "post/deleteComment"
    
    
    static let WSGetNotification: String = "notification/getAll"
    
    static let WSTurnOnPostNotification: String = "post/turnOnPostAdd"
    static let WSTurnOffPostNotification: String = "post/turnOnPostDelete"
    
    static let WSMutePost: String = "post/mutePostAdd"
    static let WSUnMutePost: String = "post/mutePostDelete"
    static let WSDeletePost: String = "post/delete"
    
    // Calling API
    static let WSMakeCall: String = "call/makeCall"
    
    static let WSBlockUser: String = "user/block"
    static let WSBlockList: String = "user/blockUserList"
    
    static let WSPackageGet: String = "package/get"
    
    static let WSAddMyPackage: String = "user/package/add"
    static let WSGetMyPackage: String = "user/package/get"
    
    static let WSGetBidList: String = "bidding/get"
    static let WSAddBidding: String = "bidding/add"
    static let WSForMyBidding: String = "user/myBidding"
    static let WSForGetBids: String = "bid/get"
    static let WSForAddBids: String = "bid/add"
    
    static let WSForMarkAsSoldItem: String = "bidding/item/markAsSold"
    static let WSForSkipItem: String = "bidding/item/skip"
    static let WSForAcceptWinner: String = "bidding/item/acceptWinner"
    
    static let WSForGetItems: String = "bidding/item/get"
    static let WSForBiddingGoLive: String = "bidding/goLive"
    
    static let WSForViewCountUpdate: String = "post/setViewCount"
    
    static let WSForMessageSetting: String = "message/chatSetting"
    static let WSForGetByUserName: String = "user/getByUsername"
    
    static let WSAddToBusiness: String = "changeToBusiness/add"
    static let WSUpdateToBusiness: String = "changeToBusiness/update"
    static let WSGetBusinessDetails: String = "changeToBusiness/get"
    
    static let WSForCheckIn: String = "user/checkIn"
    static let WSForCheckOut: String = "user/checkOut"
    static let WSPromotionAdd: String = "promotion/add/"
    //    static let WS: String = ""
    //    static let WS: String = ""
    //    static let WS: String = ""
    //    static let WS: String = ""

    static let WSForTerms: String = "terms/get"
    static let WSAddMedia: String = "media/add"
    static let WSAddGetInterest: String = "interest/getInterest"
    static let WSForGetTransactions: String = "user/getWalletTransactions"
    static let WSGetSingleUser: String = "user/getOne"

    
    static let WSGetPaymentMethod: String = "purchase/getPaymentMethods"
    static let WSForAddInterest: String = "interest/add"
    static let WSForTrasferToBank: String = "user/sendMoneyToBank"
    static let WSGetGetOtherUserPurchase: String = "purchase/get"


    // MARK:  -
    // MARK: Completion Handler
    typealias CompletionHandler = (Bool?, [String : AnyObject]?) -> Void
    public typealias params = [String: Any]
    
    // MARK:  -
    // MARK: To get url with name
    class func getFinalUrl(str:String) -> URL {
        return URL(string: WSManage.BaseUrl + str)!
    }

    // MARK:  -
    // MARK: Method for get request
    class func getDataWithGetMethod(name: String, completionHandler: @escaping CompletionHandler) {
        var urlString = name.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)

        let url:URL = URL(string: urlString!)!
        AF.request(url).response { response in
            do {
                let result:[String:AnyObject] = try JSONSerialization.jsonObject(with: response.data ?? Data(), options: .allowFragments ) as! [String : AnyObject]
                completionHandler( false, result)
            } catch _ {
                completionHandler( true, nil)
            }
        }
    }
    
    // MARK: Method for get request
    class func getDataWithURL(name: String, completionHandler: @escaping CompletionHandler) {
        let url:URL = URL(string: name)!
        AF.request(url).response { response in
            do {
                let result:[String:AnyObject] = try JSONSerialization.jsonObject(with: response.data ?? Data(), options: .allowFragments ) as! [String : AnyObject]
                completionHandler( false, result)
            } catch _ {
                completionHandler( true, nil)
            }
        }
    }
    
    
    // MARK:  -
    // MARK: Method for get/post request with params
    class func getDataWithPost(name: String, parameters: params, isPost:Bool, completionHandler: @escaping CompletionHandler) {
        let url:URL = self.getFinalUrl(str: name)
        print(url.absoluteURL)
        
        AF.request(url, method: isPost ? .post : .get, parameters: parameters)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                //  print("Progress: \(progress.fractionCompleted)")
            }
            .responseJSON { response in
                do {
                    let result:[String:AnyObject] = try JSONSerialization.jsonObject(with: response.data ?? Data(), options: .allowFragments ) as! [String : AnyObject]
                    completionHandler( false, result)
                } catch _ {
                    completionHandler( true, nil)
                }
            }
    }
    
    
    // MARK:  -
    // MARK: Method for get/post request with params
    class func getDataWithGetServiceWithParams(name: String, parameters: params, isPost:Bool, passToken : Bool = true, completionHandler: @escaping CompletionHandler) {
        let url:URL = self.getFinalUrl(str: name)
        
        print(url)
        print(parameters)
        var  token:String = AppUser.shared.getDefaultUser()!.auth.count ?? 0 > 0 ? AppUser.shared.getDefaultUser()!.auth ?? "" : ""
        //        token = token.replacingOccurrences(of: "bearer ", with: "")
        print(token)
        
        var headers: HTTPHeaders = [
            "Content-type": "application/x-www-form-urlencoded"
        ]
        if passToken {
            headers = [
                "Authorization": token,
                "Content-type": "application/x-www-form-urlencoded"
            ]
        }
        AF.request(url, method: isPost ? .post : .get, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                //  print("Progress: \(progress.fractionCompleted)")
            }
            .responseJSON { response in
                do {
                    let result:[String:AnyObject] = try JSONSerialization.jsonObject(with: response.data ?? Data(), options: .allowFragments ) as! [String : AnyObject]
                    completionHandler( false, result)
                } catch _ {
                    completionHandler(true, nil)
                }
            }
    }
    
    // MARK:  -
    // MARK: Multipart form data upload
    class func requestWithMultipartImageDataUpload(name: String, imageData: Data?, type:Int, parameters: [String : Any], imageName:String, completionHandler: @escaping CompletionHandler) {
        
        let url:URL = self.getFinalUrl(str: name)
        print(url)
        print(parameters)
//        var  token:String = AppUser.shared.getDefaultUser()!.auth.count ?? 0 > 0 ? AppUser.shared.getDefaultUser()!.auth ?? "" : ""
        //        token = token.replacingOccurrences(of: "bearer ", with: "")
//        print(token)
        
        let headers: HTTPHeaders = [
//            "Authorization": token,
            "Content-type": "multipart/form-data"
        ]
        
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if type == 0 {
                if let data = imageData{
                    multipartFormData.append(data, withName: imageName, fileName: imageName + ".png", mimeType: "image/png")
                }
            } else if type == 1 {
                if let data = imageData{
                    multipartFormData.append(data, withName: imageName, fileName: imageName + ".m4a", mimeType: "audio/m4a")
                }
            }
            
        }, to: url, usingThreshold: UInt64.init(), method: .post, headers: headers)  .responseJSON { (resp) in
            do {
                let result:[String:AnyObject] = try JSONSerialization.jsonObject(with: resp.data ?? Data(), options: .allowFragments ) as! [String : AnyObject]
                completionHandler( false, result)
            } catch _ {
                completionHandler(true, nil)
            }

            print("resp is \(resp)")
        }
    }
    
    
    
    // MARK:  -
    // MARK: Multipart form data upload
    class func uploadMultipleImages(name: String, parameters: [String : Any], arrImages:[ImageObject], completionHandler: @escaping CompletionHandler) {
        
        let url:URL = self.getFinalUrl(str: name)
        
        print(url)
        print(parameters)
//        var  token:String = AppUser.shared.getDefaultUser()!.auth.count ?? 0 > 0 ? AppUser.shared.getDefaultUser()!.auth ?? "" : ""
        //        token = token.replacingOccurrences(of: "bearer ", with: "")
//        print(token)
        
        
        let headers: HTTPHeaders = [
//            "Authorization": token,
            "Content-type": "multipart/form-data"
        ]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            //  var index : Int = 0
            for img in arrImages {
                
                let name = String(format: "media")
                if img.strType == "3" {
                    multipartFormData.append(img.dataVideo, withName: name, fileName: name + ".gif", mimeType: "image/gif")
                } else if let data = img.dataVideo {
                    multipartFormData.append(data, withName: name, fileName: name + ".mp4", mimeType: "video/mp4")
                } else {
                    let imgData = img.image.jpegData(compressionQuality: 0.8)
                    if let data = imgData {
                        multipartFormData.append(data, withName: name, fileName: name + ".png", mimeType: "image/png")
                    }
                }
                //index = index + 1
            }
            
        }, to: url, usingThreshold: UInt64.init(), method: .post, headers: headers)  .responseJSON { (resp) in
            do {
                let result:[String:AnyObject] = try JSONSerialization.jsonObject(with: resp.data ?? Data(), options: .allowFragments ) as! [String : AnyObject]
                completionHandler( false, result)
            } catch _ {
                completionHandler(true, nil)
            }
            print("resp is \(resp)")
        }
    }
    
    
    // MARK:  -
    // MARK: Method for get/post request with params
    class func getDataWithGetServiceWithParamsJsonRow(name: String, parameters: [String : Any], isPost:Bool, passToken : Bool = true, completionHandler: @escaping CompletionHandler) {
        
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)

        // create post request
        let url:URL = WSManage.getFinalUrl(str: name)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        print(url)
        print(self.params)
        print(parameters)

        let  token:String = AppUser.shared.getDefaultUser()!.auth.count ?? 0 > 0 ? AppUser.shared.getDefaultUser()!.auth ?? "" : ""
        print(token)
        
        // insert json data to the request
        request.httpBody = jsonData
        
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: AnyObject] {
                print(responseJSON)
                completionHandler( false, responseJSON)
            } else {
                completionHandler( true, nil)
            }
        }
        task.resume()
        
    }
    
    
    
    //  Detail Alamofire documentation
    //  https://github.com/Alamofire/Alamofire/blob/master/Documentation/Alamofire%204.0%20Migration%20Guide.md
    
    
    
}

