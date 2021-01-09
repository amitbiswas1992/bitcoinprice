//
//  UserDefaultsManager.swift
//  BitCoinPices
//
//  Created by Amit Biswas on 01/9/21.
//

import Foundation

class UserDefaultsManager {
    
    private let userDefaults = UserDefaults.standard
    static var shared = UserDefaultsManager()
    
    private init () { }
    
    static let previousPricesUSD = "previousTwoWeekspricesUSD.json"
    static let previousPricesGBP = "previousTwoWeekspricesGBP.json"
    static let previousPricesEUR = "previousTwoWeekspricesEUR.json"
    static let currentPricesUSD = "locallypricesUSD.json"
    static let currentPricesGBP = "locallypricesGBP.json"
    static let currentPricesEUR = "locallypricesEUR.json"
    
    
    func savePriceListOfPreviousTwoWeek(_ pricesList: [BitCointList], forKey: String) {
        do {
            let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: pricesList, requiringSecureCoding: false)
            userDefaults.setValue(encodedData, forKey: forKey)
            userDefaults.synchronize()
        } catch {  }
        
    }

    func getPriceListOfPreviousTwoWeek(forKey: String) -> [BitCointList]  {
        if let data = userDefaults.value(forKey: forKey) as? Data {
            do {
                let array = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
                if let savedPrices = array as? [BitCointList] {
                    return savedPrices
                }
                
            } catch { }
        }
        return [BitCointList]()
    }
    
    func saveCurrentPrice(_ pricesList: [BitCointList], forkey: String) {
        
        do {
            let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: pricesList, requiringSecureCoding: false)
            userDefaults.setValue(encodedData, forKey: forkey)
            userDefaults.synchronize()
        } catch {  }
        
    }

    func getCurrentPrice(for key: String) -> [BitCointList]  {
        if let data = userDefaults.value(forKey: key) as? Data {
            do {
                let array = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
                if let savedPrices = array as? [BitCointList] {
                    return savedPrices
                }
                
            } catch { }
        }
        return [BitCointList]()
    }
    

}
