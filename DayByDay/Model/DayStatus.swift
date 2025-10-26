//
//  DayStatus.swift
//  DayByDay
//
//  Created by Porter Glines on 1/8/23.
//

import Foundation

public struct DayStatus {
  var active = false
  var creative = false
  var productive = false
}

public enum StatusCategory {
  case active
  case creative
  case productive
}

extension DayMO {
  func isActive(for category: StatusCategory) -> Bool {
    switch category {
    case .active:
      return self.active
    case .productive:
      return self.productive
    case .creative:
      return self.creative
    }
  }

  func isComplete() -> Bool {
    return self.isActive(for: .active)
      && self.isActive(for: .creative)
      && self.isActive(for: .productive)
  }

  func toggle(category: StatusCategory) {
    switch category {
    case .active:
      self.active.toggle()
    case .productive:
      self.productive.toggle()
    case .creative:
      self.creative.toggle()
    }
  }
}
