//
//  ClockControllerHelpers.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.11.2022.
//

@testable import Application
import Domain
import XCTest

extension ClockController {
    static func make(event: Event = Event(name: "Event")) -> ClockController {
        ClockController(event: event, useCase: EventEditUseCasingFake())
    }
}
