//
//  TopButtons.swift
//  DayByDay
//
//  Created by Porter Glines on 2/21/23.
//

import SwiftUI
import HorizonCalendar

struct TopButtons: View {
    @Binding var showingNoteEditor: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                NoteButton()
                CalendarButton()
            }
            .padding(.top, 20)
            .padding(.trailing, 40)
            Spacer()
        }
    }
    
    @ViewBuilder
    private func NoteButton() -> some View {
        Button(action: { showingNoteEditor = true }) {
            Image(systemName: "square.and.pencil")
                .opacity(0.8)
        }
        .accessibilityIdentifier("NoteButton")
        .buttonStyle(MaterialStyle())
        .frame(width: 50, height: 32)
        .sheet(isPresented: $showingNoteEditor) {
            ZStack {
                NoteEditorView(date: Date(), focusOnAppear: false)
                    .padding(.top, 65)
                    .padding(.horizontal)
                NoteHeader()
            }
            .presentationDetents([.medium, .large])
        }
    }
    
    @ViewBuilder
    private func NoteHeader() -> some View {
        VStack {
            ZStack {
                HStack {
                    Button("Done") { showingNoteEditor = false }
                        .foregroundColor(Color(hex: 0xE63C5C))
                        .brightness(0.07)
                        .saturation(1.05)
                        .padding()
                    Spacer()
                }
                Text("\(Date(), formatter: dayFormatter)")
                    .font(.title3)
            }
            .frame(height: 65)
            .background(.thinMaterial)
            Spacer()
        }
    }
    
    @ViewBuilder
    private func CalendarButton() -> some View {
        NavigationLink(destination: {
            DaysCalendarView()
                .accessibilityIdentifier("CalendarView")
                .ignoresSafeArea(.container, edges: .top)
                .navigationTitle("Calendar")
        }) {
            Image(systemName: "calendar")
                .opacity(0.8)
        }
        .accessibilityIdentifier("CalendarButton")
        .buttonStyle(MaterialStyle())
        .frame(width: 50, height: 32)
    }
}


fileprivate let dayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.setLocalizedDateFormatFromTemplate("EEEE MMM d YYYY")
    return formatter
}()

