//
//  Color+adjust.swift
//  DayByDay
//
//  Created by Porter Glines on 3/16/23.
//

import SwiftUI


extension Color {
    func lighten(by amount: Double = 0.2) -> Color {
        return Color(uiColor: UIColor(self).lighten(by: amount))
    }
    
    func darken(by amount: Double = 0.2) -> Color {
        return Color(uiColor: UIColor(self).darken(by: amount))
    }
}

extension UIColor {
    func lighten(by amount: Double = 0.2) -> UIColor {
        return self.adjust(by: abs(amount))
    }
    
    func darken(by amount: Double = 0.2) -> UIColor {
        return self.adjust(by: -1 * abs(amount))
    }
    
    func adjust(by amount: Double = 0.2) -> UIColor {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return UIColor(red: min(r + amount, 1.0),
                           green: min(g + amount, 1.0),
                           blue: min(b + amount, 1.0), alpha: a)
        } else {
            return self
        }
    }
}
