//
//  EventsList.swift
//  ApplicationSnapshotsTests
//
//  Created by Stanislav Matvichuck on 13.11.2022.
//

@testable import Application
import iOSSnapshotTestCase

class EventsListSnapshotsTest: FBSnapshotTestCase {
    override func setUp() {
        super.setUp()

        recordMode = true
    }

    override func tearDown() {
        executeRunLoop()
        super.tearDown()
    }

    func test_empty() {
        let viewModel = EventsListViewModelFake()
        let view = EventsListView()
        let sut = EventsListController(
            viewRoot: view,
            viewModel: viewModel
        )

        putInViewHierarchy(sut)

        FBSnapshotVerifyViewController(sut)
    }

    func test_empty_dark() {
        let viewModel = EventsListViewModelFake()
        let view = EventsListView()
        let sut = EventsListController(
            viewRoot: view,
            viewModel: viewModel
        )

        putInViewHierarchy(sut)

        sut.viewRoot.window?.overrideUserInterfaceStyle = .dark

        FBSnapshotVerifyViewController(sut)
    }
}
