//
//  NoteEditorView.swift
//  DayByDay
//
//  Created by Porter Glines on 3/1/23.
//

import SwiftUI

struct NoteEditorView: View {
    @Environment(\.dismiss) private var dismiss
    var date: Date
    var day: DayMO?
    var focusOnAppear: Bool = false
    @FocusState var noteFocus: Bool

    var body: some View {
        NavigationStack {
            ScrollView {
                BaseNoteEditor(date: date, day: day, focusOnAppear: focusOnAppear)
                    .ignoresSafeArea(edges: .all)
                    .safeAreaInset(edge: .top) {
                        Color.clear
                            .background(.bar)
                            .frame(height: 0)
                            .border(.thinMaterial)
                    }
                    .focused($noteFocus)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            closeButton
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            doneButton
                        }
                    }
                    .navigationTitle(dayFormatter.string(from: date))
                    .navigationBarTitleDisplayMode(.inline)
                    .padding(.leading, 10)
            }
        }
    }

    @ViewBuilder private var closeButton: some View {
        Button(action: { dismiss() }) {
            Text("Close").bold()
        }
        .accessibilityIdentifier("NoteCloseButton")
        .foregroundColor(.orange)
        .brightness(0.07)
        .saturation(1.05)
    }

    @ViewBuilder private var doneButton: some View {
        Button("Done") { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) }
            .accessibilityIdentifier("NoteDoneTypingButton")
            .tint(Color(hex: 0xFF7676))
            .brightness(-0.07)
            .saturation(1.05)
            .opacity(noteFocus ? 1.0 : 0.0)
    }
}

fileprivate let dayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.setLocalizedDateFormatFromTemplate("EEEE MMM d YYYY")
    return formatter
}()


struct NoteEditorView_Preview: PreviewProvider {
    static var previews: some View {
        @State var presenting = true
        
        Text("Preview")
            .onTapGesture { presenting = true }
            .sheet(isPresented: $presenting) {
                NoteEditorView(date: Date(), day: nil)
            }
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
