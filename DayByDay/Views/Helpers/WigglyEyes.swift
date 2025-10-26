//
//  WigglyEyes.swift
//  DayByDay
//
//  Created by Porter Glines on 2/9/23.
//

import SwiftUI

struct WigglyEyes: View {
  let barWidth: Double
  var width = 38.0
  var depth = 8.0

  var delay = 0.0

  var size = 7.0
  let offset = -1.0

  @State var blink = false
  @State var cancelBlink = false

  var body: some View {
    HStack {
      Circle()
        .frame(width: size)
        .shadow(radius: 5)
        .padding(.trailing, width)
        .scaleEffect(y: blink ? 0.1 : 1.0)
      Circle()
        .frame(width: size)
        .shadow(radius: 5)
        .scaleEffect(y: blink ? 0.1 : 1.0)
    }
    .frame(width: barWidth)
    .padding(.top, depth)
    .onAppear {
      cancelBlink = false
      DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        startAnimation()
      }
    }
    .onDisappear {
      cancelBlink = true
    }
  }

  private func startAnimation() {
    let openLength = Double.random(in: 3.0..<4.0)
    let blinkLength = 0.2
    DispatchQueue.main.asyncAfter(deadline: .now() + openLength) {
      withAnimation(.easeIn(duration: 0.1)) {
        blink = true
      }
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + openLength + blinkLength) {
      withAnimation(.easeIn(duration: 0.1)) {
        blink = false
        guard !cancelBlink else { return }
        startAnimation()
      }
    }
  }
}
