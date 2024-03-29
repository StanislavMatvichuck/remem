//
//  ViewModelFactoring.swift
//  Application
//
//  Created by Stanislav Matvichuck on 14.12.2023.
//

import Domain
import Foundation

// MARK: - EventsSorting

protocol EventsSortingViewModelFactoring { func makeEventsSortingViewModel() -> EventsSortingViewModel }
protocol EventsSortingCellViewModelFactoring { func makeEventsSortingCellViewModel(index: Int) -> EventsSortingCellViewModel }

// MARK: - EventsList

protocol EventsListViewModelFactoring {
    func makeEventsListViewModel() -> EventsListViewModel
}

protocol HintCellViewModelFactoring {
    func makeHintCellViewModel(hint: EventsList.Hint) -> HintCellViewModel
}

protocol EventCellViewModelFactoring {
    func makeEventCellViewModel(eventId: String) -> EventCellViewModel
}

protocol CreateEventCellViewModelFactoring {
    func makeCreateEventCellViewModel(eventsCount: Int) -> CreateEventCellViewModel
}

// MARK: - EventCreation

protocol EventCreationViewModelFactoring {
    func makeEventCreationViewModel() -> EventCreationViewModel
}

// MARK: - EventDetails

protocol EventDetailsViewModelFactoring { func makeEventDetailsViewModel() -> EventDetailsViewModel }
protocol WeekViewModelFactoring { func makeWeekViewModel() -> WeekViewModel }
protocol WeekPageViewModelFactoring { func makeWeekPageViewModel(pageIndex: Int, dailyMaximum: Int) -> WeekPageViewModel }
protocol WeekDayViewModelFactoring { func makeWeekDayViewModel(dayIndex: Int, dailyMaximum: Int) -> WeekDayViewModel }
protocol ClockViewModelFactoring { func makeClockViewModel() -> ClockViewModel }
protocol HourDistributionViewModelFactoring {
    func makeHourDistributionViewModel() -> HourDistributionViewModel
}

protocol GoalsViewModelFactoring { func makeGoalsViewModel() -> GoalsViewModel }
protocol GoalViewModelFactoring { func makeGoalViewModel(goal: Goal) -> GoalViewModel }

protocol DayOfWeekViewModelFactoring {
    func makeDayOfWeekViewModel() -> DayOfWeekViewModel
}

protocol SummaryViewModelFactoring { func makeSummaryViewModel() -> SummaryViewModel }

// MARK: - DayDetails

protocol DayDetailsViewModelFactoring {
    func makeDayDetailsViewModel(pickerDate: Date?) -> DayDetailsViewModel
}

protocol DayCellViewModelFactoring {
    func makeDayCellViewModel(happening: Happening) -> DayCellViewModel
}

// MARK: - PDF

protocol PDFWritingViewModelFactoring {
    func makePdfMakingViewModel() -> PDFWritingViewModel
}
