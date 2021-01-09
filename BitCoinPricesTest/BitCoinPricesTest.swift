//
//  BitCoinPricesTest.swift
//  BitCoinPricesTest
//
//  Created by Amit Biswas on 01/8/21.
//


import XCTest
@testable import BitCoinPices


class BitCoinPricesTest: XCTestCase {

    var viewControllerUnderTest: BitCoinPriceListingViewController?
    
    override func setUp() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.viewControllerUnderTest = storyboard.instantiateViewController(withIdentifier: "bitCoinPriceListingViewController") as? BitCoinPriceListingViewController
        
        self.viewControllerUnderTest?.loadView()
        self.viewControllerUnderTest?.viewDidLoad()
    }

    override func tearDown() {
        super.tearDown()
    }

    
    func testHasATableView() {
        XCTAssertNotNil(viewControllerUnderTest?.tableView)
    }

    func testTableViewHasDelegate() {
        XCTAssertNotNil(viewControllerUnderTest?.tableView.delegate)
    }
    
    func testTableViewHasDataSource() {
        XCTAssertNotNil(viewControllerUnderTest?.tableView.dataSource)
    }
    
    func testHasEndDateIsTrue() {
        let startDateAndEndDate = self.viewControllerUnderTest?.getStartAndEndDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let endDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        let endDateString = formatter.string(from: endDate)
        
        XCTAssertEqual(startDateAndEndDate?.end, endDateString)
    }
    
    

}
