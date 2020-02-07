//
//  CroesusTests.swift
//  CroesusTests
//
//  Created by Bourne K on 03/02/2020.
//  Copyright © 2020 Triglobe Soft Solutions. All rights reserved.
//

import XCTest
@testable import Croesus

class CroesusTests: XCTestCase {
    let REQUEST_TIMEOUT = 5
    var dateFormatter:DateFormatter!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        //
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        dateFormatter = nil
    }

    func testGetSurveys() {
        //1. Given
        let kind = SurveyKind.All
        //
        let promise = expectation(description: "Fetch Survey Success")
        
        // 2. when
        //
        ApiServiceImpl.Instance.fetchSurveys({ (s, l, m) in
            //
            if !s{
                XCTFail("Test Failed.\nError: \(String(describing: m))")
            }
            promise.fulfill()
        })
        // 3. then
        //XCTAssertEqual(ReqManager.scoreRound, 95, "Sample Failure message")
         wait(for: [promise], timeout: TimeInterval(REQUEST_TIMEOUT))
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {

            //1. Given
            let kind = SurveyKind.All
            
            // Put the code you want to measure the time of here.
            let _ = DataContext.Shared.getSurveys(kind)
            
            
        }
    }

}
