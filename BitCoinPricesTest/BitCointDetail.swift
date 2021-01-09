//
//  BitCointDetail.swift
//  BitCoinPricesTest
//
//  Created by Amit Biswas on 01/9/21.
//


import XCTest
@testable import BitCoinPices

class BitCointDetail: XCTestCase {

    var viewControllerUnderTest: PriceDetailViewController?
    var bitCoinPriceDummyData = BitCoinPrice(usd: "1223.12", gbp: "1311.12", eur: "12123.12", date: "7 Jan, 2012")
    
    override func setUp() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.viewControllerUnderTest = storyboard.instantiateViewController(withIdentifier: "priceDetailViewController") as? PriceDetailViewController
        
        self.viewControllerUnderTest?.bitCoinPrice = bitCoinPriceDummyData
        self.viewControllerUnderTest?.loadView()
        self.viewControllerUnderTest?.viewDidLoad()
    }

    override func tearDown() {
        super.tearDown()
    }

    
    func testHasAEuroPriceLabel() {
        XCTAssertNotNil(viewControllerUnderTest?.euroPriceLabel)
    }
    
    func testHasAEuroGBPPriceLabel() {
        XCTAssertNotNil(viewControllerUnderTest?.gbpPriceLabel)
    }
    
    func testHasAEuroUSDPriceLabel() {
        XCTAssertNotNil(viewControllerUnderTest?.usdPriceLabel)
    }
    
    func testHasCorrectUSDValue() {
        XCTAssertEqual(viewControllerUnderTest?.usdPriceLabel.text ?? "", "$ 1223.12")
    }
    
    func testHasCorrectGBPValue() {
        XCTAssertEqual(viewControllerUnderTest?.gbpPriceLabel.text ?? "", "£ 1311.12")
    }
    
    func testHasCorrectEURValue() {
        XCTAssertEqual(viewControllerUnderTest?.euroPriceLabel.text ?? "", "€ 12123.12")
    }

    

}
