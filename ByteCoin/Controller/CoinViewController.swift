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
  @IBOutlet weak var pckCurrency: UIPickerView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  var coinManager = CoinManager()
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    pckCurrency.dataSource = self
    pckCurrency.delegate = self
    coinManager.delegate = self
    
    activityIndicator.hidesWhenStopped = true
    activityIndicator.startAnimating()
    
    self.activityIndicator.stopAnimating()
    
    // select first picker value
    let selected = self.coinManager.currencyArray[0]
    self.coinManager.getCoinPrice(for: selected)
    self.lblCurrency.text = selected
    
    
    
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
    self.activityIndicator.stopAnimating()
    print(error.localizedDescription)
  }
}

// MARK: - UIPickerViewDataSource

extension CoinViewController: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return coinManager.currencyArray.count
  }
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return coinManager.currencyArray[row]
  }
}

// MARK: - UIPickerViewDelegate
extension CoinViewController: UIPickerViewDelegate {
  
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    let selected = coinManager.currencyArray[row]
    coinManager.getCoinPrice(for: selected)
    lblCurrency.text = selected
    activityIndicator.startAnimating()
  }
}
