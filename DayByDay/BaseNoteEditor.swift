//
//  BaseNoteEditor.swift
//  DayByDay
//
//  Created by Porter Glines on 3/4/23.
//

import SwiftUI

struct BaseNoteEditor: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\DayMO.date, order: .reverse)])
    private var allDays: FetchedResults<DayMO>
    
    
    let date: Date
    @State private var note = ""
    @FocusState private var noteFocus: Bool
    let focusOnAppear: Bool
    
    var body: some View {
        let day = DayData.getDay(for: date, days: allDays)
        
        ZStack {
            TextEditor(text: $note)
                .accessibilityIdentifier("NoteTextEditor")
                .scrollDismissesKeyboard(.interactively)
                .focused($noteFocus)
                .scrollContentBackground(.hidden)
                .background(.clear)
                .tint(Color(hex: 0xE63C5C))
                .lineSpacing(5.0)
                .padding()
                .onChange(of: noteFocus) { focus in
                    if !focus {
                        if let day {
                            DayData.change(note: note, for: day, context: viewContext)
                        } else {
                            DayData.addDay(withNote: note, date: date, context: viewContext)
                        }
                    }
                }
            
            if note.isEmpty {
                TextHint()
                    .allowsHitTesting(false)
            }
        }
        .onAppear {
            note = day?.note ?? ""
            if focusOnAppear {
                noteFocus = true
            }
        }
    }
    
    @ViewBuilder
    private func TextHint() -> some View {
        VStack {
            HStack {
                Text("Enter notes for the day here.")
                    .padding()
                    .offset(x: 4, y: 8.3)
                    .opacity(0.4)
                Spacer()
            }
            Spacer()
        }
    }
}
