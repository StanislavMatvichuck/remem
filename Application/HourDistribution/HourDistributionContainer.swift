//
//  HourDistributionContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2024.
//

import UIKit

final class HourDistributionContainer:
    HourDistributionViewModelFactoring
{
    private let parent: EventDetailsContainer
    private var currentHour: Int {
        Calendar.current.dateComponents(
            [.hour],
            from: parent.parent.currentMoment
        ).hour!
    }

    init(_ parent: EventDetailsContainer) { self.parent = parent }

    func make() -> UIViewController {
        HourDistributionController(self)
    }

    func makeHourDistributionViewModel() -> HourDistributionViewModel {
        HourDistributionViewModel(parent.event.happenings, currentHour: currentHour)
    }
}
