//
//  NetworkManager.swift
//  BitCoinPices
//
//  Created by Amit Biswas on 01/8/21.
//


import UIKit


enum CustomError: String, Error {
    case invalidURL    = "This url is not valid"
    case invalidUsername = "This username created an invalid request"
    case unableToComplete = "Unable to complete request, please check your internet connection"
    case invalidResponse = "Invalid respond from the server. Please try again."
    case invalidData = "The data recieved from the server was invalid"
}

typealias BitCointAllPricesTupe = (usd: BitCointList, eur: BitCointList, gbp: BitCointList)

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init(){}
    
    func getPastTwoWeekPrices(forCurrency: String,
                              startDate: String,
                              endDate: String,
                              completed: @escaping (_ bitCointPriceList: Result<[BitCointList], CustomError> ) -> Void) {
        
        let endpoint = String.init(format: "https://api.coindesk.com/v1/bpi/historical/close.json?currency=%@&start=%@&end=%@",
                                   forCurrency, startDate, endDate)
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidURL))
            
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data else {
                completed(.failure(.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
                    completed(.failure(.invalidData))
                    return
                }
                
                if let jsonBpiArray = json["bpi"] as? [String: Any] {
                    var listArray = [BitCointList]()
                    for (_, value) in jsonBpiArray.enumerated() {
                        
                        let price = String(value.value as? Double ?? 0.0)
                        
                        let date = value.key.toDate(withFormat: "yyyy-MM-dd") ?? Date()
                        let dateString = date.toString(withFormat: "MMM d, yyyy")
                        
                        let bitCoin = BitCointList(date: dateString, price: price, originalDate: date)
                        listArray.append(bitCoin)
                    }
                    
                    
                    completed(.success(listArray.sorted { (obj1, obj2) -> Bool in
                        return obj1.originalDate > obj2.originalDate
                    }))
                }
                
            }
            catch {
                completed(.failure(.invalidResponse))
                return
            }
        }
        
        
        task.resume()
    }

    
    func getCurrentPrice(completed: @escaping (_ bitCointPriceList: Result< BitCointAllPricesTupe, CustomError> ) -> Void) {
        
        let endpoint = "https://api.coindesk.com/v1/bpi/currentprice.json"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidURL))
            
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data else {
                completed(.failure(.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
                    completed(.failure(.invalidData))
                    return
                }
                
                if let jsonBpiArray = json["bpi"] as? [String: Any],
                   let euroPrice = jsonBpiArray["EUR"] as? [String: Any],
                   let gbpPrice = jsonBpiArray["GBP"] as? [String: Any],
                   let usdPrice = jsonBpiArray["USD"] as? [String: Any] {
                    
                    let euroPriceInFloat = euroPrice["rate"] as? String ?? ""
                    let gbpPriceInFloat = gbpPrice["rate"] as? String ?? ""
                    let usdPriceInFloat = usdPrice["rate"] as? String ?? ""
                    
                    let eurobitcointList = BitCointList(date: "Today", price: euroPriceInFloat, originalDate: Date())
                    let gbpbitcointList = BitCointList(date: "Today", price: gbpPriceInFloat, originalDate: Date())
                    let usdbitcointList = BitCointList(date: "Today", price: usdPriceInFloat, originalDate: Date())
                    
                    completed(.success((eurobitcointList,gbpbitcointList,usdbitcointList)))
                }
                
            }
            catch {
                completed(.failure(.invalidResponse))
                return
            }
        }
        
        
        task.resume()
    }

}

