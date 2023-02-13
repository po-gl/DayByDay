//
//  Arrow.swift
//  DayByDay
//
//  Created by Porter Glines on 2/12/23.
//

import SwiftUI

struct Arrow: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var animate = false
    
    let gradient = LinearGradient(stops: [.init(color: .primary, location: 0.0),
                                          .init(color: .primary.opacity(0.3), location: 1.0)],
                                  startPoint: .leading, endPoint: .trailing)
    
    var body: some View {
        GeometryReader { geometry in
            Image(systemName: "arrowshape.forward.fill")
                .foregroundStyle(gradient)
                .font(.system(size: 30))
                .rotationEffect(.degrees(90))
                .offset(y: 10)
                .opacity(animate ? getOpacity(geometry) : 0.0)
                .onAppear {
                    animate = true
                }
                .animation(.easeInOut(duration: 3).repeatForever(), value: animate)
                .position(x: geometry.size.width/2, y: geometry.size.height/2)
        }
    }
    
    private func getOpacity(_ geometry: GeometryProxy) -> Double {
        let offset = scrollOffset(geometry)
        let opacity = colorScheme == .light ? 0.4 : 0.7
        if offset < 0 {
            return max(0, opacity + offset/1000)
        }
        return opacity
    }
    
    private func scrollOffset(_ geometry: GeometryProxy) -> Double {
        return geometry.frame(in: .named("scroll")).minY - 576.0
    }
}
