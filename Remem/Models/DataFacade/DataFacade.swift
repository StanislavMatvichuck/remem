//
//  DataFacade.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 12.07.2022.
//

import CoreData

class DataFacade {
    private let entriesService = CountableEventsService()
    private let happeningsService = CountableEventHappeningDescriptionsService()
}

// MARK: - Public
extension DataFacade {
    func getCountableEventsAmount() -> Int {
        entriesService.fetch()
        return entriesService.getAmount()
    }

    func countableEvent(at index: Int) -> CountableEvent? { return entriesService.countableEvent(at: index) }

    func countableEvent(by id: String) -> CountableEvent? { return entriesService.countableEvent(by: id) }

    @discardableResult
    func makeCountableEvent(name: String) -> CountableEvent { return entriesService.make(name: name) }

    @discardableResult
    func makeCountableEventHappeningDescription(at countableEvent: CountableEvent, dateTime: Date) -> CountableEventHappeningDescription {
        return entriesService.makeCountableEventHappeningDescription(at: countableEvent, dateTime: dateTime)
    }

    func getAllCountableEventHappeningDescriptionsAmount() -> Int { return happeningsService.getTotalCountableEventHappeningDescriptionsAmount() }

    func getCountableEventHappeningDescriptions(for countableEvent: CountableEvent, between start: Date, and end: Date) -> [CountableEventHappeningDescription] {
        print(#function)
        return happeningsService.getCountableEventHappeningDescriptions(for: countableEvent, between: start, and: end)
    }

    func getVisitedCountableEventsAmount() -> Int { return entriesService.getVisitedAmount() }

    func delete(countableEvent: CountableEvent) { entriesService.delete(countableEvent) }

    func visit(countableEvent: CountableEvent) { entriesService.visit(countableEvent) }
}
