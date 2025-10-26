//
//  TopButtons.swift
//  DayByDay
//
//  Created by Porter Glines on 2/21/23.
//

import HorizonCalendar
import SwiftUI

struct TopButtons: View {
  @Binding var showingNoteEditor: Bool
  @State var showingDailyNotificationSettings = false

  @FetchRequest(fetchRequest: DayData.pastDays(count: 1))
  private var latestDayResult: FetchedResults<DayMO>
  private var latestDay: DayMO? {
    latestDayResult.first?.date?.isToday() ?? false ? latestDayResult.first : nil
  }

  var body: some View {
    VStack {
      HStack {
        DailyNotificationButton()
        Spacer()
        NoteButton()
        CalendarButton()
      }
      .padding(.top, 20)
      .padding(.horizontal, 30)
      Spacer()
    }
  }

  @ViewBuilder
  private func DailyNotificationButton() -> some View {
    Button(action: { showingDailyNotificationSettings = true }) {
      Image(systemName: "clock")
    }
    .accessibilityIdentifier("DailyNotificationButton")
    .buttonStyle(.glass)
    .tint(.active)
    .frame(width: 50, height: 32)
    .sheet(isPresented: $showingDailyNotificationSettings) {
      DailyNotificationSettingsView()
        .presentationDetents([.medium, .large])
    }
  }

  @ViewBuilder
  private func NoteButton() -> some View {
    Button(action: { showingNoteEditor = true }) {
      Image(systemName: "square.and.pencil")
    }
    .accessibilityIdentifier("NoteButton")
    .buttonStyle(.glass)
    .tint(.active)
    .frame(width: 50, height: 32)
    .sheet(isPresented: $showingNoteEditor) {
      NoteEditorView(date: Date(), day: latestDay)
        .presentationDetents([.medium, .large])
    }
  }

  @ViewBuilder
  private func CalendarButton() -> some View {
    NavigationLink(destination: {
      DaysCalendarView()
        .accessibilityIdentifier("CalendarView")
        .ignoresSafeArea(.container, edges: .top)
        .navigationTitle("Calendar")
        .navigationBarTitleDisplayMode(.large)

        .toolbar {
          PastNotesButton()
        }
    }) {
      Image(systemName: "calendar")
    }
    .accessibilityIdentifier("CalendarButton")
    .buttonStyle(.glass)
    .tint(.active)
    .frame(width: 50, height: 32)
  }

  @ViewBuilder
  private func PastNotesButton() -> some View {
    NavigationLink(destination: {
      PastNotes()
    }) {
      Image(systemName: "note.text")
    }
  }
}

private let dayFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.setLocalizedDateFormatFromTemplate("EEEE MMM d YYYY")
  return formatter
}()
