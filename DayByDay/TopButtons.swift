//
//  TopButtons.swift
//  DayByDay
//
//  Created by Porter Glines on 2/21/23.
//

import SwiftUI
import HorizonCalendar

struct TopButtons: View {
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                NavigationLink(destination: DaysCalendarView()) {
                    CalendarButton()
                }
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    private func CalendarButton() -> some View {
        Image(systemName: "calendar")
            .foregroundColor(.primary)
            .frame(width: 50, height: 32)
            .opacity(0.8)
            .background(RoundedRectangle(cornerRadius: 30).foregroundStyle(.thinMaterial))
            .padding(.top, 20)
            .padding(.trailing, 40)
    }
    
    
    @ViewBuilder
    private func Calendar() -> some View {
        let startDate = Date().addingTimeInterval(-60*60*24 * 365 * 1)
        let endDate = Date()
        
        CalendarViewRepresentable(visibleDateRange: startDate...endDate, monthsLayout: .vertical(options: VerticalMonthsLayoutOptions(pinDaysOfWeekToTop: false)), dataDependency: .none)
    }
}

extension CalendarViewRepresentable {
    
}
