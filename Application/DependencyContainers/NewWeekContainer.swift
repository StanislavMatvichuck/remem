//
//  NewWeekContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 20.12.2023.
//

import Domain
import Foundation

final class NewWeekContainer:
    NewWeekViewModelFactoring,
    NewWeekDayViewModelFactoring
{
    private let parent: EventDetailsContainer
    private var event: Event { parent.event }
    private var today: Date { parent.parent.parent.currentMoment }

    init(_ parent: EventDetailsContainer) {
        self.parent = parent
    }

    func makeNewWeekViewModel() -> NewWeekViewModel {
        NewWeekViewModel(event: event, dayFactory: self)
    }

    func makeNewWeekDayViewModel(index: Int) -> NewWeekDayViewModel {
        NewWeekDayViewModel(event: event, index: index, today: today)
    }
}
