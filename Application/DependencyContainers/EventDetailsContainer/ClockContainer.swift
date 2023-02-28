//
//  ClockContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 28.02.2023.
//

import Domain
import UIKit

protocol ClockItemViewModelFactoring {
    func make(
        index: Int,
        length: CGFloat,
        size: Int
    ) -> ClockItemViewModel
}

final class ClockContainer:
    ControllerFactoring,
    ClockItemViewModelFactoring
{
    let parent: EventDetailsContainer
    var event: Event { parent.event }

    lazy var updater: Updater<ClockViewController, ClockViewModelFactory> = {
        let updater = Updater<ClockViewController, ClockViewModelFactory>(parent.commander)
        updater.factory = viewModelFactory
        return updater
    }()

    lazy var viewModelFactory: ClockViewModelFactory = {
        ClockViewModelFactory(parent: self)
    }()

    init(parent: EventDetailsContainer) {
        print("ClockContainer.init")
        self.parent = parent
    }

    deinit { print("ClockContainer.deinit") }

    func make() -> UIViewController {
        let controller = ClockViewController(viewModel: viewModelFactory.makeViewModel())
        updater.delegate = controller
        return controller
    }

    func make(index: Int, length: CGFloat, size: Int) -> ClockItemViewModel {
        ClockItemViewModel(index: index, length: length, clockSize: size)
    }
}

final class ClockViewModelFactory: ViewModelFactoring {
    unowned let parent: ClockContainer

    init(parent: ClockContainer) { self.parent = parent }

    func makeViewModel() -> ClockViewModel {
        ClockViewModel(event: parent.event, size: 144, itemFactory: parent)
    }
}
