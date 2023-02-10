//
//  LinearGradient+ForCategory.swift
//  DayByDay
//
//  Created by Porter Glines on 2/9/23.
//

import SwiftUI

extension LinearGradient {
    init(for category: StatusCategory) {
        switch category {
        case .active:
            self.init(stops: [.init(color: Color(hex: 0xE69F1E), location: 0.0),
                              .init(color: Color(hex: 0xF23336), location: 0.2),
                              .init(color: Color(hex: 0xB04386), location: 0.8),
                              .init(color: Color(hex: 0xB3F2B7), location: 1.0)],
                      startPoint: .leading, endPoint: .trailing)
        case .productive:
            self.init(stops: [.init(color: Color(hex: 0xC62379), location: 0.0),
                              .init(color: Color(hex: 0xF77756), location: 0.2),
                              .init(color: Color(hex: 0xA8E712), location: 0.6),
                              .init(color: Color(hex: 0xD8F7EC), location: 1.1)],
                      startPoint: .leading, endPoint: .trailing)
        case .creative:
            self.init(stops: [.init(color: Color(hex: 0xFCEBD6), location: 0.0),
                              .init(color: Color(hex: 0xBAE1E5), location: 0.2),
                              .init(color: Color(hex: 0xC96FC3), location: 0.5),
                              .init(color: Color(hex: 0xC33FDB), location: 0.8),
                              .init(color: Color(hex: 0xF0BE83), location: 1.1)],
                      startPoint: .leading, endPoint: .trailing)
        }
    }
}
