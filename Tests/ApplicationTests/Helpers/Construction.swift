//
//  Construction.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 04.03.2023.
//

@testable import Application
import Domain
import Foundation

extension ApplicationContainer {
    static func make() -> EventsListViewController {
        ApplicationContainer(testingInMemoryMode: true)
            .makeContainer()
            .make() as! EventsListViewController
    }

    static func make() -> EventDetailsViewController {
        let day = DayIndex.referenceValue
        let event = Event(name: "", dateCreated: day.date)

        return ApplicationContainer(testingInMemoryMode: true)
            .makeContainer()
            .makeContainer(event: event, today: day)
            .make() as! EventDetailsViewController
    }

    static func make() -> WeekViewController {
        let day = DayIndex.referenceValue
        let event = Event(name: "", dateCreated: day.date)
        let detailsContainer = ApplicationContainer(testingInMemoryMode: true)
            .makeContainer()
            .makeContainer(event: event, today: day)

        return WeekContainer(parent: detailsContainer).make() as! WeekViewController
    }

    static func make() -> ClockViewController {
        let day = DayIndex.referenceValue
        let event = Event(name: "", dateCreated: day.date)
        let detailsContainer = ApplicationContainer(testingInMemoryMode: true)
            .makeContainer()
            .makeContainer(event: event, today: day)

        return ClockContainer(parent: detailsContainer).make() as! ClockViewController
    }

    static func make() -> SummaryViewController {
        let day = DayIndex.referenceValue
        let event = Event(name: "", dateCreated: day.date)
        let detailsContainer = ApplicationContainer(testingInMemoryMode: true)
            .makeContainer()
            .makeContainer(event: event, today: day)

        return SummaryContainer(parent: detailsContainer).make() as! SummaryViewController
    }

    static func make() -> DayDetailsViewController {
        let day = DayIndex.referenceValue
        let event = Event(name: "", dateCreated: day.date)
        let detailsContainer = ApplicationContainer(testingInMemoryMode: true)
            .makeContainer()
            .makeContainer(event: event, today: day)

        return WeekContainer(parent: detailsContainer)
            .makeContainer(day: day)
            .make() as! DayDetailsViewController
    }

    static func make() -> PdfViewController {
        let container = PdfContainer(provider: LocalFile.testingPdfReport)
        return container.make() as! PdfViewController
    }

    static func make() -> PdfMakingViewController {
        let day = DayIndex.referenceValue
        let event = Event(name: "", dateCreated: day.date)
        let detailsContainer = ApplicationContainer(testingInMemoryMode: true)
            .makeContainer()
            .makeContainer(event: event, today: day)
        return detailsContainer.makePdfMakingViewController(
            detailsContainer.makeWeekViewController(),
            detailsContainer.makeSummaryViewController()
        )
    }
}
