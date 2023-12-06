//
//  TimeSlot.swift
//  Zeed
//
//  Created by Shrey Gupta on 07/09/21.
//

import Foundation

struct TimeSlot {
    let id: String
    var slot: String
    let createdAt: Date
    
    init(dict: [String: Any]) {
        self.id = dict["id"] as? String ?? ""
        self.slot = dict["slot"] as? String ?? ""
        
        let createdAtInt = dict["createdAt"] as? Int ?? 0
        self.createdAt = Date(timeIntervalSince1970: TimeInterval(createdAtInt))
    }
}
