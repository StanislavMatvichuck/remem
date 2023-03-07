//
//  Stubs.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 25.01.2023.
//

@testable import Application
import Domain
import XCTest

struct EventsCommandingStub: EventsCommanding {
    func save(_: Event) {}
    func delete(_: Event) {}
}
