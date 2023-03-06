//
//  CircleLabelView.swift
//  DayByDay
//
//  Created by Porter Glines on 1/8/23.
//

import SwiftUI
import Shiny

struct CircleLabelView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var radius: Double
    var kerning: CGFloat = 4
    var size = CGSize(width: 300, height: 300)
    var startAngle: AngleStart = .topRight
    var text: String
    
    private var chars: [(offset: Int, element: Character)] {
        return Array(text.enumerated())
    }
    
    @State private var textWidths: [Int:Double] = [:]
    
    var body: some View {
        ZStack {
            ForEach(chars, id: \.offset) { index, letter in
                VStack {
                    Text(String(letter))
                        .kerning(kerning)
                        .background(Sizeable())
                        .onPreferenceChange(WidthPreferenceKey.self, perform: { width in
                            textWidths[index] = width
                        })
                    Spacer()
                }
                .rotationEffect(angle(at: index))
            }
        }
        .frame(width: size.width, height: size.height)
        .rotationEffect(angle(for: startAngle))
        .shiny(colorScheme == .dark ? .glossy(.gray) : .matte(.black))
        .allowsHitTesting(false)
    }
    
    func angle(at index: Int) -> Angle {
        guard let labelWidth = textWidths[index] else { return .radians(0) }
        
        let circumference = radius * 2 * .pi
        
        let percent = labelWidth / circumference
        let labelAngle = percent * 2 * .pi
        
        let widthBeforeLabel = textWidths.filter{ $0.key < index }.map{ $0.value }.reduce(0, +)
        let percentBeforeLabel = widthBeforeLabel / circumference
        let angleBeforeLabel = percentBeforeLabel * 2 * .pi
        
        return .radians(angleBeforeLabel + labelAngle)
    }
    
    func angle(for start: AngleStart) -> Angle {
        switch start {
        case .topRight:
            return .radians(0.262)
        case .topLeft:
            return -angle(at: chars.count-1) + .radians(-0.262)
        case .bottom:
            return -angle(at: chars.count-1) / 2 + .radians(.pi)
        case .top:
            return -angle(at: chars.count-1) / 2
        }
    }
}

struct WidthPreferenceKey: PreferenceKey {
    static var defaultValue: Double = 0
    static func reduce(value: inout Double, nextValue: () -> Double) {
        value = nextValue()
    }
}

struct Sizeable: View {
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: WidthPreferenceKey.self, value: geometry.size.width)
        }
    }
}

enum AngleStart {
    case topRight
    case topLeft
    case bottom
    case top
}

struct CircleLabelView_Previews: PreviewProvider {
    static var previews: some View {
        CircleLabelView(radius: 150, kerning: 4, size: CGSize(width: 400, height: 400), startAngle: .bottom, text: "Activity")
            .font(.system(size: 20, weight: .semibold, design: .monospaced))
        CircleLabelView(radius: 150, kerning: 4, size: CGSize(width: 400, height: 400), text: "send me to the mountains, let me go free forever")
            .font(.system(size: 20, weight: .semibold, design: .monospaced))
    }
}
