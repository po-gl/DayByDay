//
//  WeekLine.swift
//  DayByDay
//
//  Created by Porter Glines on 2/21/23.
//

import SwiftUI

struct WeekLine: View {
    let width: Double
    @State var animate = false
    
    var body: some View {
        ZStack {
            HorizontalLine()
                .stroke(.primary, style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
                .frame(width: width, height: 1)
            Shine()
        }
    }
    
    @ViewBuilder
    private func Shine() -> some View {
        let animateShift: Double = animate ? 8 : 0
        let animateStretch: Double = animate ? 4 : 0
        let shine = ZStack {
            HorizontalLine()
                .stroke(.background, style: StrokeStyle(lineWidth: 2.0, lineCap: .butt))
                .frame(width: 8 + animateStretch, height: 1)
                .offset(x: -38 + animateShift)
            HorizontalLine()
                .stroke(.background, style: StrokeStyle(lineWidth: 2.0, lineCap: .butt))
                .frame(width: 16, height: 1)
                .offset(x: 18 + animateShift + animateStretch*1.5)
            HorizontalLine()
                .stroke(.background, style: StrokeStyle(lineWidth: 2.0, lineCap: .butt))
                .frame(width: 5 - animateStretch/2, height: 1)
                .offset(x: 32 + animateShift)
        }
            .frame(width: ButtonCluster.lowerBoundDiameter)
        
        HStack (spacing: 25) {
            shine
            shine
            shine
        }
        .animation(.easeInOut(duration: 2.0).repeatForever(), value: animate)
        .onAppear {
            animate = true
        }
    }
}
