//
//  UITestRepositoryConfigurator.swift
//  Application
//
//  Created by Stanislav Matvichuck on 05.06.2023.
//

import Domain
import Foundation

final class UITestRepositoryConfigurator {
    static let eventsNames = ["🔟 pull-ups", "Coffee ☕️", "Fitness 👟"]

    func configure(
        repository: ApplicationContainer.Repository,
        for mode: LaunchMode
    ) {
        let dateCreated = Date.now.addingTimeInterval(Self.days(-21))
        let firstEvent = Event(name: Self.eventsNames[0], dateCreated: dateCreated)
        let secondEvent = Event(name: Self.eventsNames[1], dateCreated: dateCreated)
        let thirdEvent = Event(name: Self.eventsNames[2], dateCreated: dateCreated)

        func addEvents() {
            repository.create(event: firstEvent)
            repository.create(event: secondEvent)
            repository.create(event: thirdEvent)
        }

        switch mode {
        case .appPreview:
            firstEvent.visit()
            firstEvent.addHappening(date: dateCreated.addingTimeInterval(Self.days(20) + hours(8) + minutes(13)))
            firstEvent.addHappening(date: dateCreated.addingTimeInterval(Self.days(19) + hours(9) + minutes(27)))
            firstEvent.addHappening(date: dateCreated.addingTimeInterval(Self.days(18) + hours(5) + minutes(17)))
            firstEvent.addHappening(date: dateCreated.addingTimeInterval(Self.days(15) + hours(0) + minutes(42)))
            firstEvent.addHappening(date: dateCreated.addingTimeInterval(Self.days(15) + hours(3) + minutes(54)))
            firstEvent.addHappening(date: dateCreated.addingTimeInterval(Self.days(13) + hours(9) + minutes(74)))
            repository.create(event: firstEvent)
        default: break
        }
    }

    private static func days(_ amount: Int) -> TimeInterval { TimeInterval(60 * 60 * 24 * amount) }
    private func hours(_ amount: Int) -> TimeInterval { TimeInterval(60 * 60 * amount) }
    private func minutes(_ amount: Int) -> TimeInterval { TimeInterval(60 * amount) }
}
