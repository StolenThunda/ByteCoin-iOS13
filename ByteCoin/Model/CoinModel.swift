//
//  CoinData.swift
//  ByteCoin
//
//  Created by Antonio Moses on 1/15/21.
//  Copyright © 2021 The App Brewery. All rights reserved.
//

import Foundation

struct CoinModel {
  let rate: Float
  let toCurrency: String
  let fromCurrency: String
  let currencyFormatter = NumberFormatter()
  
  init(rate: Float = 0.0, toCurrency: String, fromCurrency: String) {
    currencyFormatter.usesGroupingSeparator = true
    currencyFormatter.numberStyle = .currency
    currencyFormatter.locale = Locale.current
    self.rate = rate
    self.toCurrency = toCurrency
    self.fromCurrency = fromCurrency
  }

  var rateString: String {
    let nsRate = NSNumber(value: rate)
    let formattedRate = currencyFormatter.string(from: nsRate) ?? ""
    print("rate: \(rate)")
    print("NSRate: \(nsRate)")
    print("Formatted: \(formattedRate)")
    return formattedRate 
//    return String(format: "%.2f", rate)
  }
}
