//
//  One_Rep_MaxUITests.swift
//  One Rep MaxUITests
//
//  Created by Nick Hayward on 3/24/21.
//

import XCTest

class One_Rep_MaxUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
    }
    
        func testDetailSegue() {
        app.launch()
        
        let element = app.tables.children(matching: .cell).element(boundBy: 0).staticTexts["Back Squat"]
        element.tap()
        
        XCTAssertTrue(app.staticTexts["Back Squat"].exists)
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
