//
//  Notifications.swift
//  DayByDay
//
//  Created by Porter Glines on 1/16/23.
//

import Foundation
import SwiftUI

#if os(watchOS)
import WatchKit
import UserNotifications
#endif
    
    
func getNotificationPermissions() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, error in
        if let error = error {
            print("There was an error requesting permissions: \(error.localizedDescription)")
        }
    }
}

func setupNotifications() {
    let today = Date().atHour(20.25)
    
    for i in 0..<7 {
        let nextNotificationTime = today.addingTimeInterval(TimeInterval(i*60*60*24))
        guard nextNotificationTime.timeIntervalSinceNow > 0.0 else { continue }
        
        let content = UNMutableNotificationContent()
        content.title = "Check your orbs 🌚🌝🌞"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: nextNotificationTime.timeIntervalSinceNow, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}

func cancelPendingNotifications() {
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
}

private let dayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.setLocalizedDateFormatFromTemplate("EEEE M/d hh")
    return formatter
}()
