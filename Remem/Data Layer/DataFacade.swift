//
//  DataFacade.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 12.07.2022.
//

import Foundation

class DataFacade {
    private let eventsRepository = CountableEventsRepository()
    private let happeningsRepository = CountableEventHappeningDescriptionsRepository()
}

// MARK: - Public
extension DataFacade {
    func getCountableEventsAmount() -> Int {
        eventsRepository.fetch()
        return eventsRepository.getAmount()
    }

    func countableEvent(at index: Int) -> CountableEvent? { return eventsRepository.countableEvent(at: index) }

    func countableEvent(by id: String) -> CountableEvent? { return eventsRepository.countableEvent(by: id) }

    @discardableResult
    func makeCountableEvent(name: String) -> CountableEvent { return eventsRepository.make(name: name) }

    @discardableResult
    func makeCountableEventHappeningDescription(at countableEvent: CountableEvent, dateTime: Date) -> CountableEventHappeningDescription {
        return eventsRepository.makeCountableEventHappeningDescription(at: countableEvent, dateTime: dateTime)
    }

    func getAllCountableEventHappeningDescriptionsAmount() -> Int { return happeningsRepository.getTotalCountableEventHappeningDescriptionsAmount() }

    func getCountableEventHappeningDescriptions(for countableEvent: CountableEvent, between start: Date, and end: Date) -> [CountableEventHappeningDescription] {
        print(#function)
        return happeningsRepository.getCountableEventHappeningDescriptions(for: countableEvent, between: start, and: end)
    }

    func getVisitedCountableEventsAmount() -> Int { return eventsRepository.getVisitedAmount() }

    func delete(countableEvent: CountableEvent) { eventsRepository.delete(countableEvent) }

    func visit(countableEvent: CountableEvent) { eventsRepository.visit(countableEvent) }
}
