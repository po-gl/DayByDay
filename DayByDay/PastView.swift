//
//  PastView.swift
//  DayByDay
//
//  Created by Porter Glines on 1/8/23.
//

import SwiftUI

struct PastView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\DayMO.date, order: .reverse)])
    private var allDays: FetchedResults<DayMO>
    
    private let daysToDisplay: Int = 30
    private let cellHeight = 66.0
    private var height: Double { Double(daysToDisplay) * cellHeight }
    
    var body: some View {
        ZStack {
            WigglyBars()
                .mask(Cells(isMask: true))
            DatesAndDividers()
            Eyes()
            Cells()
        }
        .frame(height: height)
    }
    
    
    @State var eyesAnim1 = false
    @State var eyesAnim2 = false
    @State var eyesAnim3 = false
    
    @ViewBuilder
    private func Eyes() -> some View {
        VStack {
            HStack(spacing: 25) {
                let barWidth = ButtonCluster.lowerBoundDiameter
                let animateOffset = 2.0
                let eyeWidth = 38.0
                let eyeDepth = 8.0
                WigglyEyes(barWidth: barWidth, width: eyeWidth, depth: eyeDepth, delay: 0.1)
                    .animation(.easeInOut(duration: 1.0).repeatForever().delay(0.2), value: eyesAnim1)
                    .offset(x: eyesAnim1 ? -animateOffset : animateOffset)
                WigglyEyes(barWidth: barWidth, width: eyeWidth + 20, depth: eyeDepth + 10, delay: 2.5)
                    .animation(.easeInOut(duration: 1.0).repeatForever().delay(0.3), value: eyesAnim2)
                    .offset(x: eyesAnim2 ? -animateOffset : animateOffset)
                WigglyEyes(barWidth: barWidth, width: eyeWidth +  0, depth: eyeDepth - 10, delay: 1.5)
                    .offset(x: eyesAnim3 ? animateOffset : -animateOffset)
                    .animation(.easeInOut(duration: 1.0).repeatForever().delay(0.4), value: eyesAnim3)
            }
            Spacer()
        }
        .onAppear { eyesAnim1 = true; eyesAnim2 = true; eyesAnim3 = true }
    }
    
    
    private func getDay(for date: Date) -> DayMO? {
        for day in allDays {
            if day.date?.hasSame(.day, as: date) ?? false {
                return day
            }
        }
        return nil
    }
    
    
    @ViewBuilder
    private func Cells(isMask: Bool = false) -> some View {
        VStack(spacing: 0) {
            ForEach(0..<daysToDisplay, id: \.self) { i in
                let date = Date(timeInterval: -Double(60*60*24*i), since: Date())
                HStack(spacing: 5) {
                    Cell(category: .active, isMask, date: date)
                    Cell(category: .productive, isMask, date: date)
                    Cell(category: .creative, isMask, date: date)
                }
            }
        }
    }
    
    @ViewBuilder
    private func Cell(category: StatusCategory, _ isMask: Bool, date: Date) -> some View {
        let width: Double = 110
        let day = getDay(for: date)
        let isActive = day?.isActive(for: category) ?? false
        
        if isMask {
            Rectangle()
                .frame(width: width, height: cellHeight)
                .opacity(isActive ? 1.0 : 0.40)
        } else {
            Rectangle()
                .frame(width: width, height: cellHeight)
                .foregroundColor(.clear)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        heavyHaptic()
                        if let day = day {
                            day.toggle(category: category)
                        } else {
                            addDay(activeFor: category, date: date)
                        }
                        saveContext()
                    }
                }
        }
    }
    
    private func addDay(activeFor category: StatusCategory, date: Date) {
        let newItem = DayMO(context: viewContext)
        newItem.date = date
        newItem.toggle(category: category)
        saveContext()
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    @ViewBuilder
    private func WigglyBars() -> some View {
        HStack(spacing: 25) {
            WigglyBar(category: .active, width: ButtonCluster.lowerBoundDiameter, height: height)
            WigglyBar(category: .productive, width: ButtonCluster.lowerBoundDiameter, height: height)
            WigglyBar(category: .creative, width: ButtonCluster.lowerBoundDiameter, height: height)
        }
        .offset(y: ButtonCluster.lowerBoundDiameter/2)
    }
    
    @ViewBuilder
    private func DatesAndDividers() -> some View {
        let width = 3*(90.0+22)
        LazyVStack(spacing: cellHeight-1) {
            ForEach(0..<daysToDisplay, id: \.self) { i in
                let day = Date(timeInterval: -Double(60*60*24*i), since: Date())
                ZStack {
                    HStack (spacing: 0){
                        if day.isToday() {
                            Text("Today")
                                .font(.system(size: 14, weight: .regular, design: .monospaced))
                                .padding(.trailing, 10)
                        } else {
                            Text("\(day, formatter: weekdayFormatter)")
                                .font(.system(size: 14, weight: .medium, design: .monospaced))
                                .padding(.trailing, 10)
                        }
                        Text("\(day, formatter: dayFormatter)")
                            .font(.system(size: 12, weight: .regular, design: .monospaced))
                            .opacity(0.6)
                        Spacer()
                    }
                    .frame(width: width, height: 0)
                    .offset(y: 14)
                    
                    if day.isMonday() {
                        WeekLine(width: width)
                            .frame(height: 1)
                            .offset(y: cellHeight/2)
                    } else {
                        HorizontalLine()
                            .stroke(.primary, style: StrokeStyle(lineWidth: 1.0, lineCap: .round))
                            .frame(width: width, height: 1)
                            .offset(y: cellHeight/2)
                            .opacity(0.3)
                    }
                }
            }
        }
    }
}


private let weekdayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.setLocalizedDateFormatFromTemplate("EE")
    return formatter
}()
private let dayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.setLocalizedDateFormatFromTemplate("M/d")
    return formatter
}()


struct PastView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack {
                Spacer()
                PastView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            }
            .frame(width: 400)
        }
        
        .scrollIndicators(.never)
        .ignoresSafeArea(edges: .bottom)
    }
}
