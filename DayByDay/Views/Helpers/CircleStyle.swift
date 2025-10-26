//
//  CircleStyle.swift
//  DayByDay
//
//  Created by Porter Glines on 1/7/23.
//

import Foundation
import SwiftUI

struct CircleStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    Circle()
      .fill()
      .overlay(
        Circle()
          .fill(.white)
          .opacity(configuration.isPressed ? 0.3 : 0)
      )
      .overlay(
        configuration.label
          .foregroundColor(.primary)
      )
  }
}
