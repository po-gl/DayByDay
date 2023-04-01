//
//  PastNotes.swift
//  DayByDay
//
//  Created by Porter Glines on 4/1/23.
//

import SwiftUI

struct PastNotes: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\DayMO.date, order: .reverse)])
    private var allDays: FetchedResults<DayMO>
    
    @State private var selectedDay: DayMO?
    
    var body: some View {
        List(allDays, selection: $selectedDay) { day in
            if day.note != nil && day.note != "" {
                Cell(note: day.note!, date: day.date!)
                    .tag(day)
                    .padding(.vertical, 5)
                    .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
        .navigationTitle("Past Notes")
        .navigationBarTitleDisplayMode(.large)
        
        .sheet(item: $selectedDay) { day in
            NoteEditorView(date: day.date!)
                .presentationDetents([.medium, .large])
        }
    }
    
    
    @ViewBuilder
    private func Cell(note: String, date: Date) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Color.clear.frame(width: 10, height: 10)
                Text(timeFormatter.string(from: date))
                    .font(.system(.body, design: .serif))
                    .opacity(0.6)
            }
            
            HStack(alignment:. top) {
                Accent()
                Text(note)
                    .font(.system(.body, weight: colorScheme == .dark ? .light : .regular))
                    .lineSpacing(2.0)
            }
        }
    }
    
    @ViewBuilder
    private func Accent() -> some View {
        Circle()
            .fill(.orange.gradient)
            .frame(width: 10)
            .opacity(0.7)
            .offset(y: 5)
    }
}

fileprivate let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.doesRelativeDateFormatting = true
    formatter.dateStyle = .short
    return formatter
}()
