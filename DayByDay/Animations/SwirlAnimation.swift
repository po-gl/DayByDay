//
//  SwirlAnimation.swift
//  DayByDay
//
//  Created by Porter Glines on 1/12/23.
//

import SwiftUI

struct SwirlAnimation: View {
    var imageNames: [String]
    
    init(for category: AnimCategory) {
        switch category {
        case .active:
            imageNames = (0...299).map{ String(format: "ActiveSwirl_%05d", $0) }
        case .creative:
            imageNames = (0...359).map{ String(format: "CreativeSwirl_%05d", $0) }
        case .productive:
            imageNames = (0...419).map{ String(format: "ProductiveSwirl_%05d", $0) }
        case .none:
            imageNames = (0...0).map{ String(format: "ActiveSwirl_%05d", $0) }
        }
    }
    
    var body: some View {
        AnimatedImage(imageNames: imageNames, interval: 0.032, loops: true)
    }
}

enum AnimCategory {
    case active
    case creative
    case productive
    case none
}
