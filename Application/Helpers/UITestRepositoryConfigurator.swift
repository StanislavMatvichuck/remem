//
//  UITestRepositoryConfigurator.swift
//  Application
//
//  Created by Stanislav Matvichuck on 05.06.2023.
//

import Domain
import Foundation

final class UITestRepositoryConfigurator {
    func configure(
        reader: EventsReading,
        writer: EventsWriting,
        for mode: LaunchMode
    ) {
        switch mode {
        case .appPreview: configureForPreview(writer: writer)
        case .performanceTestWritesData: configurePerformanceData(reader: reader, writer: writer)
        default: break
        }
    }

    // MARK: - Private
    private func configureForPreview(writer: EventsWriting) {
        let dateCreated = Date.now.addingTimeInterval(days(-21))
        var event = Event(name: "🔟 pull-ups", dateCreated: dateCreated)

        event.visit()
        event.addHappening(date: dateCreated.addingTimeInterval(days(20) + hours(8) + minutes(13)))
        event.addHappening(date: dateCreated.addingTimeInterval(days(19) + hours(9) + minutes(27)))
        event.addHappening(date: dateCreated.addingTimeInterval(days(18) + hours(5) + minutes(17)))
        event.addHappening(date: dateCreated.addingTimeInterval(days(15) + hours(0) + minutes(42)))
        event.addHappening(date: dateCreated.addingTimeInterval(days(15) + hours(3) + minutes(54)))
        event.addHappening(date: dateCreated.addingTimeInterval(days(13) + hours(9) + minutes(74)))
        writer.create(event: event)
    }

    private func configurePerformanceData(reader: EventsReading, writer: EventsWriting) {
        removeAllEvents(reader: reader, writer: writer)
        createEvents(writer: writer)
    }

    private func removeAllEvents(reader: EventsReading, writer: EventsWriting) {
        for id in reader.identifiers(using: .name) {
            writer.delete(id: id)
        }
    }

    private func createEvents(writer: EventsWriting) {
        for eventNumber in 1 ... EventsPerformanceDescriptor.eventsCount {
            let dateCreated = Date.now.addingTimeInterval(days(-EventsPerformanceDescriptor.daysPassedCount))
            var event = Event(name: "Event#\(eventNumber)", dateCreated: dateCreated)

            addHappenings(event: &event)

            writer.create(event: event)
        }
    }

    private func addHappenings(event: inout Event) {
        for day in 0 ..< EventsPerformanceDescriptor.daysPassedCount {
            for swipeHour in 0 ..< EventsPerformanceDescriptor.swipesPerDay {
                let happeningDate = Date.now.addingTimeInterval(days(-day) - hours(swipeHour))
                event.addHappening(date: happeningDate)
            }
        }
    }

    private func days(_ amount: Int) -> TimeInterval { TimeInterval(60 * 60 * 24 * amount) }
    private func hours(_ amount: Int) -> TimeInterval { TimeInterval(60 * 60 * amount) }
    private func minutes(_ amount: Int) -> TimeInterval { TimeInterval(60 * amount) }
}

private enum EventsPerformanceDescriptor {
    static let eventsCount = 100
    static let yearsPassed = 10
    static let daysPassedCount = yearsPassed * 365
    static let swipesPerDay = 3
}
