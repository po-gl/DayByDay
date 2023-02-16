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
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    DateView()
                    ButtonCluster()
                        .zIndex(3)
                    ZStack {
                        BottomSpacer(geometry)
                        Arrow()
                    }
                    PastView()
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
                cancelPendingNotifications()
            } else if newPhase == .inactive {
                setupNotifications()
            }
        }
    }
    
    
    @ViewBuilder
    private func BottomSpacer(_ geometry: GeometryProxy) -> some View {
        Rectangle()
            .fill(.clear)
            .frame(height: spaceFromButtonsToScreenBottom(geometry))
    }
    
    private func spaceFromButtonsToScreenBottom(_ geometry: GeometryProxy) -> Double {
        let screenHeight = geometry.size.height
        if screenHeight < 750 {  // iPhone 13 mini
            return 190.0
        } else if screenHeight < 763.0 {  // iPhone 14 Pro
            return 220.0
        } else if screenHeight < 839.0 { // iPhone 14
            return 220.0
        } else if screenHeight < 900.0 {  // iPhone 14 Pro Max/Plus
            return 305.0
        } else {
            return 360.0
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
