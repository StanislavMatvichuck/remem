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

        putInViewHierarchy(sut)
    }

    override func tearDown() {
        executeRunLoop()
        sut = nil
        super.tearDown()
    }

    func test_empty() {
        FBSnapshotVerifyViewController(sut)
    }

    func test_empty_dark() {
        sut.view.window?.overrideUserInterfaceStyle = .dark

        FBSnapshotVerifyViewController(sut)
    }
}
