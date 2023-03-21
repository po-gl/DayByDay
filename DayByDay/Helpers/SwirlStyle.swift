//
//  SwirlStyle.swift
//  DayByDay
//
//  Created by Porter Glines on 1/12/23.
//

import Foundation
import SwiftUI

struct SwirlStyle: ButtonStyle {
    @Environment(\.colorScheme) private var colorScheme
    
    var category: StatusCategory
    var isOn: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        Circle()
            .fill(.background)
            .overlay(
                SwirlAnimation(for: category)
                    .mask(Circle().opacity(configuration.isPressed ? 0.7 : 1.0))
                    .background( BackgroundFrame(for: category).mask(Circle()) )
                
                    .saturation(isOn ? 1.0 : 0.8)
                    .brightness(isOn ? colorScheme == .dark ? 0.0 : 0.05
                                     : colorScheme == .dark ? -0.1 : 0.08)
                
                    .overlay(
                        Circle()
                            .fill(colorScheme == .dark ? .black : .white)
                            .opacity(isOn ? 0.0 : 0.35)
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
