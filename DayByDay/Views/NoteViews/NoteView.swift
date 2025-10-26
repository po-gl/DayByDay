//
//  NoteView.swift
//  DayByDay
//
//  Created by Porter Glines on 3/1/23.
//

import SwiftUI

struct NoteView: View {
  @Environment(\.colorScheme) private var colorScheme
  @Environment(\.managedObjectContext) private var viewContext

  @FetchRequest(fetchRequest: DayData.pastDays(count: 1))
  private var latestDayResult: FetchedResults<DayMO>
  private var latestDay: DayMO? {
    latestDayResult.first?.date?.isToday() ?? false ? latestDayResult.first : nil
  }

  @Binding var showingNoteEditor: Bool

  var body: some View {
    GeometryReader { geometry in
      let scrollOffset: Double = geometry.frame(in: .named("scroll")).minY - 576.0

      VStack(alignment: .leading, spacing: 5) {
        Text("Note")
          .fontDesign(.serif)
          .opacity(0.4)
          .padding(.leading)

        ZStack(alignment: .topLeading) {
          Accent()
          Text(latestDay?.note ?? "")
            .accessibilityIdentifier("NoteTextView")
            .accessibilityAddTraits(.isButton)
            .font(.system(.body, weight: colorScheme == .dark ? .light : .regular))
            .lineSpacing(2.0)
            .padding(.horizontal)
            .contextMenu { NoteContextMenu() }
        }
      }
      .frame(width: 300, height: 150, alignment: .top)
      .mask(
        Rectangle()
          .fill(
            LinearGradient(
              colors: [.black.opacity(0.9), .clear], startPoint: .top, endPoint: .bottom))
      )
      .padding(.top)
      .opacity(latestDay?.note?.isEmpty ?? true ? 0.0 : 1.0 + scrollOffset / 100)
      .contentShape(Rectangle())
      .onTapGesture { showingNoteEditor = true }
      .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
    }
  }

  @ViewBuilder
  private func Accent() -> some View {
    HStack {
      Circle()
        .fill(.orange.gradient)
        .frame(width: 10)
        .opacity(0.7)
        .offset(y: 5)
      Spacer()
    }
  }

  @ViewBuilder
  private func NoteContextMenu() -> some View {
    Button(action: { showingNoteEditor = true }) {
      Label("Edit", systemImage: "note.text")
    }
    Button(
      role: .destructive,
      action: {
        if let latestDay {
          DayData.deleteNote(for: latestDay, context: viewContext)
        }
      }
    ) {
      Label("Delete", systemImage: "trash")
    }
    .accessibilityIdentifier("NoteDeleteContextButton")
  }
}
