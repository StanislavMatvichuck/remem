//
//  WeekContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 28.02.2023.
//

import Domain
import UIKit

protocol WeekItemViewModelFactoring { func makeViewModel(day: DayIndex) -> WeekItemViewModel }

final class WeekContainer:
    ControllerFactoring,
    WeekItemViewModelFactoring
{
    let parent: EventDetailsContainer

    var event: Event { parent.event }
    var today: DayIndex { parent.today }
    var coordinator: Coordinator { parent.coordinator }

    lazy var updater: Updater<WeekViewController, WeekViewModelFactory> = {
        let updater = Updater<WeekViewController, WeekViewModelFactory>(parent.commander)
        updater.factory = viewModelFactory
        return updater
    }()

    lazy var viewModelFactory: WeekViewModelFactory = { WeekViewModelFactory(parent: self) }()

    init(parent: EventDetailsContainer) {
        print("WeekContainer.init")
        self.parent = parent
    }

    deinit { print("WeekContainer.deinit") }

    func make() -> UIViewController {
        let controller = WeekViewController(viewModel: viewModelFactory.makeViewModel())
        updater.delegate = controller
        return controller
    }

    func makeViewModel(day: DayIndex) -> WeekItemViewModel {
        WeekItemViewModel(
            event: event,
            day: day,
            today: today,
            tapHandler: {
                self.coordinator.show(Navigation.dayDetails(factory: self.makeContainer(day: day)))
            }
        )
    }

    func makeContainer(day: DayIndex) -> DayDetailsContainer {
        DayDetailsContainer(
            parent: self,
            day: day
        )
    }
}

final class WeekViewModelFactory: ViewModelFactoring {
    unowned let parent: WeekContainer

    init(parent: WeekContainer) { self.parent = parent }

    func makeViewModel() -> WeekViewModel {
        WeekViewModel(
            today: parent.today,
            event: parent.event,
            coordinator: parent.coordinator,
            itemFactory: parent
        )
    }
}
