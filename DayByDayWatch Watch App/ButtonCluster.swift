//
//  ButtonCluster.swift
//  DayByDayWatch Watch App
//
//  Created by Porter Glines on 1/16/23.
//

import CoreData
import SwiftUI

struct ButtonCluster: View {
  @Environment(\.managedObjectContext) private var viewContext

  @FetchRequest(sortDescriptors: [SortDescriptor(\DayMO.date, order: .reverse)])
  private var allDays: FetchedResults<DayMO>
  private var latestDay: DayMO? {
    return allDays.count > 0 ? allDays[0] : nil
  }

  @Binding public var dayStatus: DayStatus

  let diameter = 70.0
  let fontSize = 12.0

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        if dayStatus.active && dayStatus.creative && dayStatus.productive {
          CompleteBackgroundView()
            .scaleEffect(0.8)
            .brightness(0.40)
            .blur(radius: 10)
        }

        button("Active", status: .active, startAngle: .topLeft, geometry: geometry) {
          withAnimation(.easeOut(duration: 0.3)) {
            dayStatus.active.toggle()
            saveDay()
            haptic()
          }
        }
        .saturation(dayStatus.active ? 1.0 : 0.0)
        .position(startingPosition(for: .topLeft, geometry))

        button("Creative", status: .creative, startAngle: .topRight, geometry: geometry) {
          withAnimation(.easeOut(duration: 0.3)) {
            dayStatus.creative.toggle()
            saveDay()
            haptic()
          }
        }
        .saturation(dayStatus.creative ? 1.0 : 0.0)
        .position(startingPosition(for: .topRight, geometry))

        button("Productive", status: .productive, startAngle: .bottom, geometry: geometry) {
          withAnimation(.easeOut(duration: 0.3)) {
            dayStatus.productive.toggle()
            saveDay()
            haptic()
          }
        }
        .saturation(dayStatus.productive ? 1.0 : 0.0)
        .position(startingPosition(for: .bottom, geometry))
      }
      .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
    }
    .frame(width: 200, height: 200)
  }

  private func saveDay() {
    if latestDay?.date?.hasSame(.day, as: Date()) ?? false {
      viewContext.delete(latestDay!)
    }
    let newItem = DayMO(context: viewContext)
    newItem.date = Date()
    newItem.active = dayStatus.active
    newItem.creative = dayStatus.creative
    newItem.productive = dayStatus.productive
    do {
      try viewContext.save()
    } catch {
      // Replace this implementation with code to handle the error appropriately.
      // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      let nsError = error as NSError
      fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
  }

  private func haptic() {
    if dayStatus.active && dayStatus.creative && dayStatus.productive {
      completeHaptic()
    } else {
      basicHaptic()
    }
  }

  private func button(
    _ text: String, status: StatusCategory, startAngle: AngleStart, geometry: GeometryProxy,
    action: @escaping () -> Void
  ) -> some View {
    return Button(action: action) {
      CircleLabelView(
        radius: diameter / 2,
        size: CGSize(width: diameter + fontSize * 2 + 5, height: diameter + fontSize * 2 + 5),
        startAngle: startAngle, text: text
      )
      .font(.system(size: fontSize, weight: .semibold, design: .monospaced))
    }
    .buttonStyle(SwirlStyle(category: status))
    .frame(width: diameter, height: diameter)
  }

  private func startingPosition(for startAngle: AngleStart, _ geometry: GeometryProxy) -> CGPoint {
    let padding = 5.0
    let frameX = geometry.frame(in: .local).width
    let frameY = geometry.frame(in: .local).height
    switch startAngle {
    case .topLeft:
      return CGPoint(x: frameX / 3 - padding, y: frameY / 3)
    case .topRight:
      return CGPoint(x: frameX - frameX / 3 + padding, y: frameY / 3)
    case .bottom:
      return CGPoint(x: frameX / 2, y: frameY - frameY / 3 + padding - 3)
    case .top:
      return CGPoint()
    }
  }
}
