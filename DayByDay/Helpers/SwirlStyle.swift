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
                    .mask(
                    Circle()
                        .fill(.white)
                        .opacity(configuration.isPressed ? 0.7 : 1.0)
                    )
            )
            .overlay(
                configuration.label
                    .foregroundColor(.primary)
            )
    }
}
