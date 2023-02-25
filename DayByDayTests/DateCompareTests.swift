//
//  DateCompareTests.swift
//  DayByDayTests
//
//  Created by Porter Glines on 2/25/23.
//

import XCTest

final class DateCompareTests: XCTestCase {
        
    func testIsSameDay() throws {
        let date = Calendar.current.date(from: DateComponents(year: 2023, month: 1, day: 4))!
        
        let nextHour = date.addingTimeInterval(60*60)
        XCTAssertTrue(date.isSameDay(as: nextHour), "Expected true")
        
        let nextMonthDate = date.addingTimeInterval(60*60*24 * 31)
        XCTAssertTrue(date.hasSame(.day, as: nextMonthDate), "Expected true, The dates should both be the 4th of the month.")
        XCTAssertFalse(date.isSameDay(as: nextMonthDate), "Expected false")
    }

    func testIsToday() throws {
        var date = Calendar.current.startOfDay(for: Date())
        XCTAssertTrue(date.isToday())
        
        date.addTimeInterval(-1.0)
        XCTAssertFalse(date.isToday(), "Expected false. Start of day subtracted by 1 second should not be today.")
        date = Calendar.current.startOfDay(for: Date())
        
        date.addTimeInterval(60*60*24 - 1.0)
        XCTAssertTrue(date.isToday(), "Expected true. 1 second to midnight should be today.")
        date.addTimeInterval(1.0)
        XCTAssertFalse(date.isToday(), "Expected false. Midnight should not be today.")
    }
    
    func testIsMonday() throws {
        let date = Calendar.current.date(from: DateComponents(year: 2023, month: 1, day: 9))!
        XCTAssertTrue(date.isMonday(), "Expected true")
        
        let date2 = Calendar.current.date(from: DateComponents(year: 2023, month: 1, day: 14))!
        XCTAssertFalse(date2.isMonday(), "Expected false")
    }
    
    func testAtHour() throws {
        let calendar = Calendar.current
        let date = calendar.date(from: DateComponents(year: 2023, month: 1, day: 9))!
        
        let firstHourDate = date.atHour(0)
        XCTAssertTrue(date.isSameDay(as: firstHourDate))
        XCTAssertEqual(calendar.component(.hour, from: firstHourDate), calendar.component(.hour, from: calendar.date(from: DateComponents(hour: 0))!), "Expected 0 hour")
        XCTAssertTrue(date.hasSame(.hour, as: calendar.date(from: DateComponents(hour: 0))!))
        
        let lastHourDate = date.atHour(23.9)
        XCTAssertTrue(date.isSameDay(as: lastHourDate))
        XCTAssertEqual(calendar.component(.hour, from: lastHourDate), calendar.component(.hour, from: calendar.date(from: DateComponents(hour: 23))!), "Expected 23 hours")
        
        let pastDayHourDate = date.atHour(50)
        XCTAssertTrue(date.isSameDay(as: pastDayHourDate))
        XCTAssertEqual(calendar.component(.hour, from: pastDayHourDate), calendar.component(.hour, from: calendar.date(from: DateComponents(hour: 23))!), "Expected 23 hours. atHour() should keep within the same day")
        
        let negativeHourDate = date.atHour(-4)
        XCTAssertTrue(date.isSameDay(as: negativeHourDate))
        XCTAssertEqual(calendar.component(.hour, from: negativeHourDate), calendar.component(.hour, from: calendar.date(from: DateComponents(hour: 20))!), "Expected 20 hours. Starting from 24 hours minus 4")
        
        let negativePastHourDate = date.atHour(-30)
        XCTAssertTrue(date.isSameDay(as: negativePastHourDate))
        XCTAssertEqual(calendar.component(.hour, from: negativePastHourDate), calendar.component(.hour, from: calendar.date(from: DateComponents(hour: 0))!), "Expected 0 hours.")
        
        let negativeBarelyPastHourDate = date.atHour(-0.001)
        XCTAssertTrue(date.isSameDay(as: negativeBarelyPastHourDate))
        XCTAssertEqual(calendar.component(.hour, from: negativeBarelyPastHourDate), calendar.component(.hour, from: calendar.date(from: DateComponents(hour: 23))!), "Expected 23 hours.")
    }
}
