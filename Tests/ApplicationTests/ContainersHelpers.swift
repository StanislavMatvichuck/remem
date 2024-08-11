//
//  ContainersHelpers.swift
//  Domain
//
//  Created by Stanislav Matvichuck on 16.04.2024.
//

@testable import Application
import Domain
import Foundation

extension EventsListContainer { static func makeForUnitTests() -> EventsListContainer { EventsListContainer(ApplicationContainer(mode: .unitTest)) }}
extension EventCreationContainer { static func makeForUnitTests() -> EventCreationContainer { EventCreationContainer(parent: ApplicationContainer(mode: .unitTest)) }}
extension EventsSortingContainer { static func makeForUnitTests() -> EventsSortingContainer { EventsSortingContainer(EventsListContainer.makeForUnitTests()) }}

extension EventDetailsContainer {
    static func makeForUnitTests(event: Event = Event.makeForUnitTests()) -> EventDetailsContainer {
        let app = ApplicationContainer(mode: .unitTest)
        app.eventsWriter.create(event: event)
        return EventDetailsContainer(app, eventId: event.id)
    }
}

extension WeekContainer { static func makeForUnitTests() -> WeekContainer { WeekContainer(EventDetailsContainer.makeForUnitTests()) }}
extension SummaryContainer { static func makeForUnitTests() -> SummaryContainer { SummaryContainer(EventDetailsContainer.makeForUnitTests()) }}
extension GoalsContainer { static func makeForUnitTests() -> GoalsContainer { GoalsContainer(EventDetailsContainer.makeForUnitTests()) }}
extension HourDistributionContainer { static func makeForUnitTests() -> HourDistributionContainer { HourDistributionContainer(EventDetailsContainer.makeForUnitTests()) }}
extension DayOfWeekContainer { static func makeForUnitTests() -> DayOfWeekContainer { DayOfWeekContainer(EventDetailsContainer.makeForUnitTests()) }}
extension PDFWritingContainer { static func makeForUnitTests() -> PDFWritingContainer { PDFWritingContainer(EventDetailsContainer.makeForUnitTests()) }}
extension DayDetailsContainer { static func makeForUnitTests() -> DayDetailsContainer { DayDetailsContainer(EventDetailsContainer.makeForUnitTests(), startOfDay: DayIndex.referenceValue.date) }}

extension Event {
    static func makeForUnitTests() -> Event { Event(name: "", dateCreated: DayIndex.referenceValue.date) }
    static func make(with happenings: [Happening]) -> Event {
        Event(
            id: UUID().uuidString,
            name: "",
            happenings: happenings,
            dateCreated: .distantPast,
            dateVisited: nil
        )
    }
}
