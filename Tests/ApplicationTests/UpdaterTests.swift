//
//  UpdaterTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 22.02.2023.
//

@testable import Application
import Domain
import XCTest

final class UpdaterTests: XCTestCase {
    func test_decoratesEventsCommanding() throws {
        XCTAssertTrue(Updater<ReceiverStub, FactoryStub>(EventsCommandingStub()) is EventsCommanding)
    }

    func test_save_updatesReceiver() {
        let (sut, receiver, event) = arrange()

        sut.save(event)

        receiver.assertCalled(count: 1)
    }

    func test_delete_updatesReceiver() {
        let (sut, receiver, event) = arrange()

        sut.delete(event)

        receiver.assertCalled(count: 1)
    }

    private func arrange() -> (sut: Updater<ReceiverMock, FactoryStub>,
                               receiver: ReceiverMock,
                               event: Event)
    {
        let commander = EventsCommandingStub()
        let sut = Updater<ReceiverMock, FactoryStub>(commander)
        let receiver = ReceiverMock()
        let event = Event(name: "Event")
        sut.delegate = receiver
        sut.factory = FactoryStub()

        return (sut, receiver, event)
    }
}
