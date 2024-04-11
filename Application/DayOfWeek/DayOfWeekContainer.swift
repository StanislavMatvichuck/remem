//
//  DayOfWeekContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2024.
//

import UIKit

final class DayOfWeekContainer: DayOfWeekViewModelFactoring {
    private let parent: EventDetailsContainer

    init(_ parent: EventDetailsContainer) { self.parent = parent }

    func make() -> UIViewController { DayOfWeekController(self) }
    func makeDayOfWeekViewModel() -> DayOfWeekViewModel {
        DayOfWeekViewModel(parent.event.happenings, currentMoment: parent.currentMoment)
    }
}
