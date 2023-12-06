//
//  SocketService.swift
//  Zeed
//
//  Created by Shrey Gupta on 07/05/21.
//

import Foundation
import SocketIO

enum BiddingRoomConnectionType: String {
    case normalBidding = "normalBidding"
    case subscriber = "SUBSCRIBER"
    case publisher = "PUBLISHER"
}

protocol SocketServiceDelegate: AnyObject {
    func didJoinRoom(status: Bool, maxBid: Double?, uid: Int?, token: String?)
    func liveUsers(count: Int)
    func didAddBid(status: Bool, msg : String)
    func currentBid(maxBid: Double, maxBidUser: CurrentBidItem)
    func markAsSold(status: Bool, maxBidUser: CurrentBidItem?)
    func markAsUnSold(status: Bool, maxBidUser: CurrentBidItem?)
    func leaveBidding(status: Bool)
    func endBidding(status: Bool)
    func bidsMade(allBiders: [BidMadeUser])
    func sendComment(objComment : CommentObject)
}

class SocketConnection {
    public static let shared = SocketConnection()
    let manager: SocketManager
    
    private init() {
        manager = SocketManager(socketURL: URL(string: SOCKETURL)!, config: [.log(true), .compress, .forceWebsockets(true), .connectParams(["token": AppUser.shared.getDefaultUser()!.auth, "EIO" : "3", "t" : "2342342"])])
    }
}

class SocketService {
    static var shared = SocketService()
    
    var socket: SocketIOClient {
        return SocketConnection.shared.manager.defaultSocket
    }
    
    weak var delegate: SocketServiceDelegate?
    
    init() {
        setUpListeners()
    }
    
    deinit {
        socket.removeAllHandlers()
    }
    
    func setUpListeners() {
        print("DEBUG:- DID SET UP LISTENERS")
        
        socket.on("joinBiddingRoom") { data, ack in
            guard let data = data.first as? [String: Any] else { return }
            let status = data["status"] as? Bool ?? false
            
            let maxBid = data["maxBid"] as? Double ?? nil
            
            let uid = data["uid"] as? Int ?? nil
            let token = data["token"] as? String ?? nil
            
            self.delegate?.didJoinRoom(status: status, maxBid: maxBid, uid: uid, token: token)
        }
        
        socket.on("new message") {data, ack in
            print(data)
            if let arr = data as?  [[String:AnyObject]] {

            }
        }
        

        socket.on("comment") { data, ack in
            if let arr = data as?  [[String:AnyObject]] {
                for item in arr {
                    self.delegate?.sendComment(objComment: CommentObject(dict: item))
                }
            }
        }


        socket.on("liveUsers") { data, ack in
            guard let data = data.first as? [String: Any] else { return }

            let count = data["count"] as? Int ?? 0
            self.delegate?.liveUsers(count: count)
        }
        

        socket.on("addBid") { data, ack in
            guard let data = data.first as? [String: Any] else { return }
            let status = data["status"] as? Bool ?? false
            var strMsg : String = ""
            if status == false {
                if let dict = data["maxBid"] as? [String:Any] {
                    if let str = dict["message"] as? String {
                        strMsg = str
                    }
                }
            }
            self.delegate?.didAddBid(status: status, msg: strMsg)
        }


        socket.on("currentBid") { data, ack in
            guard let data = data.first as? [String: Any] else { return }
            let bidderData = data["data"] as? [String: Any] ?? [String: Any]()
            let bidderInfo = CurrentBidItem(dict: bidderData)
            let maxBid = data["maxBid"] as? Double ?? 0
            self.delegate?.currentBid(maxBid: Double(maxBid), maxBidUser: bidderInfo)
        }
        

        socket.on("markAsSold") { data, ack in
            guard let data = data.first as? [String: Any] else { return }
            let status = data["status"] as? Bool ?? false
            
            self.delegate?.markAsSold(status: status, maxBidUser: nil)
        }

        socket.on("markAsUnsold") { data, ack in
            guard let data = data.first as? [String: Any] else { return }
            let status = data["status"] as? Bool ?? false
            self.delegate?.markAsUnSold(status: status, maxBidUser: nil)
        }

        
        
        socket.on("leaveBidding") { data, ack in
            guard let data = data.first as? [String: Any] else { return }
            let status = data["status"] as? Bool ?? false
            self.delegate?.leaveBidding(status: status)
        }
        
        
        socket.on("endBidding") { data, ack in
            guard let data = data.first as? [String: Any] else { return }
            let status = data["status"] as? Bool ?? false
            self.delegate?.endBidding(status: status)
        }
        
        
        socket.on("BidsMade") { data, ack in
            guard let allData = data.first as? [[String: Any]] else { return }
            var allBids = [BidMadeUser]()
            
            allData.forEach { bidderData in
                let bidderInfo = BidMadeUser(dictionary: bidderData)
                allBids.append(bidderInfo)
            }
            
            self.delegate?.bidsMade(allBiders: allBids)
        }
    }
    
    func connectSocket(){
        print("DEBUG:- called connectSocket")
        if socket.status != .connected{
            print("DEBUG:- connectSocket initiated")
            socket.connect()
            
            socket.on("connect") {data, ack in
                print("DEBUG:- Socket Connection Established!")
            }
            
            socket.on("disconnect") {data, ack in
                print("DEBUG:- Socket Disconnected!")
            }
        }
    }
    
    func disconnectSocket(){
        socket.disconnect()
    }
    
    func joinBiddingRoom(forPostId postId: String, type: BiddingRoomConnectionType) {
        let param = ["PostId": postId, "type": type.rawValue]
        
        socket.emit("joinBiddingRoom", param)
    }
    
    func getLiveUser() {
        socket.emit("liveUsers")
    }
    
    func addBid(amount: Double, toPostId postId: String) {
        let param = ["Price": amount, "PostId": postId, "UserId": loggedInUser!.id] as [String: Any]
        socket.emit("addBid", param)
    }
    
    func getCurrentBid() {
        socket.emit("currentBid")
    }
    
    
    func markAsSold(forPostId postId: String) {
        let param = ["roomId": postId] as [String: Any]
        socket.emit("markAsSold", param)
    }
    
    func leaveBidding(forPostId postId: String) {
        let param = ["PostId": postId] as [String: Any]
        socket.emit("leaveBidding", param)
    }
    
    func endBidding(forPostId postId: String) {
        let param = ["PostId": postId] as [String: Any]
        socket.emit("endBidding", param)
    }
    
    func sendComment(forRoomId roomId: String, comment:String) {
        let param = ["roomId": roomId, "text" : comment] as [String: Any]
        socket.emit("comment", param)
    }
    
    func maskAsSold(forPostId postId: String) {
        var params: [String : Any] = [:]
        params["PostId"] = postId
        socket.emit("markAsSold", params)
    }
    
    func markAsUnSold(forPostId postId: String) {
        var params: [String : Any] = [:]
        params["PostId"] = postId
        params["roomId"] = postId
        socket.emit("markAsUnsold", params)
    }
    
    
    func sharePost(toUser:String, postId:String) {
        var params: [String : String] = [:]
        params["targetUserId"] = toUser
        params["postId"] = postId
        params["text"] = ""
        socket.emit("new message", with: [params]) {
            Utility.showISMessage(str_title: "", Message: "Sent Successfully.", msgtype: .success)
        }
    }

}


class CommentObject : NSObject {
    var roomId : String = ""
    var text : String = ""
    var userId : String = ""
    var image : String = ""
    var packageMinutes : String = ""
    var userName : String = ""
    
    override init() {
        
    }

    init(dict : [String:Any]) {
        self.roomId = "\(dict["roomId"] ?? "")"
        self.text = "\(dict["text"] ?? "")"
        
        if let d = dict["user"] as? [String:Any] {
            self.userId = "\(d["id"] ?? "")"
            self.image = "\(d["image"] ?? "")"
            self.packageMinutes = "\(d["packageMinutes"] ?? "")"
            self.userName = "\(d["userName"] ?? "")"
        }
    }
    
}
