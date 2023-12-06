//
//  AppUser.swift
//  Zeed
//
//  Created by Shrey Gupta on 07/05/21.
//

import Foundation

class AppUser {
    static let shared = AppUser()
    
    func setDefaultUser(user: User) -> Bool {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(user)
            defaults.set(data, forKey: "USER")
            
            loggedInUser = user
            SocketService.shared.connectSocket()
            return true
        } catch {
            print("Unable to Encode User (\(error))")
            return false
        }
    }
    
    func removeDefaultUser() {
        defaults.removeObject(forKey: "USER")
        loggedInUser = nil
        SocketService.shared.disconnectSocket()
    }
    
    func getDefaultUser() -> User? {
        if let checkData = defaults.data(forKey: "USER") {
            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from: checkData)
                print(user)
                loggedInUser = user
                return user
            } catch {
                print("Unable to Decode user (\(error))")
                return nil
            }
        } else {
            return nil
        }
    }
}
