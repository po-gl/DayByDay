//
//  Haptics.swift
//  DayByDay
//
//  Created by Porter Glines on 1/9/23.
//

import Foundation
import CoreHaptics
import UIKit


class Haptics {
    private var engine: CHHapticEngine?
    
    public func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the haptics engine: \(error.localizedDescription)")
        }
    }
    
    
    public func workHaptic() {
        multiHaptic(4, 0.1, 0.07, 0.5, 1.0)
    }
    
    
    private func multiHaptic(_ count: Int,
                     _ duration: Double, _ seperationDuration: Double,
                     _ intensity: Float, _ sharpness: Float) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        var events: [CHHapticEvent] = []
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
        for i in 0..<count {
            events.append(CHHapticEvent(eventType: .hapticContinuous,
                                        parameters: [intensity, sharpness],
                                        relativeTime: Double(i) * (duration + seperationDuration),
                                        duration: duration))
        }
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0.0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription)")
        }
    }
}

public func basicHaptic() {
    let generator = UIImpactFeedbackGenerator(style: .medium)
    generator.impactOccurred()
}

public func completeHaptic() {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.success)
}
