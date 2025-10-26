//
//  BaseNoteEditor.swift
//  DayByDay
//
//  Created by Porter Glines on 3/4/23.
//

import SwiftUI

struct BaseNoteEditor: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var date: Date
    var day: DayMO?
    @State private var note = ""
    @FocusState private var noteFocus: Bool
    let focusOnAppear: Bool

    @State private var totalHeight = CGFloat.zero

    var body: some View {
        noteEditor
            .background(alignment: .topLeading) {
                noteAccent
            }
    }

    @ViewBuilder var noteEditor: some View {
        ZStack (alignment: .topLeading) {
            // Dummy text used to calculate TextEditor height
            // This fragile workaround will eventually not be needed and
            // maxHeight: .infinity or axis: .vertical will just work
            //
            // Note the height will grow slightly faster than the text.
            // Since text should be short-form anyways -- this is acceptable.
            Text(note)
                .font(.system(.body))
                .lineSpacing(8) // line spacing between Text and TextEditor is NOT 1-to-1!
                .opacity(0)
                .padding(.trailing)
                .background(GeometryReader { geometry in
                    Color.clear.preference(key: NoteEditorHeightKey.self,
                                           value: geometry.frame(in: .local).size.height)
                })

            TextEditor(text: $note)
                .accessibilityIdentifier("NoteTextEditor")
                .font(.system(.body))
                .lineSpacing(note.isEmpty ? 0 : 5)
                .frame(height: totalHeight + 100)
                .scrollDismissesKeyboard(.interactively)
                .focused($noteFocus)
                .scrollContentBackground(.hidden)
                .scrollDisabled(true)
                .tint(Color(hex: 0xE63C5C))
                .onChange(of: noteFocus) { _, newValue in
                    if !newValue {
                        if let day {
                            DayData.change(note: note, for: day, context: viewContext)
                        } else {
                            DayData.addDay(withNote: note, date: date, context: viewContext)
                        }
                    }
                }

            if note.isEmpty {
                TextHint
                    .allowsHitTesting(false)
            }
        }
        .padding(.leading, 20)
        .onPreferenceChange(NoteEditorHeightKey.self) { height in
            totalHeight = height
        }
        .onAppear {
            note = day?.note ?? ""
            if focusOnAppear {
                noteFocus = true
            }
        }
    }

    @ViewBuilder private var noteAccent: some View {
        Circle()
            .fill(.orange.gradient)
            .frame(width: 10)
            .opacity(0.7)
            .offset(x: 8, y: 13.5)
    }

    @ViewBuilder private var TextHint: some View {
        Text("Enter notes for the day here.")
            .font(.body)
            .opacity(0.4)
            .offset(x: 4, y: 8.3)
    }
}

struct NoteEditorHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}
