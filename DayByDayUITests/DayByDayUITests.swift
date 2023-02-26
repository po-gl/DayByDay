//
//  DayByDayUITests.swift
//  DayByDayUITests
//
//  Created by Porter Glines on 1/7/23.
//

import XCTest

final class DayByDayUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        let app = XCUIApplication()
        setDayState(on: false, app)
    }

    func testTapButtons() throws {
        let app = XCUIApplication()
        app.launch()
        setDayState(on: false, app)
            
        for text in ["Active", "Creative", "Productive"] {
            XCTAssertEqual(app.buttons["\(text)Button_Off"].exists, true)
            app.buttons["\(text)Button_Off"].tap()
            XCTAssertEqual(app.buttons["\(text)Button_On"].exists, true)
        }
    }
    
    func testScrollToBottom() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.swipeUp(velocity: .init(5000))
        
        XCTAssertEqual(app.buttons["PastViewRow0_Col1"].isHittable, false)
        
        XCTAssertEqual(app.buttons["PastViewRow29_Col3"].isHittable, true)
    }
    
    func testOpenCalendar() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["CalendarButton"].tap()
        
        XCTAssertEqual(app.otherElements["CalendarView"].exists, true)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func setDayState(on: Bool, _ app: XCUIApplication) {
        for text in ["Active", "Creative", "Productive"] {
            let button = app.buttons["\(text)Button_\(on ? "Off" : "On")"]
            if button.exists {
                button.tap()
            }
        }
    }
}
