//
//  SummaryContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 28.02.2023.
//

import Domain
import UIKit

protocol SummaryItemViewModelFactoring {
    func make(_: SummaryRow) -> SummaryItemViewModel
}

final class SummaryContainer:
    ControllerFactoring,
    SummaryItemViewModelFactoring
{
    let parent: EventDetailsContainer

    var commander: EventsCommanding { parent.commander }
    var event: Event { parent.event }
    var today: DayIndex { parent.today }

    lazy var updater: Updater<SummaryViewController, SummaryViewModelFactory> = {
        let updater = Updater<SummaryViewController, SummaryViewModelFactory>(commander)
        updater.factory = viewModelFactory
        return updater
    }()

    lazy var viewModelFactory: SummaryViewModelFactory = {
        SummaryViewModelFactory(parent: self)
    }()

    init(parent: EventDetailsContainer) {
        print("SummaryContainer.init")
        self.parent = parent
    }

    deinit { print("SummaryContainer.deinit") }

    func make() -> UIViewController {
        let controller = SummaryViewController(viewModel: viewModelFactory.makeViewModel())
        updater.delegate = controller
        return controller
    }

    func make(_ row: SummaryRow) -> SummaryItemViewModel {
        SummaryItemViewModel(
            title: row.label,
            value: row.value,
            titleTag: row.labelTag,
            valueTag: row.valueTag
        )
    }
}

final class SummaryViewModelFactory: ViewModelFactoring {
    unowned let parent: SummaryContainer

    init(parent: SummaryContainer) { self.parent = parent }

    func makeViewModel() -> SummaryViewModel {
        SummaryViewModel(
            event: parent.event,
            today: parent.today,
            itemFactory: parent
        )
    }
}
