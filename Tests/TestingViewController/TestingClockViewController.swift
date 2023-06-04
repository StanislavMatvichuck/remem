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
        let today = DayIndex.referenceValue
        event = Event(name: "Event", dateCreated: today.date)

        let container = ApplicationContainer(mode: .unitTest)
            .makeContainer()
            .makeContainer(event: event, today: today)

        sut = ClockContainer(parent: container).make() as? ClockViewController
        sut.loadViewIfNeeded()
    }

    func addOneHappening(
        at: TimeComponents = TimeComponents(h: 1, m: 1, s: 1)
    ) {
        var today = Calendar.current.dateComponents([.hour, .minute, .second], from: .now)
        today.hour = at.h
        today.minute = at.m
        today.second = at.s

        event.addHappening(date: Calendar.current.date(from: today)!)
    }

    func sendEventUpdatesToController() {
        sut.update()
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
