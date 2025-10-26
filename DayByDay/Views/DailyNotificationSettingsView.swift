//
//  DailyNotificationSettingsView.swift
//  DayByDay
//
//  Created by Porter Glines on 5/19/23.
//

import SwiftUI

struct DailyNotificationSettingsView: View {
  @Environment(\.dismiss) private var dismiss
  @AppStorage("dailyReminderIsOn") private var dailyReminderIsOn = true
  @AppStorage("dailyReminderHour") private var dailyReminderHour = 20
  @AppStorage("dailyReminderMinute") private var dailyReminderMinute = 15

  @State private var editIsOn: Bool = true
  @State private var editHour: Int = 20
  @State private var editMinute: Int = 15

  var body: some View {
    NavigationStack {
      VStack {
        TimePicker(hour: $editHour, minute: $editMinute)

        Toggle("Daily Reminder", isOn: $editIsOn)
          .tint(.pinkish)
          .padding(8)
          .background(RoundedRectangle(cornerRadius: 12).fill(.thinMaterial))

        Spacer()
      }
      .padding()
      .onAppear {
        editIsOn = dailyReminderIsOn
        editHour = dailyReminderHour
        editMinute = dailyReminderMinute
      }
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          cancelButton
        }
        ToolbarItem(placement: .topBarTrailing) {
          if hasChanges {
            saveButton
          }
        }
      }
      .navigationTitle("Reminder Settings")
      .navigationBarTitleDisplayMode(.inline)
    }
  }

  private func saveDailyReminder() {
    dailyReminderIsOn = editIsOn
    dailyReminderHour = editHour
    dailyReminderMinute = editMinute
  }

  private var hasChanges: Bool {
    return dailyReminderIsOn != editIsOn
      || dailyReminderHour != editHour
      || dailyReminderMinute != editMinute
  }

  @ViewBuilder private var cancelButton: some View {
    Button(
      action: {
        dismiss()
      },
      label: {
        Image(systemName: "chevron.backward")
          .brightness(0.07)
          .saturation(1.05)
      }
    )
    .accessibilityIdentifier("NotificationSettingsCancelButton")
    .tint(.orange)
  }

  @ViewBuilder private var saveButton: some View {
    Button(
      action: {
        saveDailyReminder()
        dismiss()
      },
      label: {
        Image(systemName: "checkmark")
          .brightness(0.07)
          .saturation(1.05)
      }
    )
    .accessibilityIdentifier("NotificationSettingsSaveButton")
    .tint(.pinkish)
    .buttonStyle(.glassProminent)
  }
}

#Preview {
  DailyNotificationSettingsView()
}
