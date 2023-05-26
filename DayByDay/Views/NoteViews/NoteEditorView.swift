//
//  NoteEditorView.swift
//  DayByDay
//
//  Created by Porter Glines on 3/1/23.
//

import SwiftUI

struct NoteEditorView: View {
    @Environment(\.dismiss) private var dismiss
    var date: Date = Date()
    var focusOnAppear: Bool = false
    @FocusState var noteFocus: Bool

    var body: some View {
        ZStack (alignment: .topLeading) {
            Group {
                HStack {
                    NoteAccent()
                    Spacer()
                }
                BaseNoteEditor(date: date, focusOnAppear: focusOnAppear)
                    .focused($noteFocus)
                    .padding(.leading)
            }
            .padding(.top, 50)
            NoteHeader()
        }
    }
    
    @ViewBuilder
    private func NoteAccent() -> some View {
        HStack {
            Circle()
                .fill(.orange.gradient)
                .frame(width: 10)
                .opacity(0.7)
                .padding()
                .offset(y: 13.3)
            Spacer()
        }
    }
    
    @ViewBuilder
    private func NoteHeader() -> some View {
        VStack {
            ZStack {
                HStack {
                    Button(action: { dismiss() }) {
                        Text("Close").bold()
                    }
                        .accessibilityIdentifier("NoteCloseButton")
                        .foregroundColor(.orange)
                        .brightness(0.07)
                        .saturation(1.05)
                    
                    Spacer()
                    
                    Button("Done") { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) }
                        .accessibilityIdentifier("NoteDoneTypingButton")
                        .tint(Color(hex: 0xFF7676))
                        .brightness(-0.07)
                        .saturation(1.05)
                        .opacity(noteFocus ? 1.0 : 0.0)
                }
                .padding()
                Text(date, formatter: dayFormatter)
            }
            .frame(height: 50)
            .background(.thinMaterial)
            Spacer()
        }
    }
}

fileprivate let dayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.setLocalizedDateFormatFromTemplate("EEEE MMM d YYYY")
    return formatter
}()
