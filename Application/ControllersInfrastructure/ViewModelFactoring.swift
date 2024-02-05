//
//  ViewModelFactoring.swift
//  Application
//
//  Created by Stanislav Matvichuck on 14.12.2023.
//

import Domain
import Foundation

protocol DayCellViewModelFactoring {
    func makeViewModel(index: Int, happening: Happening) -> DayCellViewModel
}

protocol EventCellViewModelFactoring {
    func makeEventCellViewModel(event: Event, hintEnabled: Bool) -> EventCellViewModel
}

protocol CreateEventCellViewModelFactoring {
    func makeCreateEventCellViewModel(
        eventsCount: Int,
        handler: CreateEventCellViewModel.TapHandler?
    ) -> CreateEventCellViewModel
}

protocol EventCreationViewModelFactoring {
    func makeEventCreationViewModel() -> EventCreationViewModel
}

protocol DayOfWeekViewModelFactoring {
    func makeDayOfWeekViewModel() -> DayOfWeekViewModel
}

protocol HourDistributionViewModelFactoring {
    func makeHourDistributionViewModel() -> HourDistributionViewModel
}

protocol HintCellViewModelFactoring {
    func makeHintCellViewModel(events: [Event]) -> HintCellViewModel
}

protocol DayDetailsViewModelFactoring { func makeDayDetailsViewModel(pickerDate: Date?) -> DayDetailsViewModel }
protocol ClockViewModelFactoring { func makeClockViewModel() -> ClockViewModel }
protocol EventDetailsViewModelFactoring { func makeEventDetailsViewModel() -> EventDetailsViewModel }

protocol EventsListViewModelFactoring {
    func makeEventsListViewModel() -> EventsListViewModel
}

protocol SummaryViewModelFactoring { func makeSummaryViewModel() -> SummaryViewModel }
protocol PDFWritingViewModelFactoring {
    func makePdfMakingViewModel() -> PDFWritingViewModel
}

protocol WeekViewModelFactoring { func makeWeekViewModel() -> WeekViewModel }
protocol WeekPageViewModelFactoring { func makeWeekPageViewModel(pageIndex: Int, dailyMaximum: Int) -> WeekPageViewModel }
protocol WeekDayViewModelFactoring { func makeWeekDayViewModel(dayIndex: Int, dailyMaximum: Int) -> WeekDayViewModel }

protocol EventsSortingViewModelFactoring { func makeEventsSortingViewModel() -> EventsSortingViewModel }
protocol EventsSortingCellViewModelFactoring { func makeEventsSortingCellViewModel(index: Int) -> EventsSortingCellViewModel }
