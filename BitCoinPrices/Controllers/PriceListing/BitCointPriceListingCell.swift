//
//  BitCointPriceListingCell.swift
//  BitCoinPices
//
//  Created by Amit Biswas on 01/8/21.
//


import UIKit

class BitCointPriceListingCell: UITableViewCell {

    @IBOutlet weak var priceValueLabel: UILabel!
    @IBOutlet weak var priceDateLabel: UILabel!
   
    @IBOutlet weak var outerView: UIView! {
        didSet {
            outerView.layer.masksToBounds = true
            outerView.layer.cornerRadius = 10
            
        }
    }
    
    
    func setData(price: String, Date: String) {
        
        
        self.priceValueLabel.text = String.init(format: "€ %@", price)
        self.priceDateLabel.text = String.init(format: "%@", Date)
    }
    
}
