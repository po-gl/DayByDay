//
//  Haptics.swift
//  DayByDay
//
//  Created by Porter Glines on 1/9/23.
//

import Foundation
import CoreHaptics
import UIKit

public func basicHaptic() {
    let generator = UIImpactFeedbackGenerator(style: .medium)
    generator.impactOccurred()
}

public func completeHaptic() {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.success)
}
