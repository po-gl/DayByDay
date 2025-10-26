//
//  PastView.swift
//  DayByDay
//
//  Created by Porter Glines on 1/8/23.
//

import SwiftUI

struct PastView: View {
    @Environment(\.managedObjectContext) private var viewContext

    public static let daysToDisplay: Int = 30
    public static let cellHeight = 66.0
    public static var height: Double { Double(daysToDisplay) * cellHeight }

    @FetchRequest(fetchRequest: DayData.pastDays(count: PastView.daysToDisplay))
    private var pastDays: FetchedResults<DayMO>

    @State private var showingNoteEditor = false
    @State private var noteEditorDay: DayMO?
    
    var body: some View {
        let days = generatedFilledDays()
        ZStack {
            WigglyBars()
                .mask(Cells(days: days, isMask: true))
            DatesAndDividers()
            NoteAccents(days: days)
            Eyes()
            Cells(days: days)
            DescriptiveText()
        }
        .frame(height: PastView.height)
        .padding(.bottom, 30)
        
        .sheet(item: $noteEditorDay) { day in
            NoteEditorView(date: day.date!, day: day, focusOnAppear: true)
        }
    }
    
    private func generatedFilledDays() -> [(Date, DayMO?)] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let fetchedDaysDict = Dictionary(
            pastDays.map { (calendar.startOfDay(for: $0.date!), $0) },
            uniquingKeysWith: { (first, _) in first }
        )
        var days: [(Date, DayMO?)] = []
        
        for i in 0..<PastView.daysToDisplay {
            guard let date = calendar.date(byAdding: .day, value: -i, to: today) else { continue }
            if let day = fetchedDaysDict[date] {
                days.append((date, day))
            } else {
                days.append((date, nil))
            }
        }
        return days
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
    
    
    @ViewBuilder
    private func Cells(days: [(Date, DayMO?)], isMask: Bool = false) -> some View {
        VStack(spacing: 0) {
            ForEach(days, id: \.0) { (date, day) in
                HStack(spacing: 5) {
                    if let day {
                        CellView(date: date, category: .active, isMask: isMask, day: day)
                        CellView(date: date, category: .productive, isMask: isMask, day: day)
                        CellView(date: date, category: .creative, isMask: isMask, day: day)
                    } else {
                        EmptyCellView(date: date, category: .active, isMask: isMask)
                        EmptyCellView(date: date, category: .productive, isMask: isMask)
                        EmptyCellView(date: date, category: .creative, isMask: isMask)
                    }
                }
                .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 20))
                .contextMenu {
                    NoteContextMenu(for: day, date: date)
                } preview: {
                    NoteContextPreview(for: day, date: date)
                }
            }
        }
    }

    @ViewBuilder
    private func WigglyBars() -> some View {
        HStack(spacing: 25) {
            WigglyBar(category: .active, width: ButtonCluster.lowerBoundDiameter, height: PastView.height)
            WigglyBar(category: .productive, width: ButtonCluster.lowerBoundDiameter, height: PastView.height)
            WigglyBar(category: .creative, width: ButtonCluster.lowerBoundDiameter, height: PastView.height)
        }
        .offset(y: ButtonCluster.lowerBoundDiameter/2)
    }
    
    @ViewBuilder
    private func DatesAndDividers() -> some View {
        let width = 3*(90.0+22)
        VStack(spacing: PastView.cellHeight-1) {
            ForEach(0..<PastView.daysToDisplay, id: \.self) { i in
                let date = Date(timeInterval: -Double(60*60*24*i), since: Date())
                ZStack {
                    HStack (spacing: 0){
                        if date.isToday() {
                            Text("Today")
                                .font(.system(.body, design: .monospaced, weight: .medium))
                                .padding(.trailing, 10)
                        } else {
                            Text("\(date, formatter: weekdayFormatter)")
                                .font(.system(.body, design: .monospaced, weight: .medium))
                                .padding(.trailing, 10)
                            Text("\(date, formatter: dayFormatter)")
                                .font(.system(.body, design: .monospaced, weight: .regular))
                                .opacity(0.6)
                        }
                        Spacer()
                    }
                    .frame(width: width, height: 0)
                    .offset(y: 14)
                    
                    if date.isMonday() {
                        WeekLine(width: width)
                            .frame(height: 1)
                            .offset(y: PastView.cellHeight/2)
                    } else {
                        HorizontalLine()
                            .stroke(.primary, style: StrokeStyle(lineWidth: 1.0, lineCap: .round))
                            .frame(width: width, height: 1)
                            .offset(y: PastView.cellHeight/2)
                            .opacity(0.3)
                    }
                }
            }
        }
    }
    
    @ViewBuilder private func DescriptiveText() -> some View {
        VStack {
            Spacer()
            Text("Past \(PastView.daysToDisplay) days")
                .font(.title3)
                .fontDesign(.serif)
                .opacity(0.8)
                .offset(y: 35)
        }
    }
    
    @ViewBuilder
    private func NoteAccents(days: [(Date, DayMO?)]) -> some View {
        let width = 3*(90.0+22)
        VStack(spacing: 0) {
            ForEach(days, id: \.0) { (date, day) in
                HStack {
                    Spacer()
                    NoteAccent()
                        .opacity(day?.note?.isEmpty ?? true ? 0.0 : 1.0)
                        .offset(x: 10)
                }
                .frame(width: width, height: PastView.cellHeight)
            }
        }
    }
    
    @ViewBuilder
    private func NoteAccent() -> some View {
        Circle()
            .fill(.orange.gradient)
            .frame(width: 9)
            .opacity(0.7)
    }
    
    @ViewBuilder
    private func NoteContextMenu(for day: DayMO?, date: Date) -> some View {
        Button(action: {
            noteEditorDay = day ?? DayData.addDay(date: date, context: viewContext)
        }) {
            Label("Edit note", systemImage: "pencil.line")
        }
    }
    
    @ViewBuilder
    private func NoteContextPreview(for day: DayMO?, date: Date) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Color.clear.frame(width: 10, height: 10)
                    Text(relativeDayFormatter.string(from: date))
                        .font(.system(.body, design: .serif))
                        .opacity(0.6)
                }
                
                HStack(alignment: .top) {
                    NoteAccent()
                        .opacity(day?.note?.isEmpty ?? true ? 0.3 : 1.0)
                        .offset(y: 5)
                    Text(day?.note ?? "No note for day")
                        .opacity(day?.note?.isEmpty ?? true ? 0.5 : 1.0)
                        .lineLimit(nil)
                }
            }
            Spacer()
        }
        .padding()
        .frame(width: 300)
    }
}

private struct CellView: View {
    @Environment(\.managedObjectContext) private var viewContext
    let date: Date
    let category: StatusCategory
    let isMask: Bool

    @ObservedObject var day: DayMO

    var body: some View {
        let width: Double = 110
        let isActive = day.isActive(for: category)
        if isMask {
            Rectangle()
                .frame(width: width, height: PastView.cellHeight)
                .opacity(isActive ? 1.0 : 0.40)
        } else {
            Rectangle()
                .frame(width: width, height: PastView.cellHeight)
                .foregroundColor(.clear)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        heavyHaptic()
                        DayData.toggle(category: category, for: day, context: viewContext)
                    }
                }
        }
    }
}

private struct EmptyCellView: View {
    @Environment(\.managedObjectContext) private var viewContext
    let date: Date
    let category: StatusCategory
    let isMask: Bool

    var body: some View {
        let width: Double = 110
        if isMask {
            Rectangle()
                .frame(width: width, height: PastView.cellHeight)
                .opacity(0.40)
        } else {
            Rectangle()
                .frame(width: width, height: PastView.cellHeight)
                .foregroundColor(.clear)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        heavyHaptic()
                        DayData.addDay(activeFor: category, date: date, context: viewContext)
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

private let relativeDayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.doesRelativeDateFormatting = true
    formatter.dateStyle = .short
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
