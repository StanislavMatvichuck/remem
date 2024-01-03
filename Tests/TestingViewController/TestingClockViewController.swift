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

        let container = EventDetailsContainer(ApplicationContainer(mode: .unitTest), event: event)

        sut = ClockContainer(parent: container, type: .night).make() as? ClockViewController
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
        let view = sut.viewRoot
        view.clockFace.setNeedsLayout()
        view.frame = UIScreen.main.bounds
        view.layoutIfNeeded()
    }
}

struct TimeComponents {
    let h: Int
    let m: Int
    let s: Int
}
