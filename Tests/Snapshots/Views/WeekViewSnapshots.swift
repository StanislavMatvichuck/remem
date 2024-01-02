//
//  WeekViewSnapshots.swift
//  ApplicationSnapshotsTests
//
//  Created by Stanislav Matvichuck on 20.12.2023.
//

@testable import Application
import Domain
import Foundation
import iOSSnapshotTestCase

final class WeekViewSnapshots: FBSnapshotTestCase {
    override func setUp() {
        super.setUp()
        configureSnapshotsOptions()
        recordMode = true
    }

    func test_JanuaryFirstOf2000() {
        let today = DayIndex.referenceValue
        let event = Event(name: "", dateCreated: today.date)
        let happenings: [Date] = [
            today.date,
            today.date,
            today.date,
            today.date,
            today.date,
            today.date,
            today.date,
            today.adding(days: 1).date,
            today.adding(days: 1).date,
            today.adding(days: 1).date,
            today.adding(days: 1).date,
            today.adding(days: 1).date,
            today.adding(days: 1).date,
            today.adding(days: 2).date,
            today.adding(days: 2).date,
            today.adding(days: 2).date,
            today.adding(days: 2).date,
            today.adding(days: 2).date,
            today.adding(days: 3).date,
            today.adding(days: 3).date,
            today.adding(days: 3).date,
            today.adding(days: 3).date,
            today.adding(days: 4).date,
            today.adding(days: 4).date,
            today.adding(days: 4).date,
            today.adding(days: 5).date,
            today.adding(days: 5).date,
            today.adding(days: 6).date,
        ]

        happenings.forEach { event.addHappening(date: $0) }

        let container = WeekContainer(
            EventDetailsContainer(
                EventsListContainer(
                    ApplicationContainer(
                        mode: .unitTest
                    )
                ),
                event: event
            ),
            today: today.date
        )
        let sut = WeekView()
        sut.frame = .screenSquare
        sut.viewModel = container.makeWeekViewModel()
        sut.layoutIfNeeded()

        FBSnapshotVerifyView(sut)
    }
}
