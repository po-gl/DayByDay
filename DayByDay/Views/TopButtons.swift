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

  @State private var animateButtons: Bool = false
  @Namespace private var namespace

  @FetchRequest(fetchRequest: DayData.pastDays(count: 1))
  private var latestDayResult: FetchedResults<DayMO>
  private var latestDay: DayMO? {
    latestDayResult.first?.date?.isToday() ?? false ? latestDayResult.first : nil
  }

  var body: some View {
    VStack {
      GlassEffectContainer {
        HStack(spacing: 0) {
          DailyNotificationButton()
          Spacer()
          if (animateButtons) {
            NoteButton()
              .glassEffectID("note", in: namespace)
          }
          CalendarButton()
            .glassEffectID("calendar", in: namespace)
        }
        .padding(.top, 20)
        .padding(.horizontal, 30)
        Spacer()
      }
    }
    .onAppear {
      withAnimation {
        animateButtons = true
      }
    }
  }

  @ViewBuilder
  private func DailyNotificationButton() -> some View {
    Button(action: { showingDailyNotificationSettings = true }) {
      Image(systemName: "clock")
        .font(.title2)
        .padding(2)
    }
    .accessibilityIdentifier("DailyNotificationButton")
    .tint(.active)
    .buttonStyle(.glass)
    .buttonBorderShape(.circle)
    .contentShape(.circle)
    .sheet(isPresented: $showingDailyNotificationSettings) {
      DailyNotificationSettingsView()
        .presentationDetents([.medium, .large])
    }
  }

  @ViewBuilder
  private func NoteButton() -> some View {
    Button(action: { showingNoteEditor = true }) {
      Image(systemName: "square.and.pencil")
        .font(.title2)
        .padding(2)
    }
    .accessibilityIdentifier("NoteButton")
    .tint(.active)
    .buttonStyle(.glass)
    .buttonBorderShape(.circle)
    .contentShape(.circle)
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
        .font(.title2)
        .padding(3)
    }
    .accessibilityIdentifier("CalendarButton")
    .tint(.active)
    .buttonStyle(.glass)
    .buttonBorderShape(.circle)
    .contentShape(.circle)
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
