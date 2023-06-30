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
    
    @State private var showingNoteEditor = false
    @State private var noteEditorDay: DayMO?
    
    var body: some View {
            ZStack {
                WigglyBars()
                    .mask(Cells(isMask: true))
                DatesAndDividers()
                NoteAccents()
                Eyes()
                Cells()
                DescriptiveText()
            }
        .frame(height: height)
        .padding(.bottom, 30)
        
        .sheet(item: $noteEditorDay) { day in
            NoteEditorView(date: day.date!, focusOnAppear: true)
        }
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
    private func Cells(isMask: Bool = false) -> some View {
        VStack(spacing: 0) {
            ForEach(0..<daysToDisplay, id: \.self) { i in
                let date = Date(timeInterval: -Double(60*60*24*i), since: Date())
                let day = DayData.getDay(for: date, days: allDays)
                
                HStack(spacing: 5) {
                    Cell(category: .active, isMask, date: date)
                        .accessibilityAddTraits(.isButton)
                        .accessibilityIdentifier("PastViewRow\(i)_Col1")
                    Cell(category: .productive, isMask, date: date)
                        .accessibilityAddTraits(.isButton)
                        .accessibilityIdentifier("PastViewRow\(i)_Col2")
                    Cell(category: .creative, isMask, date: date)
                        .accessibilityAddTraits(.isButton)
                        .accessibilityIdentifier("PastViewRow\(i)_Col3")
                }
                .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 20))
                .contextMenu {
                    NoteContextMenu(for: day)
                } preview: {
                    NoteContextPreview(for: day, date: date)
                }
            }
        }
    }
    
    @ViewBuilder
    private func Cell(category: StatusCategory, _ isMask: Bool, date: Date) -> some View {
        let width: Double = 110
        let day = DayData.getDay(for: date, days: allDays)
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
                            DayData.toggle(category: category, for: day, context: viewContext)
                        } else {
                            DayData.addDay(activeFor: category, date: date, context: viewContext)
                        }
                    }
                }
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
        VStack(spacing: cellHeight-1) {
            ForEach(0..<daysToDisplay, id: \.self) { i in
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
    
    @ViewBuilder private func DescriptiveText() -> some View {
        VStack {
            Spacer()
            Text("Past \(daysToDisplay) days")
                .font(.title3)
                .fontDesign(.serif)
                .opacity(0.8)
                .offset(y: 35)
        }
    }
    
    @ViewBuilder
    private func NoteAccents() -> some View {
        let width = 3*(90.0+22)
        VStack(spacing: 0) {
            ForEach(0..<daysToDisplay, id: \.self) { i in
                let date = Date(timeInterval: -Double(60*60*24*i), since: Date())
                let day = DayData.getDay(for: date, days: allDays)
                
                HStack {
                    Spacer()
                    NoteAccent()
                        .opacity(day?.note?.isEmpty ?? true ? 0.0 : 1.0)
                        .offset(x: 10)
                }
                .frame(width: width, height: cellHeight)
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
    private func NoteContextMenu(for day: DayMO?) -> some View {
        Button(action: {
            noteEditorDay = day
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
