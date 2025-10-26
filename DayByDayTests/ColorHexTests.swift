//
//  ColorHexTests.swift
//  DayByDayTests
//
//  Created by Porter Glines on 2/25/23.
//

import SwiftUI
import XCTest

final class ColorHexTests: XCTestCase {

  func testRedishColor() throws {
    let color = Color(hex: 0xE63C5C)
    var r: CGFloat
    var g: CGFloat
    var b: CGFloat
    var a: CGFloat
    (r, g, b, a) = (0, 0, 0, 0)
    UIColor(color).getRed(&r, green: &g, blue: &b, alpha: &a)

    XCTAssertEqual(r, 0.9019607901573181)
    XCTAssertEqual(g, 0.23529410362243652)
    XCTAssertEqual(b, 0.36078429222106934)
    XCTAssertEqual(a, 1.0)
  }

  func testGreenishColor() throws {
    let color = Color(hex: 0x97D327)
    var r: CGFloat
    var g: CGFloat
    var b: CGFloat
    var a: CGFloat
    (r, g, b, a) = (0, 0, 0, 0)
    UIColor(color).getRed(&r, green: &g, blue: &b, alpha: &a)

    XCTAssertEqual(r, 0.5921568870544434)
    XCTAssertEqual(g, 0.8274509906768799)
    XCTAssertEqual(b, 0.15294113755226135)
    XCTAssertEqual(a, 1.0)
  }
}
