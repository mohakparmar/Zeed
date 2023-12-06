//
//  CreateItemVarient.swift
//  Zeed
//
//  Created by Shrey Gupta on 30/03/21.
//

import Foundation

struct CreateItemVariant {
    
    private var variantOne: ItemAttribute? = nil
    private var variantTwo: ItemAttribute? = nil
    private var price: Double = 0
    private var quantity: Int = 0
    
    func getVariantOne() -> ItemAttribute? {
        return variantOne
    }
    
    func getVariantTwo() -> ItemAttribute? {
        return variantTwo
    }
    
    mutating func setVariantOne(variant: ItemAttribute) -> (Bool, String?) {
        if variant.selectedOption?.parentAttributeId == variantTwo?.selectedOption?.parentAttributeId {
            return (false, "You cannot select same attribute type for both variants.")
        }
        
        self.variantOne = variant
        
        return (true, nil)
    }
    
    mutating func setVariantTwo(variant: ItemAttribute) -> (Bool, String?) {
        if variantOne?.selectedOption?.parentAttributeId == variant.selectedOption?.parentAttributeId {
            return (false, "You cannot select same attribute type for both variants.")
        }
        
        self.variantTwo = variant
        
        return (true, nil)
    }
    
    mutating func setPrice(price: Double) {
        self.price = price
    }
    
    func getPrice() -> Double {
        return price
    }
    
    mutating func setQuantity(quantity: Int) {
        self.quantity = quantity
    }
    
    func getQuantity() -> Int {
        return quantity
    }
    
    
    
    
//
//    static func == (lhs: CreateItemVarient, rhs: CreateItemVarient) -> Bool {
//        var lhsLowercasedAttributes = [String]()
//        lhs.attributes.forEach { (attribute) in
//            lhsLowercasedAttributes.append(attribute.lowercased())
//        }
//
//        var rhsLowercasedAttributes = [String]()
//        rhs.attributes.forEach { (attribute) in
//            rhsLowercasedAttributes.append(attribute.lowercased())
//        }
//
//        for index in 0 ..< lhsLowercasedAttributes.count {
//            if lhsLowercasedAttributes[index] != rhsLowercasedAttributes[index] {
//                return false
//            }
//        }
//
//        return true
//    }
}
