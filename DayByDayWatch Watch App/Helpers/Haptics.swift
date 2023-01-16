//
//  Haptics.swift
//  DayByDayWatch Watch App
//
//  Created by Porter Glines on 1/16/23.
//

import Foundation
import WatchKit

func basicHaptic() {
    WKInterfaceDevice.current().play(.click)
}

func completeHaptic() {
    WKInterfaceDevice.current().play(.success)
}
