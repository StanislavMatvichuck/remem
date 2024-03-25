//
//  DependencyContainersTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 05.03.2023.
//

@testable import Application
import DataLayer
import Domain
import XCTest

final class DependencyContainersTests: XCTestCase {
    weak var weakSut: UIViewController?

    override func tearDown() {
        super.tearDown()
        XCTAssertNil(weakSut)
    }

    func test_eventsListContainer_hasNoCyclingReferences() {
        var vc: EventsListController? = ApplicationContainer.make()
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

    func test_pdfReadingContainer_hasNoCyclingReferences() {
        var vc: PDFReadingViewController? = ApplicationContainer.make()
        weakSut = vc

        vc = nil
    }

    func test_pdfWritignContainer_hasNoCyclingReferences() {
        var vc: PDFWritingViewController? = ApplicationContainer.make()
        weakSut = vc

        vc = nil
    }
}

extension ApplicationContainer {
    static func make() -> EventsListController {
        EventsListContainer(ApplicationContainer(mode: .unitTest)).make() as! EventsListController
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
        let dayDetailsContainer = DayDetailsContainer(detailsContainer, startOfDay: DayIndex.referenceValue.date)
        return dayDetailsContainer.make() as! DayDetailsViewController
    }

    static func make() -> PDFReadingViewController {
        let container = PDFReadingContainer(provider: LocalFile.testingPdfReport)
        return container.make() as! PDFReadingViewController
    }

    static func make() -> PDFWritingViewController {
        let day = DayIndex.referenceValue
        let event = Event(name: "", dateCreated: day.date)
        let detailsContainer = EventDetailsContainer(ApplicationContainer(mode: .unitTest), event: event)

        let pdfContainer = PDFWritingContainer(detailsContainer)

        return pdfContainer.make() as! PDFWritingViewController
    }
}
