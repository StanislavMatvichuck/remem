//
//  UITestRepositoryConfigurator.swift
//  Application
//
//  Created by Stanislav Matvichuck on 05.06.2023.
//

import Domain
import Foundation

final class UITestRepositoryConfigurator {
    static let viewAndExportToday = DayIndex.referenceValue.adding(days: 15)

    func configure(
        repository: ApplicationContainer.Repository,
        for mode: ApplicationContainer.LaunchMode
    ) {
        let dateCreated = DayIndex.referenceValue.date
        switch mode {
        case .singleEvent:
            let event = Event(name: "Single event", dateCreated: dateCreated)
            repository.save(event)
        case .viewAndExport:
            let firstEvent = Event(name: "Any event you want to count", dateCreated: dateCreated)
            let secondEvent = Event(name: "Coffee ☕️", dateCreated: dateCreated)
            secondEvent.addHappening(date: dateCreated.addingTimeInterval(60 * 60 * 24 * 14 + 60 * 15))
            secondEvent.addHappening(date: dateCreated.addingTimeInterval(60 * 60 * 24 * 14 + 60 * 30))
            secondEvent.addHappening(date: dateCreated.addingTimeInterval(60 * 60 * 24 * 12 + 60 * 45))
            let thirdEvent = Event(name: "Fitness 👟", dateCreated: dateCreated)
            repository.save(firstEvent)
            repository.save(secondEvent)
            repository.save(thirdEvent)
        default: break
        }
    }
}
