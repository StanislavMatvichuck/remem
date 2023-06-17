//
//  UITestRepositoryConfigurator.swift
//  Application
//
//  Created by Stanislav Matvichuck on 05.06.2023.
//

import Domain
import Foundation

final class UITestRepositoryConfigurator {
    static let viewAndExportToday = DayIndex.referenceValue.adding(days: 18)
    static let eventsNames = ["Car broke down 🚙", "Coffee ☕️", "Fitness 👟"]
    static let dateCreated = DayIndex.referenceValue.date

    func configure(
        repository: ApplicationContainer.Repository,
        for mode: LaunchMode
    ) {
        let dateCreated = Self.dateCreated
        let firstEvent = Event(name: Self.eventsNames[0], dateCreated: dateCreated)
        let secondEvent = Event(name: Self.eventsNames[1], dateCreated: dateCreated)
        let thirdEvent = Event(name: Self.eventsNames[2], dateCreated: dateCreated)

        func addEvents() {
            repository.save(firstEvent)
            repository.save(secondEvent)
            repository.save(thirdEvent)
        }

        switch mode {
        case .appPreview02_swipingEvents:
            addEvents()
        case .appPreview02_viewDetailsAndExport:
            secondEvent.addHappening(date: dateCreated.addingTimeInterval(days(7) + hours(8) + minutes(13)))
            secondEvent.addHappening(date: dateCreated.addingTimeInterval(days(8) + hours(9) + minutes(5)))
            secondEvent.addHappening(date: dateCreated.addingTimeInterval(days(9) + hours(8) + minutes(47)))
            secondEvent.addHappening(date: dateCreated.addingTimeInterval(days(9) + hours(12) + minutes(20)))
            secondEvent.addHappening(date: dateCreated.addingTimeInterval(days(10) + hours(9) + minutes(1)))
            secondEvent.addHappening(date: dateCreated.addingTimeInterval(days(11) + hours(10) + minutes(20)))
            secondEvent.addHappening(date: dateCreated.addingTimeInterval(days(11) + hours(11) + minutes(53)))

            secondEvent.addHappening(date: dateCreated.addingTimeInterval(days(14) + hours(8) + minutes(13)))
            secondEvent.addHappening(date: dateCreated.addingTimeInterval(days(15) + hours(9) + minutes(27)))
            secondEvent.addHappening(date: dateCreated.addingTimeInterval(days(15) + hours(8) + minutes(7)))
            secondEvent.addHappening(date: dateCreated.addingTimeInterval(days(16) + hours(8) + minutes(35)))
            secondEvent.addHappening(date: dateCreated.addingTimeInterval(days(17) + hours(8) + minutes(42)))
            addEvents()
        case .appPreview02_addWeeklyGoal:
            addFitnessHappenings(thirdEvent)
            addEvents()
        case .appPreview03_widget, .appPreview03_darkMode:
            addFitnessHappenings(thirdEvent)
            mockAddingWeeklyGoal(thirdEvent)
            addEvents()
        default: break
        }
    }

    private func days(_ amount: Int) -> TimeInterval { TimeInterval(60 * 60 * 24 * amount) }
    private func hours(_ amount: Int) -> TimeInterval { TimeInterval(60 * 60 * amount) }
    private func minutes(_ amount: Int) -> TimeInterval { TimeInterval(60 * amount) }

    /// Bad naming
    private func addFitnessHappenings(_ event: Event) {
        event.addHappening(date: Self.dateCreated.addingTimeInterval(days(14) + hours(18) + minutes(13)))
        event.addHappening(date: Self.dateCreated.addingTimeInterval(days(16) + hours(20) + minutes(30)))
        event.addHappening(date: Self.dateCreated.addingTimeInterval(days(17) + hours(17) + minutes(15)))
    }

    private func mockAddingWeeklyGoal(_ event: Event) {
        let todayMock = Self.viewAndExportToday.date
        event.setWeeklyGoal(amount: 5, for: todayMock)
        event.addHappening(date: todayMock)
        event.addHappening(date: todayMock)
    }
}
