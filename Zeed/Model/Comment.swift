//
//  Comment.swift
//  Zeed
//
//  Created by Shrey Gupta on 13/03/21.
//

import Foundation

struct Comment {
    let id: String
    let type: String
    let text: String
    let postId: String
    let CommentId: String
    let owner: User
    let childComments: [Comment]
    let liked: Bool
    var likeCount: Int
    let isAuthor: Bool
    let createdAt: Date
    
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.type = dictionary["type"] as? String ?? ""
        self.text = dictionary["text"] as? String ?? ""
        self.postId = dictionary["PostId"] as? String ?? ""
        self.CommentId = dictionary["CommentId"] as? String ?? ""
        
        let userData = dictionary["User"] as? [String: Any] ?? [String: Any]()
        self.owner = Zeed.User(dictionary: userData)
        self.owner.userName.lowercased()
        
        
        let allChildData = dictionary["child"] as? [[String: Any]] ?? [[String: Any]]()
        var allChilds = [Comment]()
        allChildData.forEach { (childData) in
            let child = Comment(dictionary: childData)
            allChilds.append(child)
        }
        self.childComments = allChilds
        
        self.liked = dictionary["liked"] as? Bool ?? false
        self.likeCount = dictionary["likeCount"] as? Int ?? 0
        self.isAuthor = dictionary["isAuthor"] as? Bool ?? false
        
        let createdAtInt = dictionary["createdAt"] as? Int ?? 0
        self.createdAt = Date(timeIntervalSince1970: TimeInterval(createdAtInt))
    }
}
