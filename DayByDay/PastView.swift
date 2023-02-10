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
        GeometryReader { geometry in
            ZStack {
                WigglyBars(geometry)
                    .mask(Cells(isMask: true, geometry))
                DatesAndDividers()
                WigglyEyes(barWidth: barWidthForScroll(geometry))
                Cells(geometry)
            }
            .position(x: geometry.size.width/2, y: geometry.size.height/2)
        }
        .frame(height: height)
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
    private func Cells(isMask: Bool = false, _ geometry: GeometryProxy) -> some View {
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
    private func WigglyBars(_ geometry: GeometryProxy) -> some View {
        HStack(spacing: 25) {
            WigglyBar(category: .active, width: barWidthForScroll(geometry), geometry: geometry)
            WigglyBar(category: .productive, width: barWidthForScroll(geometry), geometry: geometry)
            WigglyBar(category: .creative, width: barWidthForScroll(geometry), geometry: geometry)
        }
        .offset(y: barWidthForScroll(geometry)/2)
    }
    
    @ViewBuilder
    private func DatesAndDividers() -> some View {
        VStack(spacing: cellHeight-1) {
            ForEach(0..<daysToDisplay, id: \.self) { i in
                ZStack {
                    Text("\(Date(timeInterval: -Double(60*60*24*i), since: Date()), formatter: dayFormatter)")
                        .font(.system(size: 14, weight: .regular, design: .monospaced))
                        .offset(x: -90.0*1.5, y: 14)
                        .frame(height: 0)
                    
                    if Date(timeInterval: -Double(60*60*24*i), since: Date()).isMonday() {
                        Line()
                            .stroke(.primary, style: StrokeStyle(lineWidth: 2.5, lineCap: .round, dash: [10]))
                            .frame(width: 3*(90.0+22), height: 1)
                            .offset(y: cellHeight/2)
                            .opacity(0.7)
                    } else {
                        Line()
                            .stroke(.primary, style: StrokeStyle(lineWidth: 1.0, lineCap: .round))
                            .frame(width: 3*(90.0+22), height: 1)
                            .offset(y: cellHeight/2)
                            .opacity(0.3)
                    }
                }
            }
        }
    }
    
    
    private func barWidthForScroll(_ geometry: GeometryProxy) -> Double {
        let diameter = ButtonCluster.lowerBoundDiameter
        let bound = 90.0
        return min(diameter, max(diameter - scrollOffset(geometry) * 0.25, bound))
    }
    
    private func scrollOffset(_ geometry: GeometryProxy) -> Double {
        return geometry.frame(in: .named("scroll")).minY - 580.0
    }
}

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}


private let dayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.setLocalizedDateFormatFromTemplate("EE M/d")
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
