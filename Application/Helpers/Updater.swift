//
//  Updater.swift
//  Application
//
//  Created by Stanislav Matvichuck on 22.02.2023.
//

import Domain
import Foundation

protocol ViewModelDisplaying {
    associatedtype ViewModel
    func update(_: ViewModel)
}

protocol ViewModelFactoring {
    associatedtype ViewModel
    func makeViewModel() -> ViewModel
}

final class Updater<
    Receiver: ViewModelDisplaying,
    Factory: ViewModelFactoring
>:
    EventsCommanding where Receiver.ViewModel == Factory.ViewModel
{
    var factory: Factory?
    var delegate: Receiver?
    private let commander: EventsCommanding

    init(_ commander: EventsCommanding) {
        self.commander = commander
    }

    func save(_ event: Event) {
        commander.save(event)
        update()
    }

    func delete(_ event: Event) {
        commander.delete(event)
        update()
    }

    func update() {
        guard let factory else { fatalError("updater factory is required") }
        delegate?.update(factory.makeViewModel())
    }
}

extension EventsListViewController: ViewModelDisplaying { func update(_ vm: EventsListViewModel) { viewModel = vm }}
extension WeekViewController: ViewModelDisplaying { func update(_ vm: WeekViewModel) { viewModel = vm }}
extension SummaryViewController: ViewModelDisplaying { func update(_ vm: SummaryViewModel) { viewModel = vm }}
extension DayDetailsViewController: ViewModelDisplaying { func update(_ vm: DayDetailsViewModel) { viewModel = vm }}
extension ClockViewController: ViewModelDisplaying { func update(_ vm: ClockViewModel) { viewModel = vm }}
