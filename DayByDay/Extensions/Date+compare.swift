//
//  Date+compare.swift
//  DayByDay
//
//  Created by Porter Glines on 1/8/23.
//

import Foundation

extension Date {
    
    func distance(from date: Date, only component: Calendar.Component, calendar: Calendar = .current) -> Int {
        let end = calendar.component(component, from: self)
        let begin = calendar.component(component, from: date)
        return end - begin
    }
    
    func hasSame(_ component: Calendar.Component, as date: Date) -> Bool {
        return distance(from: date, only: component) == 0
    }
    
    func isMonday(calendar: Calendar = .current) -> Bool {
        return calendar.component(.weekday, from: self) == 2
    }
    
    func isToday(calendar: Calendar = .current) -> Bool {
        return self.hasSame(.day, as: Date())
    }
    
    func atHour(_ hour: Double, calendar: Calendar = .current) -> Date {
        calendar.startOfDay(for: self).addingTimeInterval(hour * 60 * 60)
    }
}
