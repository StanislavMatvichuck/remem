//
//  ClockViewControllerHelpers.swift
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

extension ClockViewController {
    func addOneHappening(
        at: TimeComponents = TimeComponents(h: 1, m: 1, s: 1)
    ) {
        var today = DayComponents(date: .now).value
        today.hour = at.h
        today.minute = at.m
        today.second = at.s

        guard let date = Calendar.current.date(from: today)
        else { fatalError("error making time for insertion") }
        let existingEvent = viewModel.event
        existingEvent.addHappening(date: date)
        let newViewModel = ClockViewModel(
            event: existingEvent,
            sorter: DefaultClockSorter(size: 144)
        )

        update(viewModel: newViewModel)
    }

    func forceViewToLayoutInScreenSize() {
        view.bounds = UIScreen.main.bounds
        view.layoutIfNeeded()
    }

    static func make(event: Event = Event(name: "Event")) -> ClockViewController {
        ClockViewController(
            viewModel: ClockViewModel(
                event: event,
                sorter: DefaultClockSorter(size: 144)
            ))
    }
}
