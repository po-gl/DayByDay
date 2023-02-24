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
    
    lazy var calendarView = CalendarView(initialContent: makeContent())
    lazy var dayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EEEE, MMM d, yyyy")
        return formatter
    }()
    
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func makeContent() -> CalendarViewContent {
        let startDate = Date().addingTimeInterval(-60*60*24 * 365 * 1)
        let endDate = Date().addingTimeInterval(60*60*24 * 31)
        
        let monthsLayout = MonthsLayout.vertical(options: VerticalMonthsLayoutOptions(pinDaysOfWeekToTop: true))
        
        return CalendarViewContent(
            visibleDateRange: startDate...endDate,
            monthsLayout: monthsLayout)
        .interMonthSpacing(24)
    }
}


extension NSLayoutConstraint {
    fileprivate func prioritize(at priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
