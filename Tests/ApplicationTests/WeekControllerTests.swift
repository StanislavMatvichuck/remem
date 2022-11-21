//
//  WeekControllerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 21.11.2022.
//

@testable import Application
import Domain
import ViewControllerPresentationSpy
import XCTest

class WeekControllerTests: XCTestCase {
    var presentationSpy: PresentationVerifier!
    var sut: WeekController!

    override func setUp() {
        super.setUp()
        let spy = PresentationVerifier()
        let event = Event(name: "Event")
        let useCase = EventEditUseCasingFake()
        let sut = WeekController(event: event, useCase: useCase)

        self.sut = sut
        presentationSpy = spy
    }

    override func tearDown() {
        presentationSpy = nil
        sut = nil
        executeRunLoop()
        super.tearDown()
    }

    func test_empty_displays21Columns() {
        XCTAssertEqual(sut.viewRoot.collection.numberOfItems(inSection: 0), 21)
    }

    func test_empty_hasTodayColumn() {
        let todays = sut.viewModel.weekCellViewModels.filter { $0.isToday }

        XCTAssertEqual(todays.count, 1)
    }

    func test_tap_presentsDayController() throws {
        let collection = sut.viewRoot.collection
        let firstCellIndex = IndexPath(row: 0, section: 0)
//        let cell = collection.dataSource?.collectionView(
//            collection,
//            cellForItemAt: firstCellIndex
//        )
//        let item = try XCTUnwrap(cell as? WeekCell)

        collection.delegate?.collectionView?(
            collection,
            didSelectItemAt: firstCellIndex
        )

        presentationSpy.verify(animated: true, presentingViewController: sut)
    }
}
