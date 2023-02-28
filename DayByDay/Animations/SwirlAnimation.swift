//
//  SwirlAnimation.swift
//  DayByDay
//
//  Created by Porter Glines on 1/12/23.
//

import SwiftUI

struct SwirlAnimation: View {
    var assetName: String
    
    init(for category: StatusCategory) {
        switch category {
        case .active:
            assetName = "ActiveSwirl"
        case .creative:
            assetName = "CreativeSwirl"
        case .productive:
            assetName = "ProductiveSwirl"
        }
    }
    
    var body: some View {
        AnimationView(name: assetName)
    }
}
