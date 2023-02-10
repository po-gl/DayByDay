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
    
    var body: some View {
        VStack {
            HStack(spacing: 25) {
                HStack {
                    Circle()
                        .frame(width: eyeSize)
                        .padding(.trailing, eyeWidth)
                    Circle()
                        .frame(width: eyeSize)
                }
                .frame(width: barWidth)
                .padding(.top, eyeDepth)
                HStack {
                    Circle()
                        .frame(width: eyeSize)
                        .padding(.trailing, eyeWidth + 20)
                    Circle()
                        .frame(width: eyeSize)
                }
                .frame(width: barWidth)
                .padding(.top, eyeDepth + 10)
                HStack {
                    Circle()
                        .frame(width: eyeSize)
                        .padding(.trailing, eyeWidth)
                    Circle()
                        .frame(width: eyeSize)
                }
                .frame(width: barWidth)
                .padding(.top, eyeDepth - 10)
            }
            Spacer()
        }
    }
}
