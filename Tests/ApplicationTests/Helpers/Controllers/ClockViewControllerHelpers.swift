//
//  ClockViewControllerHelpers.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.11.2022.
//

@testable import Application
import Domain
import XCTest

extension ClockViewController {
    func forceViewToLayoutInScreenSize() {
        view.bounds = UIScreen.main.bounds
        view.layoutIfNeeded()
    }
}

protocol ClockViewControllerTesting {
    var sut: ClockViewController! { get set }
    var event: Event! { get set }
    var viewModelFactory: ClockViewModelFactoring! { get set }
}

extension ClockViewControllerTesting {
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
    }

    func sendEventUpdatesToController() {
        sut.viewModel = viewModelFactory.makeClockViewModel(event: event)
    }
}

struct TimeComponents {
    let h: Int
    let m: Int
    let s: Int
}
