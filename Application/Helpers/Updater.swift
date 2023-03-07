//
//  Updater.swift
//  Application
//
//  Created by Stanislav Matvichuck on 22.02.2023.
//

import Domain
import Foundation

protocol Updating: AnyObject { func update() }

final class UpdatingCommander: EventsCommanding {
    weak var delegate: Updating?

    private let commander: EventsCommanding
    init(delegate: Updating? = nil, commander: EventsCommanding) {
        self.delegate = delegate
        self.commander = commander
    }

    func save(_ event: Event) {
        commander.save(event)
        delegate?.update()
    }

    func delete(_ event: Event) {
        commander.delete(event)
        delegate?.update()
    }
}

extension EventsListViewController: Updating {
    func update() {
        viewModel = factory.makeEventsListViewModel(self)
        widgetUpdater.update()
    }
}

extension WeekViewController: Updating { func update() { viewModel = factory.makeWeekViewModel() }}
extension DayDetailsViewController: Updating { func update() { viewModel = factory.makeDayViewModel() }}
extension SummaryViewController: Updating { func update() { viewModel = factory.makeSummaryViewModel() }}
extension ClockViewController: Updating { func update() { viewModel = factory.makeClockViewModel() }}

extension EventDetailsViewController: Updating {
    func update() {
        viewModel = factory.makeEventDetailsViewModel()

        for child in children {
            guard let child = child as? Updating else { continue }
            child.update()
        }
    }
}
