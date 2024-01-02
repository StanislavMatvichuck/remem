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
        EventsListContainer(ApplicationContainer(mode: .unitTest)).make() as! EventsListViewController
    }

    static func make() -> EventDetailsViewController {
        let day = DayIndex.referenceValue
        let event = Event(name: "", dateCreated: day.date)

        return EventDetailsContainer(
            EventsListContainer(
                ApplicationContainer(mode: .unitTest)
            ),
            event: event
        ).make() as! EventDetailsViewController
    }

    static func make() -> WeekViewController {
        let day = DayIndex.referenceValue
        let event = Event(name: "", dateCreated: day.date)
        let container = WeekContainer(
            EventDetailsContainer(
                EventsListContainer(
                    ApplicationContainer(mode: .unitTest)
                ),
                event: event
            ), today: day.date)

        return container.make() as! WeekViewController
    }

    static func make() -> ClockViewController {
        let day = DayIndex.referenceValue
        let event = Event(name: "", dateCreated: day.date)
        let detailsContainer = EventDetailsContainer(
            EventsListContainer(
                ApplicationContainer(mode: .unitTest)
            ), event: event
        )

        return ClockContainer(parent: detailsContainer, type: .night).make() as! ClockViewController
    }

    static func make() -> SummaryViewController {
        let day = DayIndex.referenceValue
        let event = Event(name: "", dateCreated: day.date)
        let detailsContainer = EventDetailsContainer(
            EventsListContainer(
                ApplicationContainer(mode: .unitTest)
            ), event: event
        )

        return SummaryContainer(parent: detailsContainer).make() as! SummaryViewController
    }

    static func make() -> DayDetailsViewController {
        let day = DayIndex.referenceValue
        let event = Event(name: "", dateCreated: day.date)
        let detailsContainer = EventDetailsContainer(
            EventsListContainer(
                ApplicationContainer(mode: .unitTest)
            ), event: event
        )
        let currentMoment = detailsContainer.parent.parent.currentMoment
        let dayDetailsContainer = DayDetailsContainer(
            parent: detailsContainer,
            day: day,
            hour: Calendar.current.component(.hour, from: currentMoment),
            minute: Calendar.current.component(.minute, from: currentMoment)
        )

        return dayDetailsContainer.make() as! DayDetailsViewController
    }

    static func make() -> PdfViewController {
        let container = PdfContainer(provider: LocalFile.testingPdfReport)
        return container.make() as! PdfViewController
    }

    static func make() -> PdfMakingViewController {
        let day = DayIndex.referenceValue
        let event = Event(name: "", dateCreated: day.date)
        let detailsContainer = EventDetailsContainer(
            EventsListContainer(
                ApplicationContainer(mode: .unitTest)
            ), event: event
        )

        let pdfContainer = PdfMakingContainer(parent: detailsContainer)

        return pdfContainer.make() as! PdfMakingViewController
    }
}
