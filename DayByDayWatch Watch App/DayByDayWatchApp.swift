//
//  DayByDayWatchApp.swift
//  DayByDayWatch Watch App
//
//  Created by Porter Glines on 1/16/23.
//

import SwiftUI

@main
struct DayByDayWatch_Watch_AppApp: App {
  let persistenceController = PersistenceController.shared

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
  }
}
