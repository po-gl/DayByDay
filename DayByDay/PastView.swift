//
//  PastView.swift
//  DayByDay
//
//  Created by Porter Glines on 1/8/23.
//

import SwiftUI

struct PastView: View {
    @Binding var dayStatus: DayStatus
    
    var height = 800.0
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 25) {
                bar(dayStatus.active ? .pink : .gray, geometry)
                bar(dayStatus.productive ? .green : .gray, geometry)
                bar(dayStatus.creative ? .purple : .gray, geometry)
            }
            .position(x: geometry.size.width/2, y: geometry.size.height/2)
        }
        .frame(width: 400, height: height)
    }
    
    private func bar(_ color: Color, _ geometry: GeometryProxy) -> some View {
        let diameter = ButtonCluster.lowerBoundDiameter
        return ZStack {
            Rectangle()
                .cornerRadius(barWidthForScroll(geometry)/2)
                .frame(width: barWidthForScroll(geometry))
                .foregroundStyle(color.gradient)
            VStack {
                Spacer()
                Rectangle()
                    .foregroundStyle(color)
                    .frame(width: diameter, height: height)
                    .offset(y: height - diameter)
            }
        }
    }
    
    private func barWidthForScroll(_ geometry: GeometryProxy) -> Double {
        let diameter = ButtonCluster.lowerBoundDiameter
        let bound = 10.0
        return min(diameter, max(diameter - scrollOffset(geometry) * 0.25, bound))
    }
    
    private func scrollOffset(_ geometry: GeometryProxy) -> Double {
        return geometry.frame(in: .named("scroll")).minY - 580.0
    }
}

struct PastView_Previews: PreviewProvider {
    static var previews: some View {
        Wrapper()
    }
    
    struct Wrapper: View {
        @State var status = DayStatus()
        
        var body: some View {
            ScrollView {
                VStack {
                    Spacer()
                    PastView(dayStatus: $status)
                }
                .frame(width: 400)
            }
            
            .scrollIndicators(.never)
            .ignoresSafeArea(edges: .bottom)
        }
    }
}
