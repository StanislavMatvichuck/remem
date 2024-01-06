//
//  ViewModelFactoring.swift
//  Application
//
//  Created by Stanislav Matvichuck on 14.12.2023.
//

import Domain
import Foundation

protocol DayItemViewModelFactoring {
    func makeViewModel(happening: Happening) -> DayCellViewModel
}

protocol EventCellViewModelFactoring {
    func makeEventItemViewModel(
        event: Event,
        hintEnabled: Bool,
        renameHandler: EventItemViewModelRenameHandling?
    ) -> EventCellViewModel
}

protocol EventItemViewModelRenameHandling {
    func renameTapped(_: EventCellViewModel)
}

protocol FooterItemViewModelTapHandling {
    func tapped(_ vm: FooterCellViewModel)
}

protocol FooterItemViewModeFactoring {
    func makeFooterItemViewModel(
        eventsCount: Int,
        handler: FooterItemViewModelTapHandling?
    ) -> FooterCellViewModel
}

protocol HintItemViewModelFactoring {
    func makeHintItemViewModel(events: [Event]) -> HintCellViewModel
}

protocol WeekSummaryViewModelFactoring {
    func makeViewModel(today: DayIndex, week: WeekIndex) -> WeekSummaryViewModel
}

protocol DayDetailsViewModelFactoring { func makeDayDetailsViewModel() -> DayDetailsViewModel }
protocol ClockViewModelFactoring { func makeClockViewModel() -> ClockViewModel }
protocol EventDetailsViewModelFactoring { func makeEventDetailsViewModel() -> EventDetailsViewModel }
typealias EventsListViewModelHandling =
    EventItemViewModelRenameHandling &
    FooterItemViewModelTapHandling

protocol EventsListViewModelFactoring {
    func makeEventsListViewModel(_: EventsListViewModelHandling?) -> EventsListViewModel
}

protocol SummaryViewModelFactoring { func makeSummaryViewModel() -> SummaryViewModel }
protocol PDFWritingViewModelFactoring {
    func makePdfMakingViewModel() -> PDFWritingViewModel
}

protocol WeekViewModelFactoring { func makeWeekViewModel() -> WeekViewModel }
protocol WeekPageViewModelFactoring { func makeWeekPageViewModel(pageIndex: Int, dailyMaximum: Int) -> WeekPageViewModel }
protocol WeekDayViewModelFactoring { func makeWeekDayViewModel(dayIndex: Int, dailyMaximum: Int) -> WeekDayViewModel }
