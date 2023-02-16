//
//  DateView.swift
//  DayByDay
//
//  Created by Porter Glines on 2/16/23.
//

import SwiftUI

struct DateView: View {
    var body: some View {
        ZStack {
            Text("\(Date(), formatter: dayFormatter)")
                .font(.system(size: 44, weight: .light, design: .serif))
                .monospacedDigit()
                .frame(height: 200)
            Line()
                .stroke(.primary, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .frame(width: 200, height: 1)
                .offset(y: 35)
        }
    }
}

private let dayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.setLocalizedDateFormatFromTemplate("EEEE M/d")
    return formatter
}()

