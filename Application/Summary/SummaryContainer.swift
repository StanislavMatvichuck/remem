//
//  SummaryContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 28.02.2023.
//

import Domain
import UIKit

final class SummaryContainer:
    SummaryViewModelFactoring
{
    let parent: EventDetailsContainer

    var event: Event { parent.event }
    var currentMoment: Date { parent.parent.currentMoment }

    init(_ parent: EventDetailsContainer) { self.parent = parent }

    func makeSummaryController() -> SummaryViewController { SummaryViewController(self) }
    func makeSummaryViewModel() -> SummaryViewModel { SummaryViewModel(event: event, createdUntil: currentMoment) }
}
