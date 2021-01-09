//
//  BitCoinPrice.swift
//  BitCoinPices
//
//  Created by Amit Biswas on 01/8/21.
//


import UIKit


class BitCoinPrice {
        
    var usdPrice: String?
    var date: String?
    var eurPrice: String?
    var gbpPrice: String?
    
    init(usd: String, gbp: String, eur: String, date: String) {
        self.usdPrice = usd
        self.gbpPrice = gbp
        self.eurPrice = eur
        self.date = date
    }
    
    
}

