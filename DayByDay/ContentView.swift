//
//  ContentView.swift
//  DayByDay
//
//  Created by Porter Glines on 1/7/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [SortDescriptor(\DayMO.date, order: .reverse)], animation: .default)
    private var allDays: FetchedResults<DayMO>
    
    @State private var showingPastPage = false
    
    @State private var dayStatus = DayStatus()
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    Spacer(minLength: 200)
                    
                    ButtonCluster(dayStatus: $dayStatus)
                    
                    Spacer(minLength: spaceFromButtonsToScreenBottom(geometry))
                    
                    PastView(dayStatus: $dayStatus)
                    
                    Button("🦥") { showingPastPage.toggle() }
                        .foregroundColor(.primary)
                        .sheet(isPresented: $showingPastPage) { pastPage }
                }
                .padding()
            }
            .position(x: geometry.size.width/2, y: geometry.size.height/2)
            .coordinateSpace(name: "scroll")
        }
        .onAppear() {
            getDayStatus()
        }
    }
    
    private func getDayStatus() {
        guard allDays.count > 0 else { return }
        let latestDay = allDays[0]
        guard latestDay.date!.hasSame(.day, as: Date()) else {
            dayStatus = DayStatus()
            return
        }
        dayStatus.active = latestDay.active
        dayStatus.creative = latestDay.creative
        dayStatus.productive = latestDay.productive
    }
    
    var pastPage: some View {
        NavigationView {
            List {
                ForEach(allDays) { item in
                    NavigationLink {
                        Text("Item at \(item.date!, formatter: itemFormatter)")
                    } label: {
                        Text("\(item.date!, formatter: itemFormatter)  \(item.active ? "🕺" : "_") \(item.productive ? "💻" : "_") \(item.creative ? "🎨" : "_")")
                            .monospacedDigit()
                    }
                    .isDetailLink(false)
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
    }

    private func addItem() {
        withAnimation {
            for i in 0..<5 {
                let newItem = DayMO(context: viewContext)
                newItem.date = Date().addingTimeInterval(-60.0 * 60 * 24.0 * Double(i+1)*2.0)
                newItem.active = Bool.random()
                newItem.creative = Bool.random()
                newItem.productive = Bool.random()
            }

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { allDays[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
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

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
