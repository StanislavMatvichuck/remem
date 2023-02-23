//
//  ClockViewControllerHelpers.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.11.2022.
//

@testable import Application
import Domain
import XCTest

extension TestingViewController where Controller == ClockViewController {
    func make() {
        event = Event(name: "Event")
        let today = DayIndex.referenceValue
        let container = ApplicationContainer(testingInMemoryMode: true)
            .makeContainer()
            .makeContainer(event: event, today: today)
        sut = container.makeClockViewController()
        commander = container.weekViewModelUpdater
        sut.loadViewIfNeeded()
    }

    func addOneHappening(
        at: TimeComponents = TimeComponents(h: 1, m: 1, s: 1)
    ) {
        var today = calendar.dateComponents([.hour, .minute, .second], from: .now)
        today.hour = at.h
        today.minute = at.m
        today.second = at.s

        event.addHappening(date: calendar.date(from: today)!)
    }

    func sendEventUpdatesToController() {
        commander.save(event)
    }

    func forceViewToLayoutInScreenSize() {
        sut.view.bounds = UIScreen.main.bounds
        sut.view.layoutIfNeeded()
    }
}

struct TimeComponents {
    let h: Int
    let m: Int
    let s: Int
}
