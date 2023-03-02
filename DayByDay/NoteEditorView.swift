//
//  NoteEditorView.swift
//  DayByDay
//
//  Created by Porter Glines on 3/1/23.
//

import SwiftUI

struct NoteEditorView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\DayMO.date, order: .reverse)])
    private var allDays: FetchedResults<DayMO>
    
    
    let date: Date
    @State private var note = ""
    @FocusState private var noteFocus: Bool
    let focusOnAppear: Bool
    
    var body: some View {
        let day = getDay(for: date)
        
        ZStack {
            TextEditor(text: $note)
                .focused($noteFocus)
                .scrollContentBackground(.hidden)
                .background(.clear)
                .tint(Color(hex: 0xE63C5C))
                .lineSpacing(3.0)
                .padding()
                .onChange(of: noteFocus) { focus in
                    if !focus {
                        if let day {
                            day.note = note
                            saveContext()
                        } else {
                            addDay(with: note)
                        }
                    }
                }
            
            if note.isEmpty {
                TextHint()
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
                    .offset(x: 8, y: 10)
                    .opacity(0.4)
                Spacer()
            }
            Spacer()
        }
    }
    
    private func getDay(for date: Date) -> DayMO? {
        for day in allDays {
            if day.date?.isSameDay(as: date) ?? false {
                return day
            }
        }
        return nil
    }
    
    private func addDay(with note: String) {
        let newItem = DayMO(context: viewContext)
        newItem.date = date
        newItem.note = note
        saveContext()
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct NoteEditorView_Previews: PreviewProvider {
    static var previews: some View {
        NoteEditorView(date: Date(), focusOnAppear: false)
    }
}
