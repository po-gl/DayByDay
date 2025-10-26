//
//  ContentView.swift
//  DayByDayWatch Watch App
//
//  Created by Porter Glines on 1/16/23.
//

import SwiftUI

struct ContentView: View {
  @Environment(\.scenePhase) private var scenePhase
  @Environment(\.managedObjectContext) private var viewContext

  @FetchRequest(sortDescriptors: [SortDescriptor(\DayMO.date, order: .reverse)])
  private var allDays: FetchedResults<DayMO>
  private var latestDay: DayMO? {
    return allDays.count > 0 ? allDays[0] : nil
  }

  @State private var dayStatus = DayStatus()

  var body: some View {
    ButtonCluster(dayStatus: $dayStatus)
      .onAppear {
        getNotificationPermissions()
      }
      .onChange(of: scenePhase) { newPhase in
        if newPhase == .active {
          withAnimation {
            getDayStatus()
          }
          cancelPendingNotifications()
        } else if newPhase == .inactive {
          setupNotifications()
        }
      }
  }

  private func getDayStatus() {
    guard latestDay?.date!.hasSame(.day, as: Date()) ?? false else {
      dayStatus = DayStatus()
      return
    }
    dayStatus.active = latestDay?.active ?? false
    dayStatus.creative = latestDay?.creative ?? false
    dayStatus.productive = latestDay?.productive ?? false
  }

}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView().environment(
      \.managedObjectContext, PersistenceController.preview.container.viewContext)
  }
}
