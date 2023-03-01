//
//  DaysCalendarSelectedView.swift
//  DayByDay
//
//  Created by Porter Glines on 2/24/23.
//

import SwiftUI

struct DaysCalendarSelectedView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    let date: Date
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\DayMO.date, order: .reverse)])
    private var allDays: FetchedResults<DayMO>
    
    private let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EEEE MMM d YYYY")
        return formatter
    }()
    
    @State var animate = false
    let orbAnimation: Animation = .spring()
    
    var body: some View {
        let day = getDay(for: date)
        
        ZStack {
            Header()
            VStack (spacing: 0) {
                Handle()
                Group {
                    DateView(date: date, fontSize: 24, width: 140, shineOffset: Double.random(in: 0...30), formatter: dayFormatter)
                        .frame(height: 50)
                        .animation(.spring().delay(0.2), value: animate)
                    ZStack {
                        BackgroundOrbs()
                        Orbs(day)
                    }
                }
                .offset(y: 50)
                Spacer()
            }
        }
        .onAppear {
            animate = true
        }
    }
    
    @ViewBuilder
    private func Orbs(_ day: DayMO?) -> some View {
        let orbWidth: Double = 100
        let spacing: Double = orbWidth/2 + 3
        
        let isActive = day?.isActive(for: .active) ?? false
        let isCreative = day?.isActive(for: .creative) ?? false
        let isProductive = day?.isActive(for: .productive) ?? false
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
        .frame(width: orbWidth*2 + spacing, height: orbWidth*2 + spacing)
    }
    
    private func handleOrbPress(for category: StatusCategory, day: DayMO?) {
        withAnimation(.easeOut(duration: 0.2)) {
            if let day {
                day.toggle(category: category)
            } else {
                addDay(activeFor: category)
            }
            saveContext()
        }
        haptic(day)
    }
    
    @ViewBuilder
    private func BackgroundOrbs() -> some View {
        let orbWidth: Double = 100
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
        .frame(width: orbWidth*2 + spacing, height: orbWidth*2 + spacing)
    }
    
    @ViewBuilder
    private func Handle() -> some View {
        RoundedRectangle(cornerRadius: 30)
            .frame(width: 50, height: 5)
            .opacity(0.2)
            .padding(.top, 10)
    }
    
    @ViewBuilder
    private func Header() -> some View {
        VStack {
            HStack {
                Button("Close") { dismiss() }
                    .foregroundColor(Color(hex: 0x97D327))
                    .brightness(0.07)
                    .saturation(1.05)
                    .padding()
                Spacer()
            }
            .frame(height: 50)
            .background(.thinMaterial)
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
    
    
    private func addDay(activeFor category: StatusCategory) {
        let newItem = DayMO(context: viewContext)
        newItem.date = date
        newItem.toggle(category: category)
        saveContext()
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func haptic(_ day: DayMO?) {
        if day?.isComplete() ?? false {
            completeHaptic()
        } else {
            basicHaptic()
        }
    }
}


struct DaysCalendarSelectedViewEnvironmentWrapper: View {
    let date: Date
    
    var body: some View {
        DaysCalendarSelectedView(date: date)
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}


class DaysCalendarSelectedViewController: UIViewController {
    let date: Date
    let onDismissBlock: () -> Void
    lazy var contentView = UIHostingController(rootView: DaysCalendarSelectedViewEnvironmentWrapper(date: date))
    
    init(date: Date, onDismiss: @escaping () -> Void = {}) {
        self.date = date
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