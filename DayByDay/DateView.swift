//
//  DateView.swift
//  DayByDay
//
//  Created by Porter Glines on 2/16/23.
//

import SwiftUI

struct DateView: View {
    var body: some View {
        VStack (spacing: 8) {
            Text("\(Date(), formatter: dayFormatter)")
                .font(.system(size: 44, weight: .light, design: .serif))
                .monospacedDigit()
            Underline()
        }
        .frame(height: 200)
    }
    
    @ViewBuilder
    private func Underline() -> some View {
        ZStack {
            HorizontalLine()
                .stroke(.primary, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .frame(width: 200, height: 1)
            ShineLines()
                .offset(x: 40)
        }
    }
    
    @ViewBuilder
    private func ShineLines() -> some View {
        ZStack {
            HorizontalLine()
                .stroke(.background, style: StrokeStyle(lineWidth: 2, lineCap: .butt))
                .frame(width: 20, height: 1)
            HorizontalLine()
                .stroke(.background, style: StrokeStyle(lineWidth: 2, lineCap: .butt))
                .frame(width: 5, height: 1)
                .offset(x: 18)
        }
    }
}

private let dayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.setLocalizedDateFormatFromTemplate("EEEE M/d")
    return formatter
}()

