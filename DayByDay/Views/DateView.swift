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
    
    @State var animate = false
    
    var body: some View {
        VStack (spacing: 8) {
            Text("\(date, formatter: formatter)")
                .font(.system(size: fontSize, weight: .light, design: .serif))
            Underline()
        }
        .frame(height: width)
        
        .onAppear {
            animate = true
        }
    }
    
    @ViewBuilder
    private func Underline() -> some View {
        ZStack {
            BaseLine()
            
            ShineLines(width: 20)
                .offset(x: animate ? shineOffset : -200)
                .animation(.easeInOut(duration: 0.9).delay(0.35), value: animate)
                .mask(BaseLine())
            
            AnimatedShine()
                .mask(BaseLine())
        }
    }
    
    @ViewBuilder
    private func BaseLine() -> some View {
        HorizontalLine()
            .stroke(.primary, style: StrokeStyle(lineWidth: 3, lineCap: .round))
            .frame(width: width, height: 1)
    }
    
    @ViewBuilder
    private func ShineLines(width: Double = 20) -> some View {
        ZStack {
            HorizontalLine()
                .stroke(.background, style: StrokeStyle(lineWidth: 2, lineCap: .butt))
                .frame(width: width, height: 1)
            HorizontalLine()
                .stroke(.background, style: StrokeStyle(lineWidth: 2, lineCap: .butt))
                .frame(width: width/4, height: 1)
                .offset(x: width-2)
        }
    }
    
    @ViewBuilder
    private func AnimatedShine() -> some View {
        ShineLines(width: 80)
            .offset(x: animate ? 200 : -200)
            .animation(.easeInOut(duration: 0.9).delay(0.0), value: animate)
        
        ShineLines(width: 30)
            .offset(x: animate ? 200 : -200)
            .animation(.easeInOut(duration: 1.0).delay(0.3), value: animate)
    }
}

private let dayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.setLocalizedDateFormatFromTemplate("EEEE MMM d")
    return formatter
}()

