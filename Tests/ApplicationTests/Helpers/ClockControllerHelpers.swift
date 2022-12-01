//
//  ClockControllerHelpers.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.11.2022.
//

@testable import Application
import Domain
import XCTest

struct TimeComponents {
    let h: Int
    let m: Int
    let s: Int
}

extension ClockController {
    static func make(event: Event = Event(name: "Event")) -> ClockController {
        ClockController(
            event: event,
            useCase: EventEditUseCasingFake(),
            sorter: DefaultClockSorter(size: 144)
        )
    }

    func addOneHappening(
        at: TimeComponents = TimeComponents(h: 1, m: 1, s: 1)
    ) {
        var today = DayComponents(date: .now).value
        today.hour = at.h
        today.minute = at.m
        today.second = at.s

        guard let date = Calendar.current.date(from: today)
        else { fatalError("error making time for insertion") }
        event.addHappening(date: date)
        update(event: event)
    }

    func forceViewToLayoutInScreenSize() {
        view.bounds = UIScreen.main.bounds
        view.layoutIfNeeded()
    }
}
