//
//  EventsSortingContainerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 18.01.2024.
//

@testable import Application
import Foundation
import XCTest

final class EventsSortingContainerTests: XCTestCase {
    private var sut: EventsSortingContainer!

    override func setUp() {
        super.setUp()

        let applicationContainer = ApplicationContainer(mode: .unitTest)
        let listContainer = EventsListContainer(applicationContainer)
        sut = EventsSortingContainer(listContainer.sortingProvider)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_init_requiresEventsSortingQueryingAndTopOffset() { XCTAssertNotNil(sut) }

    func test_conformsToControllerFactoring() { sut is ControllerFactoring }

    func test_makeController_configuredForPresentationEventsSorting() {
        let controller = sut.make()

        XCTAssertNotNil(controller.transitioningDelegate)
        XCTAssertEqual(controller.modalPresentationStyle, .custom)
    }

    func test_makeController_isEventsSortingController() {
        let controller = sut.make()

        XCTAssertNotNil(controller as? EventsSortingController)
    }

    func test_presentationController_notNil() {
        XCTAssertNotNil(sut.presentationController(
            forPresented: UIViewController(),
            presenting: UIViewController(),
            source: UIViewController()
        ))
    }

    func test_presentationController_withTopOffsetProvided_configuresFinalFrame() {
        let topOffset = CGFloat(30)
        let applicationContainer = ApplicationContainer(mode: .unitTest)
        let listContainer = EventsListContainer(applicationContainer)
        sut = EventsSortingContainer(listContainer.sortingProvider, topOffset: topOffset)

        let presenting = UIViewController()
        presenting.view.frame = UIScreen.main.bounds

        let presentedViewFrame = sut.presentationController(
            forPresented: UIViewController(),
            presenting: presenting,
            source: presenting
        )!.frameOfPresentedViewInContainerView

        let screenHalf = UIScreen.main.bounds.width / 2

        XCTAssertTrue(presentedViewFrame.width > 0)
        XCTAssertTrue(presentedViewFrame.width < screenHalf)
        XCTAssertEqual(presentedViewFrame.minY, topOffset)
    }

    func test_presentationController_addsBackgroundViewWithTapHandler() {
        let presenting = UIViewController()
        presenting.view.frame = UIScreen.main.bounds

        guard let presentationController = sut.presentationController(
            forPresented: UIViewController(),
            presenting: presenting,
            source: UIViewController()
        ) as? EventsSortingPresentationController else { return XCTFail() }

        let background = presentationController.background

        XCTAssertGreaterThan(background.gestureRecognizers?.count ?? 0, 0)
    }

    func test_animationForPresentation() {
        XCTAssertNotNil(sut.animationController(
            forPresented: UIViewController(),
            presenting: UIViewController(),
            source: UIViewController()
        ))
    }

    func test_animationForDismiss() {
        XCTAssertNotNil(sut.animationController(forDismissed: UIViewController()))
    }
}
