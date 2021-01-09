//
//  BitCointList.swift
//  BitCoinPices
//
//  Created by Amit Biswas on 01/8/21.
//


import Foundation


class BitCointList: NSObject, NSCoding {
    
    var date: String
    var price: String
    var originalDate: Date
    
    init(date: String, price: String,originalDate: Date) {
        self.date = date
        self.price = price
        self.originalDate = originalDate
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let date = aDecoder.decodeObject(forKey: "date") as? String ?? ""
        let price = aDecoder.decodeObject(forKey: "price") as? String ?? ""
        let originalDate = aDecoder.decodeObject(forKey: "originalDate") as? Date ?? Date()
        self.init(date: date, price: price, originalDate: originalDate)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: "date")
        aCoder.encode(price, forKey: "price")
        aCoder.encode(originalDate, forKey: "originalDate")
    }
    
}
