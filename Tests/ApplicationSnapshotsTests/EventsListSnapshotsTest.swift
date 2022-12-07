//
//  EventsList.swift
//  ApplicationSnapshotsTests
//
//  Created by Stanislav Matvichuck on 13.11.2022.
//

@testable import Application
import Domain
import iOSSnapshotTestCase
import IosUseCases

class EventsListSnapshotsTest: FBSnapshotTestCase {
    var sut: EventsListViewController!

    override func setUp() {
        super.setUp()
        recordMode = false
        folderName = "Events"
        let coordinator = ApplicationFactory().makeCoordinator()
        sut = EventsListViewController.make(coordinator: coordinator)
        putInViewHierarchy(sut)
    }

    override func tearDown() {
        executeRunLoop()
        sut = nil
        super.tearDown()
    }

    func test_empty() {
        FBSnapshotVerifyViewController(sut)
    }

    func test_emptyDark() {
        configureDarkMode()

        FBSnapshotVerifyViewController(sut)
    }

    func test_oneItem() {
        sut.submitEvent()

        FBSnapshotVerifyViewController(sut)
    }

    func test_oneItemDark() {
        sut.submitEvent()
        configureDarkMode()

        FBSnapshotVerifyViewController(sut)
    }

    func test_oneItem_swiped() {
        sut.arrangeSingleEventSwiped()

        FBSnapshotVerifyViewController(sut)
    }

    func test_oneItem_swipedDark() {
        sut.arrangeSingleEventSwiped()
        configureDarkMode()

        FBSnapshotVerifyViewController(sut)
    }

    /// Duplicates with EventInput tests
    func test_addButton_inputShown() {
        usesDrawViewHierarchyInRect = true

        let exp = XCTestExpectation(description: "background updated asynchronously")
        sut.viewRoot.input.animationCompletionHandler = { exp.fulfill() }
        sut.viewRoot.input.show(value: "SomeText")

        // simulating UIResponder notification dispatch
        DispatchQueue.main.async {
            self.sut.viewRoot.input.animateShowingKeyboard(
                notification: self.makeKeyboardNotificationFake()
            )
        }

        wait(for: [exp], timeout: 0.1)

        FBSnapshotVerifyViewController(sut, perPixelTolerance: 0.05)
    }

    private func configureDarkMode() {
        sut.view.window?.overrideUserInterfaceStyle = .dark
    }

    /// Duplicates with EventInput tests
    private func makeKeyboardNotificationFake() -> NSNotification {
        let keyboardRect = CGRect(
            x: 0, y: 0,
            width: UIScreen.main.bounds.width,
            height: 300
        )

        return NSNotification(
            name: UIResponder.keyboardWillShowNotification,
            object: nil,
            userInfo: [
                UIResponder.keyboardFrameEndUserInfoKey: NSValue(cgRect: keyboardRect),
                UIResponder.keyboardAnimationDurationUserInfoKey: Double(0.1),
                UIResponder.keyboardAnimationCurveUserInfoKey: Int(0),
            ]
        )
    }
}
