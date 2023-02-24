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
    lazy var calendar = Calendar.current
    
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
        
        return CalendarViewContent(
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
        VStack (spacing: 0) {
            Text("\(day.day)")
                .font(.system(size: 18))
                .foregroundColor(.primary)
            
            Orbs(day)
        }
    }
    
    @ViewBuilder
    private func Orbs(_ day: Day) -> some View {
        let orbWidth: Double = 16
        let spacing: Double = orbWidth/2 + 1
        let day = getDay(for: calendar.date(from: day.components)!)
        
        let isActive = day?.isActive(for: .active) ?? false
        let isCreative = day?.isActive(for: .creative) ?? false
        let isProductive = day?.isActive(for: .productive) ?? false
        ZStack {
            OrbsBackground()
                .opacity(isActive && isCreative && isProductive ? 1.0 : 0.0)
            Group {
                Circle()
                    .fill(Color(hex: 0xE63C5C).gradient)
                    .frame(width: orbWidth)
                    .offset(x: -spacing, y: -spacing)
                    .opacity(isActive ? 1.0 : 0.2)
                Circle()
                    .fill(Color(hex: 0xBE59D5).gradient)
                    .frame(width: orbWidth)
                    .offset(x: spacing, y: -spacing)
                    .opacity(isCreative ? 1.0 : 0.2)
                Circle()
                    .fill(Color(hex: 0x97D327).gradient)
                    .frame(width: orbWidth)
                    .offset(y: spacing - 2)
                    .opacity(isProductive ? 1.0 : 0.2)
            }
            .brightness(0.06)
            .saturation(1.05)
        }
        .frame(width: orbWidth*2 + spacing, height: orbWidth*2 + spacing)
    }
    
    @ViewBuilder
    private func OrbsBackground() -> some View {
        let orbWidth: Double = 16
        let spacing: Double = orbWidth/2 + 1
        ZStack {
            Circle()
                .fill(Color(hex: 0xE63C5C))
                .frame(width: 15)
                .blur(radius: 8)
                .offset(x: -spacing, y: -spacing)
            Circle()
                .fill(Color(hex: 0xBE59D5))
                .frame(width: 15)
                .blur(radius: 8)
                .offset(x: spacing, y: -spacing)
            Circle()
                .fill(Color(hex: 0x97D327))
                .frame(width: 15)
                .blur(radius: 8)
                .offset(y: spacing)
        }
        .brightness(0.13)
        .saturation(1.1)
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
