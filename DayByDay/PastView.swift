//
//  PastView.swift
//  DayByDay
//
//  Created by Porter Glines on 1/8/23.
//

import SwiftUI

struct PastView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\DayMO.date, order: .reverse)])
    private var allDays: FetchedResults<DayMO>
    
    @Binding var dayStatus: DayStatus
    
    private let height = 30 * 66.0
    private let cellHeight = 66.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                wiggleBars(geometry)
                    .mask(
                        VStack(spacing: 0) {
                            ForEach(0..<30) { i in
                                row(getDayStatus(for: Date(timeInterval: -Double(60*60*24*i), since: Date())), geometry)
                            }
                            Spacer()
                        }
                    )
                datesAndDividers()
                eyes(geometry)
            }
            .position(x: geometry.size.width/2, y: geometry.size.height/2)
        }
        .frame(height: height)
    }
    
    
    private func getDayStatus(for date: Date) -> DayStatus {
        for day in allDays {
            if day.date?.hasSame(.day, as: date) ?? false {
                return DayStatus(active: day.active, creative: day.creative, productive: day.productive)
            }
        }
        return DayStatus()
    }
    
    
    private func wiggleBars(_ geometry: GeometryProxy) -> some View {
        let shiftX = 5.0
        let shiftY = 90.0
        return HStack(spacing: 25) {
            WigglePath(shiftX: shiftX, shiftY: shiftY)
                .stroke(gradient(for: .active), style: StrokeStyle(lineWidth: barWidthForScroll(geometry), lineCap: .round))
                .frame(width: barWidthForScroll(geometry))
            WigglePath(shiftX: shiftX, shiftY: shiftY)
                .stroke(gradient(for: .productive), style: StrokeStyle(lineWidth: barWidthForScroll(geometry), lineCap: .round))
                .frame(width: barWidthForScroll(geometry))
            WigglePath(shiftX: shiftX, shiftY: shiftY)
                .stroke(gradient(for: .creative), style: StrokeStyle(lineWidth: barWidthForScroll(geometry), lineCap: .round))
                .frame(width: barWidthForScroll(geometry))
        }
        .offset(y: barWidthForScroll(geometry)/2)
    }
    
    private func datesAndDividers() -> some View {
        VStack(spacing: cellHeight-1) {
            ForEach(0..<30) { i in
                ZStack {
                    Text("\(Date(timeInterval: -Double(60*60*24*i), since: Date()), formatter: dayFormatter)")
                        .font(.system(size: 14, weight: .regular, design: .monospaced))
                        .offset(x: -90.0*1.5, y: 14)
                        .frame(height: 1)
                    
                    if Date(timeInterval: -Double(60*60*24*i), since: Date()).isMonday() {
                        Line()
                            .stroke(.primary, style: StrokeStyle(lineWidth: 2.5, lineCap: .round, dash: [10]))
                            .frame(width: 3*(90.0+22), height: 1)
                            .offset(y: 30.0)
                            .opacity(0.7)
                    } else {
                        Line()
                            .stroke(.primary, style: StrokeStyle(lineWidth: 1.0, lineCap: .round))
                            .frame(width: 3*(90.0+22), height: 1)
                            .offset(y: 30.0)
                            .opacity(0.3)
                    }
                }
            }
        }
    }
    
    private func eyes(_ geometry: GeometryProxy) -> some View {
        let eyeSize = 7.0
        let eyeWidth = 38.0
        let eyeDepth = 8.0
        return VStack {
            HStack(spacing: 25) {
                HStack {
                    Circle()
                        .frame(width: eyeSize)
                        .padding(.trailing, eyeWidth)
                    Circle()
                        .frame(width: eyeSize)
                }
                .frame(width: barWidthForScroll(geometry))
                .padding(.top, eyeDepth)
                HStack {
                    Circle()
                        .frame(width: eyeSize)
                        .padding(.trailing, eyeWidth + 20)
                    Circle()
                        .frame(width: eyeSize)
                }
                .frame(width: barWidthForScroll(geometry))
                .padding(.top, eyeDepth + 10)
                HStack {
                    Circle()
                        .frame(width: eyeSize)
                        .padding(.trailing, eyeWidth)
                    Circle()
                        .frame(width: eyeSize)
                }
                .frame(width: barWidthForScroll(geometry))
                .padding(.top, eyeDepth - 10)
            }
            Spacer()
        }
    }
    
    
    private func row(_ day: DayStatus, _ geometry: GeometryProxy) -> some View {
        HStack(spacing: 5) {
            cell(isActive: day.active, Color.pink, geometry)
            cell(isActive: day.productive, Color.green, geometry)
            cell(isActive: day.creative, Color.purple, geometry)
        }
    }
    
    private func cell(isActive: Bool, _ color: Color, _ geometry: GeometryProxy) -> some View {
        Rectangle()
            .frame(width: 110, height: cellHeight)
            .opacity(isActive ? 1.0 : 0.40)
    }
    
    private func gradient(for category: Category) -> LinearGradient {
        switch category {
        case .active:
            return LinearGradient(stops: [.init(color: Color(hex: 0xE69F1E), location: 0.0),
                                          .init(color: Color(hex: 0xF23336), location: 0.2),
                                          .init(color: Color(hex: 0xB04386), location: 0.8),
                                          .init(color: Color(hex: 0xB3F2B7), location: 1.0)],
                                  startPoint: .leading, endPoint: .trailing)
        case .productive:
            return LinearGradient(stops: [.init(color: Color(hex: 0xC62379), location: 0.0),
                                          .init(color: Color(hex: 0xF77756), location: 0.2),
                                          .init(color: Color(hex: 0xA8E712), location: 0.6),
                                          .init(color: Color(hex: 0xD8F7EC), location: 1.1)],
                                  startPoint: .leading, endPoint: .trailing)
        case .creative:
            return LinearGradient(stops: [.init(color: Color(hex: 0xFCEBD6), location: 0.0),
                                          .init(color: Color(hex: 0xBAE1E5), location: 0.2),
                                          .init(color: Color(hex: 0xC96FC3), location: 0.5),
                                          .init(color: Color(hex: 0xC33FDB), location: 0.8),
                                          .init(color: Color(hex: 0xF0BE83), location: 1.1)],
                                  startPoint: .leading, endPoint: .trailing)
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

struct WigglePath: Shape {
    var shiftX: Double
    var shiftY: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let point = CGPoint(x: rect.midX, y: rect.minY)
        path.move(to: point)
        wiggle(path: &path, in: rect, current: point)
        return path
    }
    
    private func wiggle(path: inout Path, in rect: CGRect, current: CGPoint) {
        var point = current
        var leftOrRight = true
        while point.y < rect.maxY {
            point.y += shiftY
            path.addQuadCurve(to: point, control: CGPoint(x: point.x + shiftX * (leftOrRight ? 1.0 : -1.0), y: point.y-shiftY/2))
            leftOrRight.toggle()
        }
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
        Wrapper()
    }
    
    struct Wrapper: View {
        @State var status = DayStatus()
        
        var body: some View {
            ScrollView {
                VStack {
                    Spacer()
                    PastView(dayStatus: $status).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                }
                .frame(width: 400)
            }
            
            .scrollIndicators(.never)
            .ignoresSafeArea(edges: .bottom)
        }
    }
}
