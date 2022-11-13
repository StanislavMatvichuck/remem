//
//  EventsList.swift
//  ApplicationSnapshotsTests
//
//  Created by Stanislav Matvichuck on 13.11.2022.
//

@testable import Application
import iOSSnapshotTestCase

class EventsListSnapshotsTest: FBSnapshotTestCase {
    var sut: EventsListController!

    override func setUp() {
        super.setUp()
        recordMode = true

        let viewModel = EventsListViewModelFake()
        let view = EventsListView()

        sut = EventsListController(
            viewRoot: view,
            viewModel: viewModel
        )

        let nav = ApplicationFactory.makeStyledNavigationController()
        nav.pushViewController(sut, animated: false)
        nav.navigationBar.prefersLargeTitles = true

        putInViewHierarchy(nav)
    }

    override func tearDown() {
        sut = nil
        executeRunLoop()
        super.tearDown()
    }

    var sutContainer: UIViewController { sut.navigationController! }

    func test_empty() {
        FBSnapshotVerifyViewController(sutContainer)
    }

    func test_empty_dark() {
        sutContainer.view.window?.overrideUserInterfaceStyle = .dark

        FBSnapshotVerifyViewController(sutContainer)
    }
}
