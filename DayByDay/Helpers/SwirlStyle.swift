//
//  SwirlStyle.swift
//  DayByDay
//
//  Created by Porter Glines on 1/12/23.
//

import Foundation
import SwiftUI

struct SwirlStyle: ButtonStyle {
    
    var category: StatusCategory
    
    func makeBody(configuration: Configuration) -> some View {
        Circle()
            .fill(.white)
            .overlay(
                SwirlAnimation(for: category)
                    .mask(Circle().opacity(configuration.isPressed ? 0.7 : 1.0))
                    .background(
                        BackgroundFrame(for: category)
                            .mask(Circle())
                    )
            )
            .overlay(
                configuration.label
                    .foregroundColor(.primary)
            )
    }
    
    @ViewBuilder
    private func BackgroundFrame(for category: StatusCategory) -> some View {
        switch category {
        case .active:
            Image("ActiveSwirl").resizable()
        case .creative:
            Image("CreativeSwirl").resizable()
        case .productive:
            Image("ProductiveSwirl").resizable()
        }
    }
}
