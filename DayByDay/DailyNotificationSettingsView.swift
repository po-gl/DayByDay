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
        ZStack (alignment: .top) {
            VStack {
                TimePicker(hour: $editHour, minute: $editMinute)
                
                Toggle("Daily Reminder", isOn: $editIsOn)
                    .tint(Color(hex: 0xFF7676))
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 12).fill(.thinMaterial))
            }
            .padding(.top, 50)
            .padding()
            NoteHeader()
        }
        .onAppear {
            editIsOn = dailyReminderIsOn
            editHour = dailyReminderHour
            editMinute = dailyReminderMinute
        }
    }
    
    private func saveDailyReminder() {
        dailyReminderIsOn = editIsOn
        dailyReminderHour = editHour
        dailyReminderMinute = editMinute
    }
    
    @ViewBuilder
    private func NoteHeader() -> some View {
        VStack {
            ZStack {
                HStack {
                    Button("Cancel") { dismiss() }
                        .accessibilityIdentifier("NoteDoneButton")
                        .foregroundColor(.orange)
                        .brightness(0.07)
                        .saturation(1.05)
                        .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        saveDailyReminder()
                        dismiss()
                    }) { Text("Save").bold() }
                    .accessibilityIdentifier("NoteDoneButton")
                    .foregroundColor(.orange)
                    .brightness(0.07)
                    .saturation(1.05)
                    .padding()
                }
                Text("Reminder Settings")
            }
            .frame(height: 50)
            .background(.thinMaterial)
            Spacer()
        }
    }
}
