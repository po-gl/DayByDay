//
//  DaysCalendarView.swift
//  DayByDay
//
//  Created by Porter Glines on 2/23/23.
//

import SwiftUI
import HorizonCalendar

// MARK: SwiftUI View Representable

struct DaysCalendarView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> DaysCalendarViewController {
        DaysCalendarViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

// MARK: UIViewController

class DaysCalendarViewController: UIViewController {
    
    var allDays = [DayMO]()
    
    lazy var calendarView = CalendarView(initialContent: makeContent())
    var calendarContent: CalendarViewContent?
    lazy var calendar = Calendar.current
    
    private var selectedDay: Day?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(calendarView)
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.topAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            calendarView.leadingAnchor.constraint(
                greaterThanOrEqualTo: view.layoutMarginsGuide.leadingAnchor),
            calendarView.trailingAnchor.constraint(
                lessThanOrEqualTo: view.layoutMarginsGuide.trailingAnchor),
            calendarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calendarView.widthAnchor.constraint(lessThanOrEqualToConstant: 375),
            calendarView.widthAnchor.constraint(equalToConstant: 375).prioritize(at: .defaultLow),
        ])
        
        calendarView.daySelectionHandler = { [weak self] day in
            self?.selectedDay = day
            let date = (self?.calendar.date(from: day.components))!
            guard date.isInPast() else { return }
            
            let vc = DaysCalendarSelectedViewController(date: date, onDismiss: {
                self?.loadDaysData()
                self?.calendarView.setContent((self?.calendarContent)!)
            })
            if let presentationController = vc.presentationController as? UISheetPresentationController {
                presentationController.detents = [.medium(), .large()]
            }
            self?.present(vc, animated: true)
        }
        
        calendarView.scroll(toDayContaining: Date(), scrollPosition: .centered, animated: false)
        
        loadDaysData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func makeContent() -> CalendarViewContent {
        let startDate = Date().addingTimeInterval(-60*60*24 * 365 * 1)
        let endDate = Date().addingTimeInterval(60*60*24 * 25)
        
        let monthsLayout = MonthsLayout.vertical(options: VerticalMonthsLayoutOptions(pinDaysOfWeekToTop: false, alwaysShowCompleteBoundaryMonths: false))
        
        calendarContent = CalendarViewContent(
            visibleDateRange: startDate...endDate,
            monthsLayout: monthsLayout)
        .interMonthSpacing(30)
        .verticalDayMargin(20)
        .monthHeaderItemProvider { month in
            self.MonthHeaderView(month)
                .calendarItemModel
        }
        .dayItemProvider { day in
            self.DayView(day)
                .calendarItemModel
        }
        return calendarContent!
    }
    
    private func loadDaysData() {
        let request = DayMO.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \DayMO.date, ascending: true)]
        do {
            allDays = try PersistenceController.shared.container.viewContext.fetch(request)
        } catch {
            print("Failed to fetch days for calendar.")
        }
    }
    
    @ViewBuilder
    private func MonthHeaderView(_ month: Month) -> some View {
        HStack (spacing: 0) {
            Text("\(monthHeaderFormatter.string(from: self.calendar.date(from: month.components)!))")
                .font(.title3)
                .padding(.leading)
            Text("\(justYearFormatter.string(from: self.calendar.date(from: month.components)!))")
                .font(.title3)
                .opacity(0.5)
                .padding(.leading)
            Spacer()
        }
    }
    
    @ViewBuilder
    private func DayView(_ day: Day) -> some View {
        let date = calendar.date(from: day.components)!
        VStack (spacing: 0) {
            Text("\(day.day)")
                .font(.system(size: 18))
                .foregroundColor(.primary)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(hex: 0xDC3F3F).lighten().gradient)
                        .saturation(1.14)
                        .brightness(-0.1)
                        .opacity(date.isToday() ? 1.0 : 0.0)
                        .scaleEffect(1.15)
                        .frame(minWidth: 15)
                )
            
            Orbs(day)
        }
    }
    
    @ViewBuilder
    private func Orbs(_ day: Day) -> some View {
        let orbWidth: Double = 16
        let spacing: Double = orbWidth/2 + 1
        let day = DayData.getDay(for: calendar.date(from: day.components)!, days: allDays)
        
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
                    .fill(activeColor.gradient)
                    .frame(width: orbWidth)
                    .offset(x: -spacing, y: -spacing)
                    .opacity(isActive ? 1.0 : 0.2)
                    .shadow(color: isComplete ? activeColor.lighten() : .clear, radius: 2)
                Circle()
                    .fill(creativeColor.gradient)
                    .frame(width: orbWidth)
                    .offset(x: spacing, y: -spacing)
                    .opacity(isCreative ? 1.0 : 0.2)
                    .shadow(color: isComplete ? creativeColor.lighten() : .clear, radius: 2)
                Circle()
                    .fill(productiveColor.gradient)
                    .frame(width: orbWidth)
                    .offset(y: spacing - 2)
                    .opacity(isProductive ? 1.0 : 0.2)
                    .shadow(color: isComplete ? productiveColor.lighten() : .clear, radius: 2)
                
                NoteOrb(day, offset: orbWidth/2)
            }
            .brightness(0.06)
            .saturation(1.05)
        }
        .frame(width: orbWidth*2 + spacing, height: orbWidth*2 + spacing)
        .drawingGroup()
    }
    
    @ViewBuilder
    private func NoteOrb(_ day: DayMO?, offset: Double) -> some View {
        let hasNote = !(day?.note?.isEmpty ?? true)
        if hasNote {
            Circle()
                .fill(.orange.gradient)
                .frame(width: 6)
                .offset(x: -offset*2, y: offset-2)
                .brightness(0.05)
        }
    }
}

fileprivate var monthHeaderFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.setLocalizedDateFormatFromTemplate("MMM")
    return formatter
}()

fileprivate var justYearFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.setLocalizedDateFormatFromTemplate("YYYY")
    return formatter
}()


extension NSLayoutConstraint {
    fileprivate func prioritize(at priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
