//
//  DayData.swift
//  DayByDay
//
//  Created by Porter Glines on 3/7/23.
//

import Foundation
import CoreData
import SwiftUI

struct DayData {
    
    // MARK: Add Day functions
    
    @discardableResult
    static func addDay(date: Date, context: NSManagedObjectContext) -> DayMO {
        let newDay = DayMO(context: context)
        newDay.date = date
        saveContext(context, errorMessage: "CoreData error adding day.")
        return newDay
    }
    
    static func addDay(activeFor category: StatusCategory, date: Date, context: NSManagedObjectContext) {
        let newDay = DayMO(context: context)
        newDay.date = date
        newDay.toggle(category: category)
        saveContext(context, errorMessage: "CoreData error adding day for category \(category).")
    }
    
    static func addDay(withNote note: String, date: Date, context: NSManagedObjectContext) {
        let newDay = DayMO(context: context)
        newDay.date = date
        newDay.note = note
        saveContext(context, errorMessage: "CoreData error adding day with note.")
    }
    
    static func addDay(active: Bool, creative: Bool, productive: Bool,
                       date: Date,
                       context: NSManagedObjectContext) {
        let newDay = DayMO(context: context)
        newDay.date = date
        newDay.active = active
        newDay.creative = creative
        newDay.productive = productive
        saveContext(context, errorMessage: "CoreData error adding day.")
    }
    
    // MARK: Toggle Category
    
    static func toggle(category: StatusCategory, for day: DayMO, context: NSManagedObjectContext) {
        day.toggle(category: category)
        saveContext(context, errorMessage: "CoreData error toggling day category.")
    }
    
    // MARK: Change Note
    
    static func change(note: String, for day: DayMO, context: NSManagedObjectContext) {
        day.note = note
        saveContext(context, errorMessage: "CoreData error changing day note.")
    }
    
    static func deleteNote(for day: DayMO, context: NSManagedObjectContext) {
        day.note = ""
        saveContext(context, errorMessage: "CoreData error deleting day note.")
    }
    
    // MARK: Save Context
    
    static func saveContext(_ context: NSManagedObjectContext, errorMessage: String = "CoreData error.") {
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("\(errorMessage) \(nsError), \(nsError.userInfo)")
        }
    }
    
    // MARK: Get specific day from fetch results
    
    static func getDay(for date: Date, days: FetchedResults<DayMO>) -> DayMO? {
        for day in days {
            if isDayOnDate(day, date: date) { return day }
        }
        return nil
    }
    
    static func getDay(for date: Date, days: Array<DayMO>) -> DayMO? {
        for day in days {
            if isDayOnDate(day, date: date) { return day }
        }
        return nil
    }
    
    static private func isDayOnDate(_ day: DayMO, date: Date) -> Bool {
        return day.date?.isSameDay(as: date) ?? false
    }
}
