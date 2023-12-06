//
//  ItemMedia.swift
//  Zeed
//
//  Created by Shrey Gupta on 19/04/21.
//

import Foundation

struct ItemMedia: Codable {
    let id: String
    let url: String
    let type: String
    let createdAt: Date
    
    init() {
        self.id = ""
        self.url = ""
        self.type = ""
        self.createdAt = Date()
    }
    
    init(dict: [String: Any]) {
        self.id = dict["id"] as? String ?? ""
        self.url = dict["url"] as? String ?? ""
        self.type = dict["type"] as? String ?? ""
        
        let createdAtInt = dict["createdAt"] as? Int ?? 0
        self.createdAt = Date(timeIntervalSince1970: TimeInterval(createdAtInt))
    }
}
