//
//  DateView.swift
//  DayByDay
//
//  Created by Porter Glines on 2/16/23.
//

import SwiftUI

struct DateView: View {
    var date = Date()
    var fontSize: Double = 38
    var width: Double = 200
    var shineOffset: Double = 40
    
    var formatter = dayFormatter
    
    var body: some View {
        VStack (spacing: 8) {
            Text("\(date, formatter: formatter)")
                .font(.system(size: fontSize, weight: .light, design: .serif))
            Underline()
        }
        .frame(height: width)
    }
    
    @ViewBuilder
    private func Underline() -> some View {
        ZStack {
            HorizontalLine()
                .stroke(.primary, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .frame(width: width, height: 1)
            ShineLines()
                .offset(x: shineOffset)
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
    formatter.setLocalizedDateFormatFromTemplate("EEEE MMM d")
    return formatter
}()

