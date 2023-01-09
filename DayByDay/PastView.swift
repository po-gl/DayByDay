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
                dates()
                dividers()
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
                .stroke(.pink.gradient, style: StrokeStyle(lineWidth: barWidthForScroll(geometry), lineCap: .round))
                .frame(width: barWidthForScroll(geometry))
            WigglePath(shiftX: shiftX, shiftY: shiftY)
                .stroke(.green.gradient, style: StrokeStyle(lineWidth: barWidthForScroll(geometry), lineCap: .round))
                .frame(width: barWidthForScroll(geometry))
            WigglePath(shiftX: shiftX, shiftY: shiftY)
                .stroke(.purple.gradient, style: StrokeStyle(lineWidth: barWidthForScroll(geometry), lineCap: .round))
                .frame(width: barWidthForScroll(geometry))
        }
        .offset(y: barWidthForScroll(geometry)/2)
    }
    
    private func dates() -> some View {
        VStack(spacing: cellHeight-1) {
            ForEach(0..<30) { i in
                Text("\(Date(timeInterval: -Double(60*60*24*i), since: Date()), formatter: dayFormatter)")
                    .font(.system(size: 14, weight: .light))
                    .offset(x: -90.0*1.5, y: 18)
                    .frame(height: 1)
            }
        }
    }
    
    private func dividers() -> some View {
        return VStack(spacing: cellHeight-1) {
            ForEach(0..<30) { _ in
                Line()
                    .stroke(.primary, style: StrokeStyle(lineWidth: 1, dash: [2.5]))
                    .frame(width: 3*(90.0+22), height: 1)
                    .opacity(0.4)
            }
            .offset(y: cellHeight)
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
            .opacity(isActive ? 1.0 : 0.15)
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
