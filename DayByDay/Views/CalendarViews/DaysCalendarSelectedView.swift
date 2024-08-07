//
//  DaysCalendarSelectedView.swift
//  DayByDay
//
//  Created by Porter Glines on 2/24/23.
//

import SwiftUI

struct DaysCalendarSelectedView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    let date: Date
    @State var day: DayMO?

    private let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EEEE MMM d YYYY")
        return formatter
    }()
    
    @State var animate = false
    let orbAnimation: Animation = .spring()
    
    @State var showingNoteEditor = false
    
    let headerHeight: Double = 50
    
    @State var categoryToggles: [StatusCategory: Bool] = [
        .active: false,
        .creative: false,
        .productive: false
    ]
    @State var note = ""
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack (spacing: 0) {
                    Group {
                        ZStack {
                            BackgroundOrbs
                            Orbs
                        }
                        
                        Notes
                    }
                    .offset(y: headerHeight + 10)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            Header
        }
        .onAppear {
            animate = true
            updateDayInfo()
        }
        .onChange(of: showingNoteEditor) { _ in
            Task {
                try? await Task.sleep(for: .seconds(0.1))
                updateDayInfo()
            }
        }
    }
    
    func updateDayInfo() {
        if let day {
            categoryToggles[.active] = day.isActive(for: .active)
            categoryToggles[.creative] = day.isActive(for: .creative)
            categoryToggles[.productive] = day.isActive(for: .productive)
            note = day.note ?? ""
        }
    }
    
    @ViewBuilder
    private var Orbs: some View {
        let orbWidth: Double = 85
        let spacing: Double = orbWidth/2 + 3
        
        let isActive = categoryToggles[.active] ?? false
        let isCreative = categoryToggles[.creative] ?? false
        let isProductive = categoryToggles[.productive] ?? false
        let isComplete = isActive && isCreative && isProductive
        
        let activeColor = Color(hex: 0xE63C5C)
        let creativeColor = Color(hex: 0xBE59D5)
        let productiveColor = Color(hex: 0x97D327)
        
        ZStack {
            Group {
                Circle()
                    .fill(LinearGradient(forSimple: .active))
                    .frame(width: orbWidth)
                    .scaleEffect(animate ? 1.0 : 0.001, anchor: .center)
                    .offset(x: -spacing, y: -spacing)
                    .opacity(isActive ? 1.0 : 0.001)
                    .shadow(color: isComplete ? activeColor : .clear, radius: 10)
                    .animation(orbAnimation.delay(Double.random(in: 0.1...0.3)), value: animate)
                    .onTapGesture { handleOrbPress(for: .active, day: day) }
                Circle()
                    .fill(LinearGradient(forSimple: .creative))
                    .frame(width: orbWidth)
                    .scaleEffect(animate ? 1.0 : 0.001, anchor: .center)
                    .offset(x: spacing, y: -spacing)
                    .opacity(isCreative ? 1.0 : 0.001)
                    .shadow(color: isComplete ? creativeColor : .clear, radius: 10)
                    .animation(orbAnimation.delay(Double.random(in: 0.1...0.3)), value: animate)
                    .onTapGesture { handleOrbPress(for: .creative, day: day) }
                Circle()
                    .fill(LinearGradient(forSimple: .productive))
                    .frame(width: orbWidth)
                    .scaleEffect(animate ? 1.0 : 0.001, anchor: .center)
                    .offset(y: spacing - 12)
                    .opacity(isProductive ? 1.0 : 0.001)
                    .shadow(color: isComplete ? productiveColor : .clear, radius: 10)
                    .animation(orbAnimation.delay(Double.random(in: 0.1...0.3)), value: animate)
                    .onTapGesture { handleOrbPress(for: .productive, day: day) }
            }
            .brightness(0.06)
            .saturation(1.05)
        }
        .frame(width: orbWidth*2 + spacing, height: orbWidth*1.8 + spacing)
    }
    
    private func handleOrbPress(for category: StatusCategory, day: DayMO?) {
        withAnimation(.easeOut(duration: 0.2)) {
            if let day {
                DayData.toggle(category: category, for: day, context: viewContext)
            } else {
                self.day = DayData.addDay(activeFor: category, date: date, context: viewContext)
            }
            updateDayInfo()
        }
        haptic()
    }
    
    @ViewBuilder
    private var BackgroundOrbs: some View {
        let orbWidth: Double = 85
        let spacing: Double = orbWidth/2 + 3
        
        ZStack {
            Group {
                Circle()
                    .fill(LinearGradient(forSimple: .active))
                    .frame(width: orbWidth)
                    .offset(x: -spacing, y: -spacing)
                Circle()
                    .fill(LinearGradient(forSimple: .creative))
                    .frame(width: orbWidth)
                    .offset(x: spacing, y: -spacing)
                Circle()
                    .fill(LinearGradient(forSimple: .productive))
                    .frame(width: orbWidth)
                    .offset(y: spacing - 12)
            }
            .opacity(0.2)
            .brightness(0.06)
            .saturation(1.05)
        }
        .frame(width: orbWidth*2 + spacing, height: orbWidth*1.8 + spacing)
    }
    
    @ViewBuilder
    private var Header: some View {
        VStack {
            ZStack {
                HStack {
                    Button("Close") { dismiss() }
                        .foregroundColor(Color(hex: 0x97D327))
                        .brightness(colorScheme == .dark ? 0.07 : -0.02)
                        .saturation(1.05)
                        .padding()
                    Spacer()
                }
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 35, height: 5)
                    .opacity(0.6)
                    .offset(y: -headerHeight/2 + 8)
                Text(date, formatter: dayFormatter)
            }
            .frame(height: headerHeight)
            .background(.thinMaterial)
            Spacer()
        }
    }
    
    @ViewBuilder
    private var Notes: some View {
        ZStack (alignment: .topLeading) {
            Group {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.thinMaterial)
                    .frame(minHeight: 90)
                
                Text(note.isEmpty ? "Enter notes for the day here." : day!.note!)
                    .fontWeight(.light)
                    .lineSpacing(6)
                    .opacity(note.isEmpty ? 0.5 : 1.0)
                    .padding()
                    .sheet(isPresented: $showingNoteEditor) {
                        NoteEditorView(date: date, day: day)
                    }
            }
            .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 6))
            .compositingGroup()
            .contextMenu { NoteContextMenu }
            .onTapGesture {
                showingNoteEditor = true
                self.day = DayData.addDay(date: date, context: viewContext)
            }
            
            
            Circle()
                .fill(.orange.gradient)
                .saturation(note.isEmpty ? 0.2 : 1.0)
                .brightness(note.isEmpty ? (colorScheme == .dark ? -0.2 : 0.2) : 0.0)
                .frame(width: 15)
                .offset(x: -8, y: -6)
                .brightness(0.05)
                .allowsHitTesting(false)
        }
        .padding()
    }
    
    @ViewBuilder
    private var NoteContextMenu: some View {
        Button(action: {
            showingNoteEditor = true
            self.day = DayData.addDay(date: date, context: viewContext)
        }) {
            Label("Edit", systemImage: "note.text")
        }
        Button(role: .destructive, action: {
            if let day {
                DayData.deleteNote(for: day, context: viewContext)
            }
        }) {
            Label("Delete", systemImage: "trash")
        }
    }
    
    
    private func haptic() {
        if day?.isComplete() ?? false {
            completeHaptic()
        } else {
            basicHaptic()
        }
    }
}


struct DaysCalendarSelectedViewEnvironmentWrapper: View {
    let date: Date
    var day: DayMO?
    
    var body: some View {
        DaysCalendarSelectedView(date: date, day: day)
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}


class DaysCalendarSelectedViewController: UIViewController {
    let date: Date
    var day: DayMO?
    let onDismissBlock: () -> Void
    lazy var contentView = UIHostingController(rootView: DaysCalendarSelectedViewEnvironmentWrapper(date: date, day: day))
    
    init(date: Date, day: DayMO?, onDismiss: @escaping () -> Void = {}) {
        self.date = date
        self.day = day
        self.onDismissBlock = onDismiss
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(contentView)
        view.addSubview(contentView.view)
        
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.view.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            onDismissBlock()
        }
    }
}


struct DaysCalendarSelectedView_Previews: PreviewProvider {
    static var previews: some View {
        DaysCalendarSelectedView(date: Date(), day: nil).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
