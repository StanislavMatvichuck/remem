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
        sut.requestPendingRequests()
        waitForExpectations(timeout: 1)
    }

    // TODO: this test sometimes fails
//    func testNotificationCreationAndRemoval() {
//        // testGetNotifications
//        sutDelegate.expectPendingNotificationsCallback()
//        sut.requestPendingNotifications()
//        waitForExpectations(timeout: 1)
//
//        XCTAssertNotNil(sutDelegate.pendingNotifications)
//
//        /// get `arrangedNotificationsAmount` before addition and deletion to isolate this test
//        let arrangedNotificationsAmount = sutDelegate.pendingNotifications!.count
//
//        sutDelegate.expectNotificationAddedWithoutError()
//        let addedNotification = sut.addNotification(
//            text: "Remem notification",
//            hours: currentComponents.hour!,
//            minutes: currentComponents.minute!,
//            seconds: currentComponents.second! + 10,
//            repeats: false
//        )
//        waitForExpectations(timeout: 1)
//
//        // testGetNotifications
//        sutDelegate.expectPendingNotificationsCallback()
//        sut.requestPendingNotifications()
//        waitForExpectations(timeout: 1)
//
//        XCTAssertEqual(
//            sutDelegate.pendingNotifications!.count,
//            arrangedNotificationsAmount + 1
//        )
//
//        // Act: remove created notification
//        sut.removePendingNotifications(addedNotification.identifier)
//
//        // Assert added notification removal
//
//        // testGetNotifications
//        sutDelegate.expectPendingNotificationsCallback()
//        sut.requestPendingNotifications()
//        waitForExpectations(timeout: 1)
//
//        XCTAssertEqual(
//            sutDelegate.pendingNotifications!.count,
//            arrangedNotificationsAmount
//        )
//    }

    func testNotificationArrived() {
        sutDelegate.expectNotificationAddedWithoutError()
        let createdNotification = sut.addReminderNotification(
            text: "Remem notification",
            hours: currentComponents.hour!,
            minutes: currentComponents.minute!,
            seconds: currentComponents.second! + 1,
            repeats: false
        )
        waitForExpectations(timeout: 1)

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

    func expectNotificationAddedWithoutError() {
        expectation = testCase.expectation(description: "Notification registered by the system without error")
    }

    func expectNotificationArrival() {
        expectation = testCase.expectation(description: "Wait for notification to arrive")
        UNUserNotificationCenter.current().delegate = self
    }
}

// MARK: - LocalNotificationsServiceDelegate
extension LocalNotificationsServiceDelegateMock: LocalNotificationsServiceDelegate {
    func localNotificationService(authorized: Bool) {
        expectation?.fulfill()
        expectation = nil
    }

    func localNotificationService(pendingRequests: [UNNotificationRequest]) {
        pendingNotifications = pendingRequests
        expectation?.fulfill()
        expectation = nil
    }

    func localNotificationServiceAddingRequestFinishedWith(error: Error?) {
        expectation?.fulfill()
        expectation = nil
    }
}

// MARK: Notifications arrival testing
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
