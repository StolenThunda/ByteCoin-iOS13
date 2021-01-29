//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class CoinViewController: UIViewController {
  @IBOutlet weak var lblBitCoin: UILabel!
  @IBOutlet weak var lblCurrency: UILabel!
  @IBOutlet weak var toCurrency: UIPickerView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  @IBOutlet weak var fromCurrency: UIPickerView!
  var coinManager = CoinManager()
  var currencySelected: String? = nil
  var cryptoSelected: String? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()    
    coinManager.delegate = self
    // Do any additional setup after loading the view.
    toCurrency.dataSource = self
    toCurrency.delegate = self
    toCurrency.tag = 2
    
    fromCurrency.delegate = self
    fromCurrency.dataSource = self
    fromCurrency.tag = 1
    
    activityIndicator.hidesWhenStopped = true
    activityIndicator.startAnimating()
    
    self.activityIndicator.stopAnimating()
    
    // select first picker value
    //    let selected = self.coinManager.currencyArray[0]
    //    self.coinManager.getCoinPrice(for: selected)
    //    self.lblCurrency.text = selected
  }
  
  @IBAction func getRatePressed(_ sender: UIButton) {
    let crypto = cryptoSelected ?? coinManager.cryptoCurrency[fromCurrency.selectedRow(inComponent: 0)]
    let currency = currencySelected ?? coinManager.cryptoCurrency[toCurrency.selectedRow(inComponent: 1)]
   
    coinManager.getCoinPrice(from: crypto, to: currency)
    lblCurrency.text = currencySelected
    activityIndicator.startAnimating()
    
  }
}

// MARK: - CoinManagerDelegate

extension CoinViewController: CoinManagerDelegate {
  func didRetrieveData(_: CoinManager, data: CoinModel) {
    DispatchQueue.main.async {
      self.lblBitCoin.text = data.rateString
      self.activityIndicator.stopAnimating()
    }
  }
  
  func didFailWithError(error: Error) {
    DispatchQueue.main.async {
      self.activityIndicator.stopAnimating()
      print(error.localizedDescription)
    }
  }
}

// MARK: - UIPickerViewDataSource

extension CoinViewController: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//    switch pickerView.tag {
//    case 1:
      return coinManager.cryptoCurrency.count
//    case 2:
//      return coinManager.currencyArray.count
//    default:
//      return 1
//    }
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//    switch pickerView.tag {
//    case 1:
      return coinManager.cryptoDescriptions[row]
//    case 2:
//      return coinManager.currencyArray[row]
//    default:
//      return "ERROR"
//    }
//
  }
}

// MARK: - UIPickerViewDelegate
extension CoinViewController: UIPickerViewDelegate {
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    switch pickerView.tag {
    case 1:
      cryptoSelected = coinManager.cryptoCurrency[row]
    case 2:
      currencySelected = coinManager.cryptoCurrency[row]
    default:
      print("ERROR")
    }
  }
}

