//
//  Date+compare.swift
//  DayByDay
//
//  Created by Porter Glines on 1/8/23.
//

import Foundation

extension Date {

  func distance(from date: Date, only component: Calendar.Component, calendar: Calendar = .current)
    -> Int
  {
    let end = calendar.component(component, from: self)
    let begin = calendar.component(component, from: date)
    return end - begin
  }

  func hasSame(_ component: Calendar.Component, as date: Date) -> Bool {
    return distance(from: date, only: component) == 0
  }

  func isSameDay(as date: Date) -> Bool {
    let sameDay = distance(from: date, only: .day) == 0
    let sameMonth = distance(from: date, only: .month) == 0
    let sameYear = distance(from: date, only: .year) == 0
    return sameDay && sameMonth && sameYear
  }

  func isMonday(calendar: Calendar = .current) -> Bool {
    return calendar.component(.weekday, from: self) == 2
  }

  func isToday(calendar: Calendar = .current) -> Bool {
    return self.isSameDay(as: Date())
  }

  func isInPast(calendar: Calendar = .current) -> Bool {
    return self.timeIntervalSinceNow < 0.0
  }

  func atHour(_ hour: Double, calendar: Calendar = .current) -> Date {
    var safeHour: Double
    if hour < 0 {
      safeHour = 24 + min(max(-24, hour), -0.1)
    } else {
      safeHour = min(max(0, hour), 23.9)
    }
    return calendar.startOfDay(for: self).addingTimeInterval(safeHour * 60 * 60)
  }

  func at(hour: Int, minute: Int, calendar: Calendar = .current) -> Date {
    let hour = hour.clamped(to: 0...24) * 60 * 60
    let minute = minute.clamped(to: 0...59) * 60
    return calendar.startOfDay(for: self).addingTimeInterval(TimeInterval(hour + minute))
  }
}
