//
//  DayMOTests.swift
//  DayByDayTests
//
//  Created by Porter Glines on 2/25/23.
//

import XCTest

final class DayMOTests: XCTestCase {

  let viewContext = PersistenceController.preview.container.viewContext

  func testCreation() throws {
    let day = DayMO(context: viewContext)
    XCTAssertFalse(day.active)
    XCTAssertFalse(day.creative)
    XCTAssertFalse(day.productive)
    XCTAssertNil(day.date)

    XCTAssertFalse(day.isActive(for: .active))
    XCTAssertFalse(day.isActive(for: .creative))
    XCTAssertFalse(day.isActive(for: .productive))
  }

  func testCreationWithDate() throws {
    let day = DayMO(context: viewContext)
    day.date = Date()
    XCTAssertTrue(day.date!.isToday())
  }

  func testToggle() throws {
    let day = DayMO(context: viewContext)
    day.toggle(category: .active)
    XCTAssertTrue(day.active)
    XCTAssertFalse(day.creative)
    XCTAssertFalse(day.productive)

    day.toggle(category: .active)
    XCTAssertFalse(day.active)

    day.toggle(category: .creative)
    XCTAssertTrue(day.creative)
    day.toggle(category: .productive)
    XCTAssertTrue(day.productive)
  }
}
