//
//  EventInputSnapshotsTests.swift
//  ApplicationSnapshotsTests
//
//  Created by Stanislav Matvichuck on 15.01.2023.
//

@testable import Application
import iOSSnapshotTestCase

final class EventInputSnapshotsTests: FBSnapshotTestCase {
    var sut: EventInput!
    var parent: UIView!
    
    override func setUp() {
        super.setUp()
        recordMode = false
        folderName = "EventInput"
        
        sut = EventInput()
        sut.backgroundColor = .orange
        
        parent = UIView(frame: UIScreen.main.bounds)
        parent.addAndConstrain(sut)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.addSubview(parent)
        window.isHidden = false
    }
    
    override func tearDown() {
        executeRunLoop()
        sut = nil
        super.tearDown()
    }
 
    func test_addedToSubView() {
        FBSnapshotVerifyView(parent)
    }
    
    func test_show() {
        usesDrawViewHierarchyInRect = true
        let exp = XCTestExpectation(description: "background updated asynchronously")
        sut.animationCompletionHandler = { exp.fulfill() }
        sut.show(value: "SomeText")
        
        // simulating UIResponder notification dispatch
        DispatchQueue.main.async {
            self.sut.animateShowingKeyboard(
                notification: self.makeKeyboardNotificationFake()
            )
        }
        
        wait(for: [exp], timeout: 0.1)
        
        FBSnapshotVerifyView(parent, perPixelTolerance: 0.05)
    }
    
    private func configureDarkMode() {
        sut.window?.overrideUserInterfaceStyle = .dark
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
