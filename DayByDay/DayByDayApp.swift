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
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear {
                    try? AVAudioSession.sharedInstance().setCategory(.ambient)
                }
        }
    }
}
