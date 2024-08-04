//
//  ContentView.swift
//  DayByDay
//
//  Created by Porter Glines on 1/7/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.colorScheme) private var colorScheme

    @FetchRequest(fetchRequest: DayData.pastDays(count: 1))
    private var latestDayResult: FetchedResults<DayMO>
    private var latestDay: DayMO? {
        latestDayResult.first?.date?.isToday() ?? false ? latestDayResult.first : nil
    }
    
    @State private var showingNoteEditor = false
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack {
                    MainPage(geometry)
                        .overlay(alignment: .top) { StatusBarBlur() }
                    TopButtons(showingNoteEditor: $showingNoteEditor)
                        .zIndex(5)
                }
            }
            .tint(Color(hex: 0xBE59D5))
        }
    }
    
    
    @ViewBuilder
    private func MainPage(_ geometry: GeometryProxy) -> some View {
        ScrollView {
            VStack(spacing: 0) {
                DateView()
                ButtonCluster()
                    .zIndex(4)
                ZStack (alignment: .top) {
                    BottomSpacer(geometry)
                    Arrow()
                        .opacity(latestDay?.note?.isEmpty ?? true ? 1.0 : 0.0 )
                    NoteView(showingNoteEditor: $showingNoteEditor)
                        .zIndex(3)
                }
                PastView()
            }
            .padding()
        }
        .position(x: geometry.size.width/2, y: geometry.size.height/2)
        .coordinateSpace(name: "scroll")
    }
    
    @ViewBuilder
    private func StatusBarBlur() -> some View {
        Color.clear
            .background(.ultraThinMaterial)
            .brightness(colorScheme == .dark ? -0.1 : 0.02)
            .edgesIgnoringSafeArea(.top)
            .frame(height: 0)
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
