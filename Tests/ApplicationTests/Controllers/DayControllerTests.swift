//
//  DayControllerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 21.11.2022.
//

@testable import Application
import Domain
import ViewControllerPresentationSpy
import XCTest

class DayControllerTests: XCTestCase {
    var sut: DayController!

    override func setUp() {
        super.setUp()
        let event = Event(name: "EventName")
        let useCase = EventEditUseCasingFake()
        let sut = DayController(date: .now, event: event, useCase: useCase)
        sut.loadViewIfNeeded()

        _ = UINavigationController(rootViewController: sut)

        self.sut = sut
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_hasTitle() {
        let numberString = sut.title!.split(separator: " ").first
        let wordString = sut.title!.split(separator: " ").last

        XCTAssertNotNil(Int(numberString!))
        XCTAssertLessThanOrEqual(3, wordString!.count)
    }

    func test_hasEditButton() {
        let editButton = sut.navigationItem.rightBarButtonItem

        XCTAssertEqual(editButton?.title, String(localizationId: "button.edit"))
    }

    func test_editButtonTap_enablesEditMode() {
        let editButton = sut.navigationItem.rightBarButtonItem

        XCTAssertFalse(sut.viewRoot.happenings.isEditing, "precondition")

        tap(editButton!)

        XCTAssertTrue(sut.viewRoot.happenings.isEditing)
    }

    func test_editButtonTap_tapAgain_disablesEditMode() {
        let editButton = sut.navigationItem.rightBarButtonItem

        XCTAssertFalse(sut.viewRoot.happenings.isEditing, "precondition")

        tap(editButton!)
        tap(editButton!)

        XCTAssertFalse(sut.viewRoot.happenings.isEditing)
    }

    func test_hasCreateButton() {
        let createButton = sut.navigationItem.leftBarButtonItem

        XCTAssertEqual(createButton?.title, String(localizationId: "button.create"))
    }

    func test_createButtonTap_presentsAlert() {
        let verifier = AlertVerifier()
        let createButton = sut.navigationItem.leftBarButtonItem

        tap(createButton!)

        verifier.verify(
            title: String(localizationId: "button.create"),
            message: "",
            animated: true,
            actions: [
                .cancel(String(localizationId: "button.cancel")),
                .default(String(localizationId: "button.create"))
            ]
        )
    }

    func test_empty_showsNothing() {}
    func test_oneHappening_showsFirstHappeningTime() {}
    func test_manyHappenings_showsFewHappenings() {}
}
