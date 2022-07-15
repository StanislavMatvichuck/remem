//
//  DomainFacade.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 12.07.2022.
//

import Foundation

class DomainFacade {
    private let dataFacade = DataFacade()
}

// MARK: - Public
extension DomainFacade {
    func getCountableEventsAmount() -> Int { dataFacade.getCountableEventsAmount() }

    func countableEvent(at index: Int) -> CountableEvent? { dataFacade.countableEvent(at: index) }

    func countableEvent(by id: String) -> CountableEvent? { dataFacade.countableEvent(by: id) }

    func getCountableEventHappeningDescriptions(for countableEvent: CountableEvent) -> [CountableEventHappeningDescription] { dataFacade.getCountableEventHappeningDescriptions(for: countableEvent, between: countableEvent.dateCreated!, and: .now) }

    @discardableResult
    func makeCountableEvent(name: String) -> CountableEvent { dataFacade.makeCountableEvent(name: name) }

    @discardableResult
    func makeCountableEventHappeningDescription(for countableEvent: CountableEvent, dateTime: Date) -> CountableEventHappeningDescription {
        dataFacade.makeCountableEventHappeningDescription(at: countableEvent, dateTime: dateTime)
    }

    func delete(countableEvent: CountableEvent) { dataFacade.delete(countableEvent: countableEvent) }
    func visit(countableEvent: CountableEvent) { dataFacade.visit(countableEvent: countableEvent) }

    func getCountableEventHappeningDescriptions(for countableEvent: CountableEvent, between start: Date, and end: Date) -> [CountableEventHappeningDescription] {
        dataFacade.getCountableEventHappeningDescriptions(for: countableEvent, between: start, and: end)
    }
}

// MARK: - Internal
extension DomainFacade {
    private func getAllCountableEventHappeningDescriptionsAmount() -> Int { dataFacade.getAllCountableEventHappeningDescriptionsAmount() }

    private func getVisitedCountableEventsAmount() -> Int { dataFacade.getVisitedCountableEventsAmount() }
}
