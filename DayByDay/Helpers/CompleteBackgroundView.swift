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
            active()
            productive()
            creative()
        }
        .onAppear() {
            withAnimation {
                moving.toggle()
            }
        }
    }
    
    private func active() -> some View {
        Group {
            Circle()
                .rotationEffect(.degrees(-70))
                .offset(x: moving ? -200 : -100, y: moving ? -140 : -80)
                .animation(.easeInOut(duration: 12.0).repeatForever(), value: moving)
                .scaleEffect(1.2)
                .foregroundStyle(Gradient(colors: [Color(hex: 0xE63C5C), Color(hex: 0xB04386)]))
                .blurAndBrighten(radius: 80)
                .opacity(0.9)
            
            Circle()
                .scaleEffect(0.6)
                .offset(x: moving ? -200 : -50, y: moving ? 200 : -100)
                .animation(.easeInOut(duration: 16.0).repeatForever(), value: moving)
                .foregroundColor(Color(hex: 0x90D794))
                .blurAndBrighten(radius: 40)
                .opacity(0.9)
            Circle()
                .scaleEffect(0.4)
                .offset(x: moving ? -30 : -30, y: moving ? -260 : -200)
                .animation(.easeInOut(duration: 13.0).repeatForever(), value: moving)
                .foregroundColor(Color(hex: 0xB04386))
                .blurAndBrighten(radius: 40)
                .opacity(0.9)
        }
    }
    
    private func creative() -> some View {
        Group {
            Circle()
                .rotationEffect(.degrees(moving ? 0 : 360))
                .rotationEffect(.degrees(moving ? 360 : 0), anchor: .init(x: UnitPoint.center.x - 0.1, y: UnitPoint.center.y + 0.1))
                .animation(.linear(duration: 10.0).repeatForever(autoreverses: false), value: moving)
                .offset(x: 160, y: -200)
                .scaleEffect(1.2)
                .foregroundStyle(Gradient(colors: [Color(hex: 0xFFDEBB), Color(hex: 0xA237BB)]))
                .blurAndBrighten(radius: 80)
                .opacity(0.8)
            
            Circle()
                .scaleEffect(0.5)
                .offset(x: moving ? 200 : 50, y: moving ? 0 : -100)
                .animation(.easeInOut(duration: 8.0).repeatForever(), value: moving)
                .foregroundColor(Color(hex: 0xD2E6F3))
                .blurAndBrighten(radius: 40)
                .opacity(0.7)
        }
    }
    
    private func productive() -> some View {
        Group {
            Circle()
                .rotationEffect(.degrees(0))
                .offset(x: moving ? 100 : 40, y: moving ? 100: 80)
                .animation(.easeInOut(duration: 8.0).repeatForever(), value: moving)
                .scaleEffect(1.4)
                .foregroundStyle(Gradient(colors: [Color(hex: 0xF77756), Color(hex: 0xA8E712)]))
                .blurAndBrighten(radius: 80)
                .opacity(0.7)
            
            Circle()
                .scaleEffect(0.4)
                .offset(x: moving ? 0 : 30, y: moving ? 100 : 160)
                .animation(.easeInOut(duration: 9.0).repeatForever(), value: moving)
                .foregroundColor(Color(hex: 0xFF7676))
                .blurAndBrighten(radius: 40)
                .opacity(0.8)
        }
    }
}

extension View {
    public func blurAndBrighten(radius: CGFloat) -> some View {
        self.blur(radius: radius)
            .brightness(0.13)
            .saturation(1.2)
    }
}

struct CompleteBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteBackgroundView()
    }
}
