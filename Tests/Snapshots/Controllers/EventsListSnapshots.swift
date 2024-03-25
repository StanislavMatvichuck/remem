//
//  EventsList.swift
//  ApplicationSnapshotsTests
//
//  Created by Stanislav Matvichuck on 13.11.2022.
//

@testable import Application
import Domain
import iOSSnapshotTestCase

final class EventsListSnapshots:
    FBSnapshotTestCase,
    TestingViewController
{
    var sut: EventsListController!
    var event: Event! // is not needed here but required by a protocol

    override func setUp() {
        super.setUp()
        configureSnapshotsOptions()
        make()
        putInViewHierarchy(sut)
    }

    override func tearDown() {
        clear()
        super.tearDown()
    }

    func test_empty() {
        FBSnapshotVerifyViewController(sut)
    }

    func test_empty_dark() { executeWithDarkMode(test_empty) }

    func test_oneItem() {
        submitEvent()

        FBSnapshotVerifyViewController(sut)
    }

    func test_oneItem_dark() { executeWithDarkMode(test_oneItem) }

    func test_oneItem_swiped() {
        arrangeSingleEventSwiped()

        FBSnapshotVerifyViewController(sut)
    }

    func test_oneItem_swiped_dark() { executeWithDarkMode(test_oneItem_swiped) }

    func test_oneItem_visited() {
        makeWithVisitedEvent()

        FBSnapshotVerifyViewController(sut)
    }

    /// Cannot use executeWithDarkMode because sut is recreated
    func test_oneItem_visited_dark() {
        makeWithVisitedEvent()
        putInViewHierarchy(sut)
        sut.view.overrideUserInterfaceStyle = .dark
        if let folderName { self.folderName = folderName.replacingOccurrences(of: "light", with: "dark") }
        executeRunLoop()
        FBSnapshotVerifyViewController(sut)
    }

    func test_manyItems() {
        makeWithManyEvents()
        FBSnapshotVerifyViewController(sut)
    }

    func test_manyItems_dark() { executeWithDarkMode(test_manyItems) }

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

    func test_addButton_inputShown_dark() { executeWithDarkMode(test_addButton_inputShown) }

    private func executeWithDarkMode(_ testCase: () -> Void) {
        sut.view.overrideUserInterfaceStyle = .dark
        executeRunLoop()
        if let folderName { self.folderName = folderName.replacingOccurrences(of: "light", with: "dark") }
        testCase()
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
