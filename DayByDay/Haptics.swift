//
//  Haptics.swift
//  DayByDay
//
//  Created by Porter Glines on 1/9/23.
//

import UIKit

public func basicHaptic() {
  let generator = UIImpactFeedbackGenerator(style: .medium)
  generator.impactOccurred()
}

public func heavyHaptic() {
  let generator = UIImpactFeedbackGenerator(style: .heavy)
  generator.impactOccurred()
}

public func completeHaptic() {
  let generator = UINotificationFeedbackGenerator()
  generator.notificationOccurred(.success)
  let generator2 = UIImpactFeedbackGenerator(style: .heavy)
  generator2.impactOccurred()
}
