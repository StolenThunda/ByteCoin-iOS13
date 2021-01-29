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
  
  let baseURL = "https://rest.coinapi.io/v1/exchangerate/"
  let apiKey = "998B24CC-AA4F-41F7-AEF6-54428AE1F59A"
  var delegate: CoinManagerDelegate?
  let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
  let cryptoDescriptions =  ["Bitcoin (BTC)", "Ethereum (ETH)", "Ripple (XRP)", "Litecoin (LTC)", "Cardano (ADA)", "Bitcoin Cash (BCH)", "Polkadot (DOT)", "Stellar (XLM)", "Chainlink (LINK)", "USD Coin (USDC)", "Blackcoin (BLK)", "Dash (DASH)", "Dogecoin (DOGE)", "Emercoin (EMC)", "Feathercoin (FTC)", "Namecoin (NMC)", "Peercoin (PPC)", "Reddcoin (RDD)", "Monero (XMR)", "Zcash (ZEC)", "US Dollar (USD)", "Canadian Dollar (CAD)", "UK Pound (GBP)", "Euro (EUR)",  "Russian Ruble (RUR)", "Ukrainian Hryvnia (UAH)", "Bitcoin (BTC)", "Ethereum (ETH)", "Ripple (XRP)", "Litecoin (LTC)", "Cardano (ADA)", "Japanese Yen (JPY)"]
  let cryptoCurrency = ["BTC", "ETH", "XRP", "LTC", "ADA", "BCH", "DOT", "XLM", "LINK", "USDC", "BLK", "DASH", "DOGE", "EMC", "FTC", "NMC", "PPC", "RDD", "XMR", "ZEC", "USD", "CAD", "GBP", "EUR", "JPY", "RUR", "UAH", "BTC", "ETH", "XRP", "LTC", "ADA", "BCH", "DOT", "XLM", "LINK", "USDC", "BLK", "DASH", "DOGE", "EMC", "FTC", "NMC", "PPC", "RDD", "XMR", "ZEC", "USD", "CAD", "GBP", "EUR", "JPY", "RUR", "UAH"]
  
  func getCoinPrice(from crypto: String?, to currency: String?) {
    if let safeCrypto = crypto, let safeCurrency = currency {
      let description = getCurrencyDescription(from: safeCurrency)
      let urlString = "\(baseURL)\(safeCrypto)/\(safeCurrency)?apiKey=\(apiKey)"
      print("\n\nGet \(safeCrypto) price for \(safeCurrency) \(description) \nUsing: \(urlString)")
      performRequest(with: urlString)
    }
  }
  
  func getCurrencyDescription(from currency: String) -> String {
    let filteredStrings = cryptoDescriptions.filter({(item: String) -> Bool in
      let itmLC = item.lowercased()
      let currLC = currency.lowercased()
      
      let stringMatch = itmLC.contains(currLC)
      if stringMatch {
        print("\n\nTest: \(itmLC)\nCurr: \(currLC)\nMatch?: \(stringMatch)")
      }
      return stringMatch
    })
    if filteredStrings.count > 0 {
      print("Filtered: \(filteredStrings)")
    }
    return filteredStrings.joined(separator: ",")
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
