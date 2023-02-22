//
//  CoreDataStackTesting.swift
//  DataLayer
//
//  Created by Stanislav Matvichuck on 19.02.2023.
//

import CoreData
import DataLayer
import Domain

enum TestingCase {
    case EmptyEvents(amount: Int)
}

func scanLaunchArgumentsAndPrepareRepositoryIfNeeded(_ repository: CoreDataEventsRepository) {
    let launchArgument = CommandLine.arguments.first { $0.hasPrefix("eventsAmount") } ?? " "
    let index = launchArgument.index(after: launchArgument.lastIndex(of: " ")!)

    if let amount = Int(launchArgument.suffix(from: index)) {
        prepare(repository, for: .EmptyEvents(amount: amount))
    }
}

func prepare(_ repository: CoreDataEventsRepository, for testingCase: TestingCase) {
    for event in repository.get() {
        repository.delete(event)
    }

    switch testingCase {
    case .EmptyEvents(let amount):
        for i in 0 ..< amount {
            let day = DayIndex(.now).adding(days: -2 * 365)
            let event = Event(name: "Event\(i)", dateCreated: day.date)
            let daysTrackedAmount: Int = {
                var timeline = DayTimeline<Bool>()
                timeline[DayIndex(event.dateCreated)] = true
                timeline[DayIndex(.now)] = true
                return timeline.count
            }()

            for j in 0 ..< daysTrackedAmount {
                let date = day.adding(days: j).date.addingTimeInterval(
                    TimeInterval(
                        Double(Int.random(in: 0 ..< 100)) / 100.0 * 60.0 * 60.0 * 24.0
                    ))
                event.addHappening(date: date)
            }

            repository.save(event)
        }
    }
}
