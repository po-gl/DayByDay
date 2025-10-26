//
//  ButtonCluster.swift
//  DayByDay
//
//  Created by Porter Glines on 1/8/23.
//

import SwiftUI
import CoreData

struct ButtonCluster: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(fetchRequest: DayData.pastDays(count: 1))
    private var latestDayResult: FetchedResults<DayMO>
    private var latestDay: DayMO? {
        latestDayResult.first?.date?.isToday() ?? false ? latestDayResult.first : nil
    }
    
    static let lowerBoundDiameter = 90.0

    var body: some View {
        GeometryReader { geometry in
            ButtonClusterForDay(day: latestDay, geometry: geometry, context: viewContext)
        }
        .frame(width: 360, height: 360)
    }
}

private struct ButtonClusterForDay: View {
    @ObservedObject var day: DayMO
    let geometry: GeometryProxy
    let context: NSManagedObjectContext

    let diameter = 140.0
    let fontSize = 15.0

    init(day: DayMO?, geometry: GeometryProxy, context: NSManagedObjectContext) {
        if let day {
            self.day = day
        } else {
            self.day = DayMO()
            let newDay = DayMO(context: context)
            newDay.date = Date()
            self.day = newDay
        }
        self.geometry = geometry
        self.context = context
    }

    var isDayComplete: Bool {
        day.active && day.creative && day.productive
    }

    var body: some View {
        // your existing body, now reading day.active/creative/productive directly
        ZStack {
            CompleteBackgroundView()
                .opacity(isDayComplete ? 1.0 : 0.0)
                .animation(.easeOut(duration: 3.0), value: isDayComplete)
                .allowsHitTesting(false)
                .zIndex(1)
            WaveView()
                .opacity(isDayComplete ? 1.0 : 0.0)
                .animation(.easeOut(duration: 1.0), value: isDayComplete)
                .allowsHitTesting(false)
                .zIndex(3)

            Group {
                SwirlButton("Active", for: .active, startAngle: .topLeft, geometry)
                    .zIndex(2)
                SwirlButton("Creative", for: .creative, startAngle: .topRight, geometry)
                    .zIndex(4)
                SwirlButton("Productive", for: .productive, startAngle: .bottom, geometry)
                    .zIndex(4)
            }
            .mask {
                WaveMask(geometry)
            }
        }
        .position(x: geometry.size.width/2, y: geometry.size.height/2)
    }

    @ViewBuilder
    private func SwirlButton(_ text: String, for category: StatusCategory, startAngle: AngleStart, _ geometry: GeometryProxy) -> some View {
        let isOn = day.isActive(for: category)
        Button(action: {
            withAnimation(.easeOut(duration: 0.2)) {
                DayData.toggle(category: category, for: day, context: context)
            }
            haptic()
        }) {
            CircleLabelView(radius: diameter/2, size: CGSize(width: diameter + fontSize*2 + 5, height: diameter + fontSize*2 + 5), startAngle: startAngle, text: text)
                .font(.system(size: fontSize, weight: .semibold, design: .monospaced))
                .opacity(scrollOffset(geometry) * 0.02 + 1.0)
        }
        .buttonStyle(SwirlStyle(category: category, isOn: isOn))
        .frame(width: diameter, height: diameter)
        .scaleEffect(scaleForScroll(geometry))
        .opacity(opacity(for: startAngle, geometry))
        .position(animPosition(for: startAngle, geometry))
        .accessibilityIdentifier("\(text)Button_\(isOn ? "On" : "Off")") // for UITests
    }


    private func haptic() {
        if isDayComplete {
            completeHaptic()
        } else {
            basicHaptic()
        }
    }

    @ViewBuilder
    private func WaveMask(_ geometry: GeometryProxy) -> some View {
        ZStack {
            Rectangle()
                .frame(width: geometry.size.width, height: 700)
            ZStack {
                WigglyBar(category: .active, width: 30, height: 400, frequency: 50, amplitude: 5, speed: 2.0)
                    .frame(width: 200, height: 400)
                    .rotationEffect(.degrees(90))
                    .shadow(radius: 22)
                WigglyBar(category: .active, width: 30, height: 400, frequency: 50, amplitude: 5, speed: 0.8)
                    .frame(width: 200, height: 400)
                    .rotationEffect(.degrees(90))
                    .shadow(radius: 15)
            }
            .offset(y: 700/2)
        }
    }


    private func animPosition(for startAngle: AngleStart, _ geometry: GeometryProxy) -> CGPoint {
        let start = startingPosition(for: startAngle, geometry)
        let offset = offset(for: startAngle, geometry)
        return CGPoint(x: start.x + offset.x, y: start.y + offset.y)
    }

    private func startingPosition(for startAngle: AngleStart, _ geometry: GeometryProxy) -> CGPoint {
        let padding = 15.0
        let frameX = geometry.frame(in: .local).width
        let frameY = geometry.frame(in: .local).height
        switch startAngle {
        case .topLeft:
            return CGPoint(x: frameX / 3 - padding, y: frameY / 3)
        case .topRight:
            return CGPoint(x: frameX - frameX / 3 + padding, y: frameY / 3)
        case .bottom:
            return CGPoint(x: frameX / 2, y: frameY - frameY / 3 + padding)
        case .top:
            return CGPoint()
        }
    }

    private func offset(for startAngle: AngleStart, _ geometry: GeometryProxy) -> CGPoint {
        let scrollOffset = scrollOffset(geometry)
        let bound = 40.0
        let factor = 2.0
        switch startAngle {
        case .topLeft:
            return CGPoint(x: min(max(scrollOffset, -bound), 0.0), y: max(-scrollOffset * factor, 0.0))
        case .topRight:
            return CGPoint(x: max(min(-scrollOffset, bound), 0.0), y: max(-scrollOffset * (factor - 0.2), 0.0))
        case .bottom:
            let bottomThreshold = -66.0
            return scrollOffset < bottomThreshold ? CGPoint(x: 0.0, y: (-scrollOffset + bottomThreshold) * (factor - 0.6)) : CGPoint()
        case .top:
            return CGPoint()
        }
    }

    private func opacity(for startAngle: AngleStart, _ geometry: GeometryProxy) -> Double {
        let scrollOffset = scrollOffset(geometry)
        switch startAngle {
        case .topLeft:
            return 1.0 + scrollOffset / 330
        case .topRight:
            return 1.0 + scrollOffset / 390
        case .bottom:
            return 1.0 + scrollOffset / 420
        case .top:
            return 1.0
        }
    }

    private func scaleForScroll(_ geometry: GeometryProxy) -> Double {
        let scrollOffset = scrollOffset(geometry)
        let lowerBound = ButtonCluster.lowerBoundDiameter / diameter
        return max(min(1.0, 1.0 + scrollOffset / 200), lowerBound)
    }

    private func scrollOffset(_ geometry: GeometryProxy) -> Double {
        return geometry.frame(in: .named("scroll")).minY - 216.0
    }
}
