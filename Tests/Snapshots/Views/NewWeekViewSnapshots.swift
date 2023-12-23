//
//  NewWeekViewSnapshots.swift
//  ApplicationSnapshotsTests
//
//  Created by Stanislav Matvichuck on 20.12.2023.
//

@testable import Application
import Domain
import Foundation
import iOSSnapshotTestCase

final class NewWeekViewSnapshots: FBSnapshotTestCase {
    override func setUp() {
        super.setUp()
        configureSnapshotsOptions()
        recordMode = true
    }

    func test_JanuaryFirstOf2000() {
        let today = DayIndex.referenceValue
        let event = Event(name: "", dateCreated: today.date)
        let container = NewWeekContainer(
            EventDetailsContainer(
                parent: EventsListContainer(
                    parent: ApplicationContainer(
                        mode: .unitTest
                    )
                ),
                event: event,
                today: today
            ),
            today: today.date
        )
        let sut = NewWeekView(frame: .screenSquare)
        sut.viewModel = container.makeNewWeekViewModel()
        sut.layoutIfNeeded()

        FBSnapshotVerifyView(sut)
    }
}
