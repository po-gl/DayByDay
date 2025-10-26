//
//  DayByDayUITestsLaunchTests.swift
//  DayByDayUITests
//
//  Created by Porter Glines on 1/7/23.
//

import XCTest

final class DayByDayUITestsLaunchTests: XCTestCase {

  override class var runsForEachTargetApplicationUIConfiguration: Bool {
    true
  }

  override func setUpWithError() throws {
    continueAfterFailure = false
  }

  override func tearDownWithError() throws {
    let app = XCUIApplication()
    setDayState(on: false, app)
  }

  func testLaunchScreen() throws {
    let app = XCUIApplication()
    app.launch()

    let attachment = XCTAttachment(screenshot: app.screenshot())
    attachment.name = "Launch Screen"
    attachment.lifetime = .keepAlways
    add(attachment)
  }

  func testCompleteScreen() throws {
    let app = XCUIApplication()
    app.launch()

    setDayState(on: true, app)

    let attachment = XCTAttachment(screenshot: app.screenshot())
    attachment.name = "Completed Screen"
    attachment.lifetime = .keepAlways
    add(attachment)
  }

  func testPastViewScreen() throws {
    let app = XCUIApplication()
    app.launch()

    app.swipeUp(velocity: .init(1000))

    let attachment = XCTAttachment(screenshot: app.screenshot())
    attachment.name = "PastView Screen"
    attachment.lifetime = .keepAlways
    add(attachment)
  }

  func testCalendarScreen() throws {
    let app = XCUIApplication()
    app.launch()

    app.buttons["CalendarButton"].tap()

    let attachment = XCTAttachment(screenshot: app.screenshot())
    attachment.name = "Calendar Screen"
    attachment.lifetime = .keepAlways
    add(attachment)
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
