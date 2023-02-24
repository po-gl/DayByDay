//
//  TopButtons.swift
//  DayByDay
//
//  Created by Porter Glines on 2/21/23.
//

import SwiftUI
import HorizonCalendar

struct TopButtons: View {
    @State var showingCalendar = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: { showingCalendar = true }) {
                    Image(systemName: "calendar")
                        .opacity(0.8)
                }
                .buttonStyle(MaterialStyle())
                .frame(width: 50, height: 32)
                .padding(.top, 20)
                .padding(.trailing, 40)
                .sheet(isPresented: $showingCalendar) {
                    ZStack {
                        DaysCalendarView()
                        CalendarHeader()
                    }
                }
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    private func CalendarHeader() -> some View {
        VStack {
            HStack {
                Button("Cancel") { showingCalendar = false }
                    .foregroundColor(Color(hex: 0xBE59D5))
                    .brightness(0.07)
                    .saturation(1.05)
                    .padding()
                Spacer()
            }
            .frame(height: 65)
            .background(.thinMaterial)
            Spacer()
        }
    }
}

extension CalendarViewRepresentable {
    
}
