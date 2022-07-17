//
//  DataFacade.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 12.07.2022.
//

import Foundation

class DataFacade {
    private let eventsRepository = EventsRepository()
    private let happeningsRepository = HappeningsRepository()
}

// MARK: - Public
extension DataFacade {
    func getEventsAmount() -> Int {
        eventsRepository.fetch()
        return eventsRepository.getAmount()
    }

    func event(at index: Int) -> Event? { return eventsRepository.event(at: index) }

    func event(by id: String) -> Event? { return eventsRepository.event(by: id) }

    @discardableResult
    func makeEvent(name: String) -> Event { return eventsRepository.make(name: name) }

    @discardableResult
    func makeHappening(at event: Event, dateTime: Date) -> Happening {
        return eventsRepository.makeHappening(at: event, dateTime: dateTime)
    }

    func getAllHappeningsAmount() -> Int { return happeningsRepository.getTotalHappeningsAmount() }

    func getHappenings(for event: Event, between start: Date, and end: Date) -> [Happening] {
        print(#function)
        return happeningsRepository.getHappenings(for: event, between: start, and: end)
    }

    func getVisitedEventsAmount() -> Int { return eventsRepository.getVisitedAmount() }

    func delete(event: Event) { eventsRepository.delete(event) }

    func visit(event: Event) { eventsRepository.visit(event) }
}
