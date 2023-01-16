//
//  ContentView.swift
//  DayByDay
//
//  Created by Porter Glines on 1/7/23.
//

import SwiftUI
import CoreData

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
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    dateView()
                    
                    ButtonCluster(dayStatus: $dayStatus)
                    
                    Spacer(minLength: spaceFromButtonsToScreenBottom(geometry))
                    
                    PastView(dayStatus: $dayStatus)
                }
                .padding()
            }
            .position(x: geometry.size.width/2, y: geometry.size.height/2)
            .coordinateSpace(name: "scroll")
        }
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
                setupNotifications(dayStatus)
            }
        }
    }
    
    
    private func dateView() -> some View {
        ZStack {
            Text("\(Date(), formatter: dayFormatter)")
                .font(.system(size: 50, weight: .light, design: .serif))
                .monospacedDigit()
                .frame(height: 200)
            Line()
                .stroke(.primary, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .frame(width: 200, height: 1)
                .offset(y: 35)
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

    private func spaceFromButtonsToScreenBottom(_ geometry: GeometryProxy) -> Double {
        let screenHeight = geometry.size.height
        if screenHeight < 696.0 {
            return 140.0
        } else if screenHeight < 763.0 {  // iPhone 13 mini
            return 190.0
        } else if screenHeight < 839.0 {  // iPhone 14
            return 205.0
        } else if screenHeight < 900.0 {  // iPhone 14 Pro Max
            return 313.0
        } else {
            return 360.0
        }
    }
}

private let dayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.setLocalizedDateFormatFromTemplate("EEEE M/d")
    return formatter
}()


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
