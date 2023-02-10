//
//  WigglyBar.swift
//  DayByDay
//
//  Created by Porter Glines on 2/9/23.
//

import SwiftUI

struct WigglyBar: View {
    let category: StatusCategory
    let width: Double
    let geometry: GeometryProxy
    
    @State var animate = false
    
    var frequency: Double = 100.0
    var amplitude: Double = 3.0
    
    var body: some View {
        ZStack {
            ZStack {
                WigglyPath(frequency: frequency, amplitude: amplitude)
                    .stroke(LinearGradient(for: category), style: StrokeStyle(lineWidth: width-amplitude-2, lineCap: .round))
                    .frame(width: width-amplitude-2)
                    .scaleEffect(y: 1.5)
                    .offset(y: animate ? geometry.size.height/frequency * .pi*2 * 1.5: 0)
                    .zIndex(2)
                VStack {
                    VerticalLine()
                        .stroke(LinearGradient(for: category), style: StrokeStyle(lineWidth: width, lineCap: .round))
                        .frame(width: width, height: 4)
                    Spacer()
                }
            }
            .mask {
                VerticalLine()
                    .stroke(.black, style: StrokeStyle(lineWidth: width, lineCap: .round))
                    .frame(width: width)
            }
        }
        .onAppear { animate = true }
        .animation(.linear(duration: 2.0).repeatForever(autoreverses: false), value: animate)
    }
}


struct WigglyPath: Shape {
    var frequency: Double = 60.0
    var amplitude: Double = 3.0
    
    func path(in rect: CGRect) -> Path {
        var path = UIBezierPath()
        path.move(to: CGPoint(x: rect.midX, y: 0))
        wiggle(path: &path, in: rect)
        return Path(path.cgPath)
    }
    
    private func wiggle(path: inout UIBezierPath, in rect: CGRect) {
        let wavelength = rect.height / frequency

        for y in stride(from: 0, through: rect.height, by: 5) {
            let relativeY = y / wavelength
            let sine = sin(relativeY)
            let x = amplitude * sine + rect.width/2
            path.addLine(to: CGPoint(x: x, y: y))
        }
    }
}

struct VerticalLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: 0))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.height))
        return path
    }
}
