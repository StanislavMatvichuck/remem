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

protocol ClockViewControllerTesting: AnyObject {
    var sut: ClockViewController! { get set }
    var event: Event! { get set }
    var viewModelFactory: ClockViewModelFactoring! { get set }
}

extension ClockViewControllerTesting {
    func addOneHappening(
        at: TimeComponents = TimeComponents(h: 1, m: 1, s: 1)
    ) {
        var today = DayComponents(date: .now).value // DateComponents.value usage02
        today.hour = at.h
        today.minute = at.m
        today.second = at.s

        guard let date = Calendar.current.date(from: today)
        else { fatalError("error making time for insertion") }

        event.addHappening(date: date)
    }

    func sendEventUpdatesToController() {
        sut.viewModel = viewModelFactory.makeViewModel()
    }

    func makeSutWithViewModelFactory() {
        event = Event(name: "Event")
        let today = DayComponents.referenceValue
        let container = ApplicationContainer(testingInMemoryMode: true)
            .makeContainer()
            .makeContainer(event: event, today: today)
        sut = container.makeClockViewController()
        viewModelFactory = container
    }

    func clearSutAndViewModelFactory() {
        event = nil
        sut = nil
        viewModelFactory = nil
    }
}

struct TimeComponents {
    let h: Int
    let m: Int
    let s: Int
}
