//
//  WaveView.swift
//  DayByDay
//
//  Created by Porter Glines on 3/6/23.
//

import SwiftUI

struct WaveView: View {
    @Environment(\.colorScheme) private var colorScheme

    @State var moving = false
    
    private var brightenBy: Double {
        return colorScheme == .dark ? -0.05 : 0.15
    }
    private var saturateBy: Double {
        return colorScheme == .dark ? 0.7 : 0.8
    }
    
    var body: some View {
        Wave()
            .onAppear() {
                withAnimation {
                    moving.toggle()
                }
            }
            .parallaxMotion(magnitude: 20)
    }
    
    @ViewBuilder
    private func Wave() -> some View {
        ZStack {
            WavePath()
                .stroke(Color(hex: 0x228FD8), style: StrokeStyle(lineWidth: 50))
                .blurAndBrighten(radius: 30, brightenBy, saturateBy)
            ColorBlobs()
        }
        .mask {
            ZStack {
                WaveMask(offset: 20)
                WaveMask(offset: 80)
                WaveMask(offset: 160)
                WaveMask(offset: 240)
                Circle()
                    .scaleEffect(2.0)
                    .offset(x: moving ? 1000 : -1000, y: moving ? -100 : 180)
                    .animation(.easeInOut(duration: 20.0).repeatForever(autoreverses: false), value: moving)
                    .blur(radius: 100)
                    .blendMode(.destinationOut)
            }
        }
    }
    
    @ViewBuilder
    private func WaveMask(offset: Double) -> some View {
        WavePath()
            .stroke(style: StrokeStyle(lineWidth: 100))
            .offset(y: offset)
    }
    
    @ViewBuilder
    private func ColorBlobs() -> some View {
        Circle() // white bottom
            .fill(Color(hex: 0xD4EEE6))
            .opacity(0.7)
            .scaleEffect(x: 1.6, y: 0.7)
            .rotationEffect(.degrees(-25))
            .offset(x: 0, y: 50)
            .blurAndBrighten(radius: 30, brightenBy, saturateBy)
        
        Circle() // purple right
            .fill(Color(hex: 0x6160B6))
            .scaleEffect(0.3)
            .offset(x: 200, y: moving ? -100 : -50)
            .animation(.easeInOut(duration: 12.0).repeatForever(), value: moving)
            .blurAndBrighten(radius: 20, brightenBy, saturateBy)
        Circle() // tan right
            .fill(Color(hex: 0xF6C0A0))
            .scaleEffect(0.3)
            .offset(x: 200, y: moving ? -140 : -160)
            .animation(.easeInOut(duration: 8.0).repeatForever(), value: moving)
            .blurAndBrighten(radius: 35, brightenBy, saturateBy)
        Circle() // blue middle left
            .fill(Color(hex: 0x44B9CF))
            .scaleEffect(x: 0.9, y: 0.5)
            .offset(x: -70, y: -10)
            .blurAndBrighten(radius: 20, brightenBy, saturateBy)
        Circle() // black middle left
            .fill(Color(hex: 0x0D2C31))
            .scaleEffect(0.3)
            .offset(x: moving ? -90 : -70, y: -60)
            .animation(.easeInOut(duration: 9.0).repeatForever(), value: moving)
            .blurAndBrighten(radius: 35, brightenBy, saturateBy)
    }
}

struct WavePath: Shape {
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath()
        
        let curveMinX = rect.minX - 80
        let curveMaxX = rect.maxX + 80
        
        let curveMaxY = rect.maxY + 80
        let curveMinY = rect.maxY/4 - 80
        
        path.move(to: CGPoint(x: curveMinX, y: curveMaxY))
        
        path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.midY), controlPoint: CGPoint(x: rect.minX, y: rect.midY))
        
        path.addQuadCurve(to: CGPoint(x: curveMaxX, y: curveMinY), controlPoint: CGPoint(x: rect.maxX, y: rect.midY))
        return Path(path.cgPath)
    }
}
