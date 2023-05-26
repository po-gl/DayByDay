//
//  HorizontalLine.swift
//  DayByDay
//
//  Created by Porter Glines on 2/16/23.
//

import SwiftUI

struct HorizontalLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}
