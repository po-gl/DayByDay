//
//  WigglyEyes.swift
//  DayByDay
//
//  Created by Porter Glines on 2/9/23.
//

import SwiftUI

struct WigglyEyes: View {
    let barWidth: Double
    
    var eyeSize = 7.0
    var eyeWidth = 38.0
    var eyeDepth = 8.0
    
    let animateOffset = 2.0
    let offset = 4.0
    
    @State var animate = false
    
    var body: some View {
        VStack {
            HStack(spacing: 25) {
                pairOfEyes(width: eyeWidth +  0, depth: eyeDepth +  0)
                    .offset(x: offset)
                    .offset(x: animate ? -animateOffset : animateOffset)
                pairOfEyes(width: eyeWidth + 20, depth: eyeDepth + 10)
                    .offset(x: animate ? -animateOffset : animateOffset)
                pairOfEyes(width: eyeWidth +  0, depth: eyeDepth - 10)
                    .offset(x: -offset)
                    .offset(x: animate ? animateOffset : -animateOffset)
            }
            Spacer()
        }
        .onAppear { animate = true }
        .animation(.easeInOut(duration: 1.0).repeatForever(), value: animate)
    }
    
    @ViewBuilder
    private func pairOfEyes(width: Double, depth: Double) -> some View {
        HStack {
            Circle()
                .frame(width: eyeSize)
                .shadow(radius: 5)
                .padding(.trailing, width)
            Circle()
                .frame(width: eyeSize)
                .shadow(radius: 5)
        }
        .frame(width: barWidth)
        .padding(.top, depth)
    }
}
