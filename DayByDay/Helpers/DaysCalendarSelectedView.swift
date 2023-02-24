//
//  DaysCalendarSelectedView.swift
//  DayByDay
//
//  Created by Porter Glines on 2/24/23.
//

import SwiftUI

struct DaysCalendarSelectedView: View {
    @Environment(\.managedObjectContext) private var viewContext
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
        VStack {
            Handle()
            DateView(date: date, fontSize: 24, width: 140, shineOffset: Double.random(in: 0...30), formatter: dayFormatter)
                .frame(height: 50)
                .offset(y: 10)
                .animation(.spring().delay(0.2), value: animate)
            ZStack {
                BackgroundOrbs()
                Orbs()
            }
            Spacer()
        }
        .onAppear {
            animate = true
        }
    }
    
    @ViewBuilder
    private func Orbs() -> some View {
        let orbWidth: Double = 100
        let spacing: Double = orbWidth/2 + 3
        let day = getDay(for: date)
        
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
                    .opacity(isActive ? 1.0 : 0.0)
                    .shadow(color: isComplete ? activeColor : .clear, radius: 10)
                    .animation(orbAnimation.delay(Double.random(in: 0.1...0.3)), value: animate)
                Circle()
                    .fill(LinearGradient(forSimple: .creative))
                    .frame(width: orbWidth)
                    .scaleEffect(animate ? 1.0 : 0.001, anchor: .center)
                    .offset(x: spacing, y: -spacing)
                    .opacity(isCreative ? 1.0 : 0.0)
                    .shadow(color: isComplete ? creativeColor : .clear, radius: 10)
                    .animation(orbAnimation.delay(Double.random(in: 0.1...0.3)), value: animate)
                Circle()
                    .fill(LinearGradient(forSimple: .productive))
                    .frame(width: orbWidth)
                    .scaleEffect(animate ? 1.0 : 0.001, anchor: .center)
                    .offset(y: spacing - 12)
                    .opacity(isProductive ? 1.0 : 0.0)
                    .shadow(color: isComplete ? productiveColor : .clear, radius: 10)
                    .animation(orbAnimation.delay(Double.random(in: 0.1...0.3)), value: animate)
            }
            .brightness(0.06)
            .saturation(1.05)
        }
        .frame(width: orbWidth*2 + spacing, height: orbWidth*2 + spacing)
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
            .padding(5)
    }
    
    private func getDay(for date: Date) -> DayMO? {
        for day in allDays {
            if day.date?.isSameDay(as: date) ?? false {
                return day
            }
        }
        return nil
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
    lazy var contentView = UIHostingController(rootView: DaysCalendarSelectedViewEnvironmentWrapper(date: date))
    
    init(date: Date) {
        self.date = date
        
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
}
