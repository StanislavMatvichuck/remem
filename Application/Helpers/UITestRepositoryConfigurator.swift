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

    func configure(
        repository: ApplicationContainer.Repository,
        for mode: LaunchMode
    ) {
        let dateCreated = DayIndex.referenceValue.date
        switch mode {
        case .singleEvent:
            let event = Event(name: "Single event", dateCreated: dateCreated)
            repository.save(event)
        case .appPreview02_viewAndExport:
            let firstEvent = Event(name: "Any event you want to count", dateCreated: dateCreated)
            let secondEvent = Event(name: "Coffee ☕️", dateCreated: dateCreated)
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
            let thirdEvent = Event(name: "Fitness 👟", dateCreated: dateCreated)
            repository.save(firstEvent)
            repository.save(secondEvent)
            repository.save(thirdEvent)
        case .appPreview02_addWeeklyGoal:
            let firstEvent = Event(name: "Any event you want to count", dateCreated: dateCreated)
            let secondEvent = Event(name: "Coffee ☕️", dateCreated: dateCreated)
            let thirdEvent = Event(name: "Fitness 👟", dateCreated: dateCreated)
            thirdEvent.addHappening(date: dateCreated.addingTimeInterval(days(14) + hours(18) + minutes(13)))
            thirdEvent.addHappening(date: dateCreated.addingTimeInterval(days(16) + hours(20) + minutes(30)))
            thirdEvent.addHappening(date: dateCreated.addingTimeInterval(days(17) + hours(17) + minutes(15)))

            repository.save(firstEvent)
            repository.save(secondEvent)
            repository.save(thirdEvent)
        default: break
        }
    }

    private func days(_ amount: Int) -> TimeInterval { TimeInterval(60 * 60 * 24 * amount) }
    private func hours(_ amount: Int) -> TimeInterval { TimeInterval(60 * 60 * amount) }
    private func minutes(_ amount: Int) -> TimeInterval { TimeInterval(60 * amount) }
}
