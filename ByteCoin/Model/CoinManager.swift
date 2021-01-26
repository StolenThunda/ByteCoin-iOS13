//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
  func didRetrieveData(_ coinManager: CoinManager, data: CoinModel)
  func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "998B24CC-AA4F-41F7-AEF6-54428AE1F59A"
    var delegate: CoinManagerDelegate?
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
  
  func getCoinPrice(for currency: String) {
    let urlString = "\(baseURL)/\(currency)?apiKey=\(apiKey)"
    print("Get price for \(currency) with \(urlString)")
    performRequest(with: urlString)
  }
  func performRequest(with urlString: String)  {
    // 1. create url if string is present
    if let url = URL(string: urlString) {
      // 2. create URLSession
      let session = URLSession(configuration: .default)
      
      // 3. create task
      let task = session.dataTask(with: url) { (data, response, err) in
        if err != nil {
          self.delegate?.didFailWithError(error: err!)
          return
        }
        if let safeData = data {
          if let coinData = self.parseJSON(safeData) {
            self.delegate?.didRetrieveData(self, data: coinData)
          }
        }
      }
      
      // 4. start task
      task.resume()
    }
  }
  
  func parseJSON(_ coinData: Data) -> CoinModel? {
    let decoder = JSONDecoder()
    do {
      let decodedData = try decoder.decode(CoinData.self, from: coinData)
      _ = decodedData.time
      let from = decodedData.asset_id_base
      let to = decodedData.asset_id_quote
      let rate = decodedData.rate
      
      print("parsing data for: \(rate)")
      return CoinModel(rate: rate, toCurrency: to, fromCurrency: from)
    } catch {
      delegate?.didFailWithError(error: error)
    }
    return nil
  }
    
}
