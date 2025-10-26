//
//  View+ParallaxMotion.swift
//  DayByDay
//
//  Created by Porter Glines on 3/7/23.
//

import CoreMotion
import SwiftUI

extension View {
  func parallaxMotion(magnitude: Double = 10) -> some View {
    ModifiedContent(
      content: self,
      modifier: ParallaxMotionModifier(magnitude: magnitude, manager: MotionManager.shared))
  }
}

struct ParallaxMotionModifier: ViewModifier {
  var magnitude: Double
  @ObservedObject var manager: MotionManager

  func body(content: Content) -> some View {
    content
      .offset(
        x: manager.roll.clamped(to: 0.0...1.0) * magnitude,
        y: manager.pitch.clamped(to: 0.0...1.0) * magnitude)
  }
}

class MotionManager: ObservableObject {
  @Published var pitch: Double = 0.0
  @Published var roll: Double = 0.0

  static let shared = MotionManager()

  private var manager: CMMotionManager

  init() {
    manager = CMMotionManager()
    manager.deviceMotionUpdateInterval = 1 / 60

    manager.startDeviceMotionUpdates(to: .main) { (motionData, error) in
      guard error == nil else {
        print("Motion error \(error!)")
        return
      }

      if let motionData {
        self.pitch = motionData.attitude.pitch
        self.roll = motionData.attitude.roll
      }
    }
  }
}
