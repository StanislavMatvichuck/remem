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

protocol EventItemViewModelFactoring {
    func makeEventItemViewModel(
        event: Event,
        today: DayIndex,
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

protocol WeekCellViewModelFactoring {
    func makeViewModel(
        indexPath: IndexPath,
        cellPresentationAnimationBlock: @escaping DayDetailsAnimationsHelper.AnimationBlock,
        cellDismissAnimationBlock: @escaping DayDetailsAnimationsHelper.AnimationBlock
    ) -> WeekCellViewModel
}

protocol WeekSummaryViewModelFactoring {
    func makeViewModel(today: DayIndex, week: WeekIndex) -> WeekSummaryViewModel
}

protocol WeekViewModelFactoring {
    func makeWeekViewModel(visibleDayIndex: Int?) -> WeekViewModel
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
protocol PdfMakingViewModelFactoring {
    func makePdfMakingViewModel() -> PdfMakingViewModel
}

protocol NewWeekViewModelFactoring { func makeNewWeekViewModel() -> NewWeekViewModel }
protocol NewWeekCellViewModelFactoring { func makeNewWeekCellViewModel(index: Int) -> NewWeekCellViewModel }
