//
//  DependencyContainersTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 05.03.2023.
//

@testable import Application
import Domain
import XCTest

final class DependencyContainersTests: XCTestCase {
    weak var weakSut: UIViewController?

    override func tearDown() {
        super.tearDown()
        XCTAssertNil(weakSut)
    }

    func test_eventsListContainer_hasNoCyclingReferences() {
        var vc: EventsListViewController? = ApplicationContainer.make()
        weakSut = vc

        vc = nil
    }

    func test_eventDetailsContainer_hasNoCyclingReferences() {
        var vc: EventDetailsViewController? = ApplicationContainer.make()
        weakSut = vc

        vc = nil
    }

    func test_weekContainer_hasNoCyclingReferences() {
        var vc: WeekViewController? = ApplicationContainer.make()
        weakSut = vc

        vc = nil
    }

    func test_clockContainer_hasNoCyclingReferences() {
        var vc: ClockViewController? = ApplicationContainer.make()
        weakSut = vc

        vc = nil
    }

    func test_summaryContainer_hasNoCyclingReferences() {
        var vc: SummaryViewController? = ApplicationContainer.make()
        weakSut = vc

        vc = nil
    }

    func test_dayDetailsContainer_hasNoCyclingReferences() {
        var vc: DayDetailsViewController? = ApplicationContainer.make()
        weakSut = vc

        vc = nil
    }

    func test_pdfContainer_hasNoCyclingReferences() {
        var vc: PdfViewController? = ApplicationContainer.make()
        weakSut = vc

        vc = nil
    }

    func test_pdfMakingContainer_hasNoCyclingReferences() {
        var vc: PdfMakingViewController? = ApplicationContainer.make()
        weakSut = vc

        vc = nil
    }
}

extension ApplicationContainer {
    static func make() -> EventsListViewController {
        EventsListContainer(ApplicationContainer(mode: .unitTest)).make() as! EventsListViewController
    }

    static func make() -> EventDetailsViewController {
        let day = DayIndex.referenceValue
        let event = Event(name: "", dateCreated: day.date)

        return EventDetailsContainer(ApplicationContainer(mode: .unitTest), event: event).make() as! EventDetailsViewController
    }

    static func make() -> WeekViewController {
        let day = DayIndex.referenceValue
        let event = Event(name: "", dateCreated: day.date)
        let container = WeekContainer(EventDetailsContainer(ApplicationContainer(mode: .unitTest), event: event))

        return container.make() as! WeekViewController
    }

    static func make() -> ClockViewController {
        let day = DayIndex.referenceValue
        let event = Event(name: "", dateCreated: day.date)
        let detailsContainer = EventDetailsContainer(ApplicationContainer(mode: .unitTest), event: event)

        return ClockContainer(parent: detailsContainer, type: .night).make() as! ClockViewController
    }

    static func make() -> SummaryViewController {
        let day = DayIndex.referenceValue
        let event = Event(name: "", dateCreated: day.date)
        let detailsContainer = EventDetailsContainer(ApplicationContainer(mode: .unitTest), event: event)

        return SummaryContainer(parent: detailsContainer).make() as! SummaryViewController
    }

    static func make() -> DayDetailsViewController {
        let day = DayIndex.referenceValue
        let event = Event(name: "", dateCreated: day.date)
        let detailsContainer = EventDetailsContainer(ApplicationContainer(mode: .unitTest), event: event)
        let currentMoment = detailsContainer.parent.currentMoment
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
        let detailsContainer = EventDetailsContainer(ApplicationContainer(mode: .unitTest), event: event)

        let pdfContainer = PdfMakingContainer(detailsContainer)

        return pdfContainer.make() as! PdfMakingViewController
    }
}
