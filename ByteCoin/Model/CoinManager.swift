//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol coinPriceDelegate {
    func didUpdateRate(price: String, currency: String)
    func didFailError(error : Error)
}


struct CoinManager {
    
    //   " https://rest.coinapi.io/v1/exchangerate/BTC/USD"
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "5FE6F01B-EAD1-4D97-9CA3-FEBCD4EF3229"
    
    var delegate : coinPriceDelegate?
    
    func getCoinPrice(for  currency : String ) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        print(urlString)
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil {
                    self.delegate?.didFailError(error: error!)
                    print(error!)
                    return
                }
                //                let dataAsString = String(data: data!, encoding: .utf8)
                //                print(dataAsString ?? "empty") very important
                if let safeData = data {
                    if let price  = self.parseJSON(safeData){
                        let priceString = String(format: "%.2f", price)
                        self.delegate?.didUpdateRate(price: priceString, currency: currency)
                        print(price)
                    }
                }
            }
            task.resume()
        }
    }
    
    
    func parseJSON(_ priceData : Data) ->  Double? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(PriceData.self, from: priceData)
            let rate = decodedData.rate
            print(rate)
            return rate
        } catch {
            delegate?.didFailError(error: error)
            print(error)
            return nil
        }
    }
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
}



//import Foundation
//
//struct CoinManager {
//
//    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
//    let apiKey = "YOUR_API_KEY_HERE"
//
//    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
//
//    func getCoinPrice(for currency: String) {
//
//        //Use String concatenation to add the selected currency at the end of the baseURL along with the API key.
//        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
//
//        //Use optional binding to unwrap the URL that's created from the urlString
//        if let url = URL(string: urlString) {
//
//            //Create a new URLSession object with default configuration.
//            let session = URLSession(configuration: .default)
//
//            //Create a new data task for the URLSession
//            let task = session.dataTask(with: url) { (data, response, error) in
//                if error != nil {
//                    print(error!)
//                    return
//                }
//                //Format the data we got back as a string to be able to print it.
//                let dataAsString = String(data: data!, encoding: .utf8)
//                print(dataAsString)
//
//            }
//            //Start task to fetch data from bitcoin average's servers.
//            task.resume()
//        }
//    }
//
//}
