//
//  EventsSortingSnapshots.swift
//  ApplicationSnapshotsTests
//
//  Created by Stanislav Matvichuck on 18.01.2024.
//

@testable import Application
import iOSSnapshotTestCase

final class EventsSortingSnapshots: FBSnapshotTestCase {
    override func setUp() {
        super.setUp()
        configureSnapshotsOptions()
        recordMode = true
    }

    override func tearDown() { super.tearDown() }

    func test_initialState() {
        let viewModel = EventsSortingViewModel(.happeningsCountTotal)
        let sut = EventsSortingView()
        sut.viewModel = viewModel
        sut.frame = UIScreen.main.bounds
    
        FBSnapshotVerifyView(sut)
    }
}
