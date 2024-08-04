//
//  DayByDayApp.swift
//  DayByDay
//
//  Created by Porter Glines on 1/7/23.
//

import SwiftUI
import AVKit

@main
struct DayByDayApp: App {
    @Environment(\.undoManager) private var undoManager
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.scenePhase) private var scenePhase

    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear {
                    try? AVAudioSession.sharedInstance().setCategory(.ambient)
                    getNotificationPermissions()
                    viewContext.undoManager = undoManager
                }
                .onChange(of: scenePhase) { newPhase in
                    if newPhase == .active {
                        cancelPendingNotifications()
                    } else if newPhase == .inactive {
                        setupNotifications()
                    }
                }
        }
    }
}
