//
//  DayDetailsContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2023.
//

import Domain
import UIKit

protocol DayItemViewModelFactoring { func makeViewModel(happening: Happening) -> DayItemViewModel }

final class DayDetailsContainer:
    ControllerFactoring,
    DayItemViewModelFactoring
{
    let parent: WeekContainer
    var event: Event { parent.event }
    let day: DayIndex
    let updater: Updater<DayDetailsViewController, DayDetailsViewModelFactory>

    lazy var factory: DayDetailsViewModelFactory = {
        DayDetailsViewModelFactory(parent: self)
    }()

    init(
        parent: WeekContainer,
        day: DayIndex
    ) {
        print("DayDetailsContainer.init")
        self.parent = parent
        self.day = day
        let updater = Updater<DayDetailsViewController, DayDetailsViewModelFactory>(parent.updater)
        self.updater = updater
        updater.factory = factory
    }

    deinit { print("DayDetailsContainer.deinit") }

    func make() -> UIViewController {
        let controller = DayDetailsViewController(viewModel: factory.makeViewModel())
        updater.delegate = controller
        return controller
    }

    func makeViewModel(happening: Happening) -> DayItemViewModel {
        DayItemViewModel(
            event: event,
            happening: happening,
            commander: updater
        )
    }
}

class DayDetailsViewModelFactory: ViewModelFactoring {
    unowned var parent: DayDetailsContainer

    init(parent: DayDetailsContainer) { self.parent = parent }

    func makeViewModel() -> DayDetailsViewModel {
        DayDetailsViewModel(
            day: parent.day,
            event: parent.event,
            commander: parent.updater,
            itemFactory: parent
        )
    }
}
