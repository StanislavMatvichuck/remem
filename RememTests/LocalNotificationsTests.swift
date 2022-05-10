//
//  LocalNotificationsTests.swift
//  RememTests
//
//  Created by Stanislav Matvichuck on 20.04.2022.
//

@testable import Remem
import XCTest

class LocalNotificationsServiceTests: XCTestCase {
    var sut: LocalNotificationsService!
    var sutDelegate: LocalNotificationsServiceDelegateMock!

    private var currentComponents: DateComponents {
        Calendar.current.dateComponents(
            [.hour, .minute, .second],
            from: Date.now
        )
    }

    override func setUp() {
        super.setUp()

        sut = LocalNotificationsService()
        sutDelegate = LocalNotificationsServiceDelegateMock(self)
        sut.delegate = sutDelegate
    }

    override func tearDown() {
        super.tearDown()

        sut = nil
        sutDelegate = nil
    }

    func testInit() {
        XCTAssertNotNil(sut)
        XCTAssertNotNil(sutDelegate)
    }

    func testRequestAuthorization_CallbackArrived() {
        sutDelegate.expectAuthorizationCallback()
        sut.requestAuthorization()
        waitForExpectations(timeout: 10)
    }

    func testGetNotifications() {
        sutDelegate.expectPendingNotificationsCallback()
        sut.requestPendingNotifications()
        waitForExpectations(timeout: 1)
    }

    // TODO: this test sometimes fails
    func testNotificationCreationAndRemoval() {
        // testGetNotifications
        sutDelegate.expectPendingNotificationsCallback()
        sut.requestPendingNotifications()
        waitForExpectations(timeout: 1)
        
        XCTAssertNotNil(sutDelegate.pendingNotifications)

        /// get `arrangedNotificationsAmount` before addition and deletion to isolate this test
        let arrangedNotificationsAmount = sutDelegate.pendingNotifications!.count

        // Act: create a notification
        let addedNotification = sut.addNotification(
            text: "Remem notification",
            hours: currentComponents.hour!,
            minutes: currentComponents.minute!,
            seconds: currentComponents.second! + 10,
            repeats: false
        )

        // Assert added notification
        // TODO: fix this failing
        
        // testGetNotifications
        sutDelegate.expectPendingNotificationsCallback()
        sut.requestPendingNotifications()
        waitForExpectations(timeout: 1)
        
        XCTAssertEqual(
            sutDelegate.pendingNotifications!.count,
            arrangedNotificationsAmount + 1
        )

        // Act: remove created notification
        sut.removePendingNotifications(addedNotification.identifier)

        // Assert added notification removal
        
        // testGetNotifications
        sutDelegate.expectPendingNotificationsCallback()
        sut.requestPendingNotifications()
        waitForExpectations(timeout: 1)
        
        XCTAssertEqual(
            sutDelegate.pendingNotifications!.count,
            arrangedNotificationsAmount
        )
    }

    func testNotificationArrived() {
        let createdNotification = sut.addNotification(
            text: "Remem notification",
            hours: currentComponents.hour!,
            minutes: currentComponents.minute!,
            seconds: currentComponents.second! + 1,
            repeats: false
        )

        sutDelegate.expectNotificationArrival()

        waitForExpectations(timeout: 2)

        XCTAssertNotNil(sutDelegate.arrivedNotification)
        XCTAssertEqual(
            sutDelegate.arrivedNotification?.request.identifier,
            createdNotification.identifier
        )
    }
}

// MARK: - SUT delegate mock
class LocalNotificationsServiceDelegateMock: NSObject {
    var pendingNotifications: [UNNotificationRequest]?
    var arrivedNotification: UNNotification?
    var authorized: Bool?

    private var testCase: XCTestCase
    private var expectation: XCTestExpectation?

    init(_ testCase: XCTestCase) { self.testCase = testCase }
}

// MARK: - Expectations
extension LocalNotificationsServiceDelegateMock {
    func expectAuthorizationCallback() {
        expectation = testCase.expectation(description: "Waiting for local authorization")
    }

    func expectPendingNotificationsCallback() {
        expectation = testCase.expectation(description: "Waiting for pending notifications")
    }

    func expectNotificationArrival() {
        expectation = testCase.expectation(description: "Wait for notification to arrive")
        UNUserNotificationCenter.current().delegate = self
    }
}

// MARK: - LocalNotificationsServiceDelegate
extension LocalNotificationsServiceDelegateMock: LocalNotificationsServiceDelegate {
    func authorizationRequest(result: Bool) {
        authorized = result
        expectation?.fulfill()
        expectation = nil
    }

    func notificationsRequest(result: [UNNotificationRequest]) {
        pendingNotifications = result
        expectation?.fulfill()
        expectation = nil
    }
}

// MARK: - Notifications arrival testing
extension LocalNotificationsServiceDelegateMock: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        arrivedNotification = notification
        expectation?.fulfill()
        expectation = nil
        UNUserNotificationCenter.current().delegate = nil
    }
}
