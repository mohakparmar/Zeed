//
//  AddressItem.swift
//  Zeed
//
//  Created by Shrey Gupta on 14/05/21.
//

import Foundation

enum AddressType: String {
    case home = "Home"
    case work = "Work"
    case other = "Other"
}


struct Address: Equatable {
    static func == (lhs: Address, rhs: Address) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: String
    var name: String
    var addressLine1: String
    var addressLine2: String
    var road: String
    var landmark: String
    var block: String
    var street: String
    var avenue: String
    var floor: String
    var flat: String
    var direction: String
    var mobileNumber: String
    var alternateMobileNumber: String
    var defaultAddress: Bool
    var latitude: Double
    var longitude: Double
    var active: Bool
    var createdAt: Date
    var userId: String
    var addressType: AddressType
    var city: AddressCity
    var apartment: String
    
    init(dict: [String: Any]) {
        print(dict)
        
        self.id = dict["id"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
        self.addressLine1 = dict["address_line_1"] as? String ?? ""
        self.addressLine2 = dict["address_line_2"] as? String ?? ""
        self.landmark = dict["landmark"] as? String ?? ""
        self.direction = dict["direction"] as? String ?? ""
        self.mobileNumber = dict["mobile"] as? String ?? ""
        self.apartment = dict["apartment"] as? String ?? ""

        let labelString = dict["label"] as? String ?? ""
        self.addressType = AddressType(rawValue: labelString) ?? .other
        
        self.alternateMobileNumber = dict["alternate_mobile"] as? String ?? ""
        self.defaultAddress = dict["default"] as? Bool ?? false
        self.latitude = dict["lat"] as? Double ?? 0
        self.longitude = dict["long"] as? Double ?? 0

        self.road = dict["road"] as? String ?? ""
        self.block = dict["block"] as? String ?? ""
        self.street = dict["street"] as? String ?? ""
        self.avenue = dict["avenue"] as? String ?? ""
        self.floor = dict["floor"] as? String ?? ""
        self.flat = dict["flat"] as? String ?? ""
        self.active = dict["active"] as? Bool ?? false
        let createdAtInt = dict["createdAt"] as? Int ?? 0
        self.createdAt = Date(timeIntervalSince1970: TimeInterval(createdAtInt))
        self.userId = dict["UserId"] as? String ?? ""
        let cityDict = dict["City"] as? [String: Any] ?? [String: Any]()
        self.city = AddressCity(dict: cityDict)
    }
    
    func getAddressSummaryString() -> String {
        if landmark != "" {
            return "\(addressLine1), \(addressLine2)\n\(landmark + ", ")\n\(city.name), \(city.state.name), \(city.state.country.name)"
        } else {
            return "\(addressLine1), \(addressLine2)\n\(city.name), \(city.state.name), \(city.state.country.name)"
        }
    }
    
    func getAddressString() -> String {
        var str : String = ""
        str = String(format: "%@, %@, %@, Block %@, Street %@, House no %@, Floor %@, Avenue %@, Apartment: %@, Direction : %@", city.state.country.name, city.state.name, city.name, block, street, flat, floor, avenue, apartment, direction)
        return str
    }
}

struct AddressCity {
    let id: String
    let name: String
    let name_ar: String
    let status: Bool
    let visibility: Bool
    let createdAt: Date
    let state: AddressState
    
    init(dict: [String: Any]) {
        self.id = dict["id"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
        self.name_ar = dict["name_ar"] as? String ?? ""
        self.status = dict["status"] as? Bool ?? false
        self.visibility = dict["visibility"] as? Bool ?? false
        
        let stateData = dict["State"] as? [String: Any] ?? [String: Any]()
        self.state = AddressState(dict: stateData)
        
        let createdAtInt = dict["createdAt"] as? Int ?? 0
        self.createdAt = Date(timeIntervalSince1970: TimeInterval(createdAtInt))
    }
}

struct AddressState {
    let id: String
    let name: String
    let name_ar: String
    let status: Bool
    let visibility: Bool
    let createdAt: Date
    let country: AddressCountry
    
    init(dict: [String: Any]) {
        self.id = dict["id"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
        self.name_ar = dict["name_ar"] as? String ?? ""
        self.status = dict["status"] as? Bool ?? false
        self.visibility = dict["visibility"] as? Bool ?? false
        
        let countryData = dict["Country"] as? [String: Any] ?? [String: Any]()
        self.country = AddressCountry(dict: countryData)
        
        let createdAtInt = dict["createdAt"] as? Int ?? 0
        self.createdAt = Date(timeIntervalSince1970: TimeInterval(createdAtInt))
    }
}

struct AddressCountry {
    let id: String
    let name: String
    let name_ar: String
    let status: Bool
    let currency: String
    let createdAt: Date
    
    init(dict: [String: Any]) {
        self.id = dict["id"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
        self.name_ar = dict["name_ar"] as? String ?? ""
        self.status = dict["status"] as? Bool ?? false
        self.currency = dict["currency"] as? String ?? ""
        
        let createdAtInt = dict["createdAt"] as? Int ?? 0
        self.createdAt = Date(timeIntervalSince1970: TimeInterval(createdAtInt))
    }
}


class CategoryObject {
    let id: String
    let name: String
    let name_ar: String
    let status: Bool
    var isSelected: Bool = false

    init(dict: [String: Any]) {
        self.id = dict["id"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
        self.name_ar = dict["name_ar"] as? String ?? ""
        self.status = dict["status"] as? Bool ?? false
    }
}

