//
//  DayByDayApp.swift
//  DayByDay
//
//  Created by Porter Glines on 1/7/23.
//

import SwiftUI

@main
struct DayByDayApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
