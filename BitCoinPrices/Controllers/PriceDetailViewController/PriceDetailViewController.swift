//
//  PriceDetailViewController.swift
//  BitCoinPices
//
//  Created by Amit Biswas on 01/8/21.
//


import UIKit

class PriceDetailViewController: UIViewController {

    
    var bitCoinPrice: BitCoinPrice?
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var euroPriceLabel: UILabel!
    @IBOutlet weak var gbpPriceLabel: UILabel!
    @IBOutlet weak var usdPriceLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeData()
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
}


extension PriceDetailViewController {
    
    public func initializeData() {
        
        self.title = self.bitCoinPrice?.date
        dateLabel.text = self.bitCoinPrice?.date
        euroPriceLabel.text = "€ " + (self.bitCoinPrice?.eurPrice ?? "")
        gbpPriceLabel.text = "£ " + (self.bitCoinPrice?.gbpPrice ?? "")
        usdPriceLabel.text = "$ " + (self.bitCoinPrice?.usdPrice ?? "")
    }
    
}
