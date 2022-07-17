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
    func getEventsAmount() -> Int { dataFacade.getEventsAmount() }

    func event(at index: Int) -> Event? { dataFacade.event(at: index) }

    func event(by id: String) -> Event? { dataFacade.event(by: id) }

    func getHappenings(for event: Event) -> [Happening] { dataFacade.getHappenings(for: event, between: event.dateCreated!, and: .now) }

    @discardableResult
    func makeEvent(name: String) -> Event { dataFacade.makeEvent(name: name) }

    @discardableResult
    func makeHappening(for event: Event, dateTime: Date) -> Happening {
        dataFacade.makeHappening(at: event, dateTime: dateTime)
    }

    func delete(event: Event) { dataFacade.delete(event: event) }
    func visit(event: Event) { dataFacade.visit(event: event) }

    func getHappenings(for event: Event, between start: Date, and end: Date) -> [Happening] {
        dataFacade.getHappenings(for: event, between: start, and: end)
    }
}

// MARK: - Internal
extension DomainFacade {
    private func getAllHappeningsAmount() -> Int { dataFacade.getAllHappeningsAmount() }

    private func getVisitedEventsAmount() -> Int { dataFacade.getVisitedEventsAmount() }
}
