//
//  Comparable+Clamped.swift
//  DayByDay
//
//  Created by Porter Glines on 3/8/23.
//

import Foundation

extension Comparable {
  func clamped(to limits: ClosedRange<Self>) -> Self {
    return min(max(self, limits.lowerBound), limits.upperBound)
  }
}
