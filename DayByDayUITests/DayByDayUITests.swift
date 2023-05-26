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
        deleteNote(app)
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
    
    // MARK: Calendar tests
    
    func testOpenCalendar() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["CalendarButton"].tap()
        
        XCTAssertEqual(app.otherElements["CalendarView"].exists, true)
    }
    
    // MARK: Note tests
    
    func testOpenNote() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["NoteButton"].tap()
        
        XCTAssertEqual(app.textViews["NoteTextEditor"].exists, true)
    }
    
    func testWriteAndDeleteNote() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Open editor
        app.buttons["NoteButton"].tap()

        // Type note
        let noteEditor = app.textViews["NoteTextEditor"]
        noteEditor.tap()
        UIPasteboard.general.string = "Test Content"
        noteEditor.doubleTap()
        app.menuItems["Paste"].tap()

        // Close editor
        app.buttons["NoteCloseButton"].tap()
        
        XCTAssertEqual(app.buttons["NoteTextView"].label, "Test Content")
        
        // Delete text through context menu
        let noteText = app.buttons["NoteTextView"]
        noteText.press(forDuration: 1.0)
        let deleteButton = app.buttons["NoteDeleteContextButton"]
        XCTAssert(deleteButton.waitForExistence(timeout: 1.0), "Expecting context menu to appear")
        deleteButton.tap()
        
        XCTAssertEqual(app.buttons["Test Content"].exists, false)
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
    
    func deleteNote(_ app: XCUIApplication) {
        if app.buttons["NoteTextView"].exists {
            let noteText = app.buttons["NoteTextView"]
            noteText.press(forDuration: 0.5)
            app.buttons["NoteDeleteContextButton"].tap()
        }
    }
}
