//
//  CompleteBackgroundView.swift
//  DayByDay
//
//  Created by Porter Glines on 1/15/23.
//

import SwiftUI

struct CompleteBackgroundView: View {
    

    @State var moving = false
    
    var body: some View {
        ZStack {
            Circle()
                .rotationEffect(.degrees(-70))
                .offset(x: moving ? -200 : 0, y: moving ? -100 : 0)
                .animation(.easeInOut(duration: 12.0).repeatForever(), value: moving)
                .scaleEffect(1.2)
                .foregroundStyle(Gradient(colors: [Color(hex: 0xF23336), Color(hex: 0xB04386)]))
                .blurAndBrighten()
                .opacity(0.9)
            
            Circle()
                .rotationEffect(.degrees(-70))
                .offset(x: moving ? 100 : 40, y: moving ? 100: 80)
                .animation(.easeInOut(duration: 8.0).repeatForever(), value: moving)
                .scaleEffect(1.4)
                .foregroundStyle(Gradient(colors: [Color(hex: 0xF77756), Color(hex: 0xA8E712)]))
                .blurAndBrighten()
                .opacity(0.8)
            
            Circle()
                .rotationEffect(.degrees(moving ? 0 : 360))
                .rotationEffect(.degrees(moving ? 360 : 0), anchor: .init(x: UnitPoint.center.x - 0.1, y: UnitPoint.center.y + 0.1))
                .animation(.linear(duration: 10.0).repeatForever(autoreverses: false), value: moving)
                .offset(x: 160, y: -200)
                .scaleEffect(1.2)
                .foregroundStyle(Gradient(colors: [Color(hex: 0xBAE1E5), Color(hex: 0xC96FC3)]))
                .blurAndBrighten()
                .opacity(0.8)
        }
        .onAppear() {
            withAnimation {
                moving.toggle()
            }
        }
    }
}

extension View {
    public func blurAndBrighten() -> some View {
        self.blur(radius: 80)
            .brightness(0.13)
            .saturation(1.2)
    }
}

struct CompleteBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteBackgroundView()
    }
}
