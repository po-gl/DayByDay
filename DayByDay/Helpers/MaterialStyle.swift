//
//  MaterialStyle.swift
//  DayByDay
//
//  Created by Porter Glines on 2/23/23.
//

import Foundation
import SwiftUI

struct MaterialStyle: ButtonStyle {
    let radius = 30.0
    
    func makeBody(configuration: Configuration) -> some View {
        RoundedRectangle(cornerRadius: radius)
            .fill(.thinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .fill(.white)
                    .opacity(configuration.isPressed ? 0.3 : 0)
            )
            .overlay(
                configuration.label
                    .foregroundColor(.primary)
            )
    }
}
