//
//  BurstAnimation.swift
//  DayByDay
//
//  Created by Porter Glines on 1/13/23.
//

import SwiftUI

struct BurstAnimation: View {
    var imageNames: [String]
    
    init() {
        imageNames = (0...119).map{ String(format: "Burst_%05d", $0) }
    }
    
    var body: some View {
        AnimatedImage(imageNames: imageNames, interval: 0.006, loops: false)
    }
}
