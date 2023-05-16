//
//  EventInputSnapshotsTests.swift
//  ApplicationSnapshotsTests
//
//  Created by Stanislav Matvichuck on 15.01.2023.
//

@testable import Application
import iOSSnapshotTestCase

final class EventInputSnapshots: FBSnapshotTestCase {
    var sut: EventInputView!
    var parent: UIView!
    
    override func setUp() {
        super.setUp()
        configureSnapshotsOptions()
        
        sut = EventInputView()
        
        parent = UIView(frame: UIScreen.main.bounds)
        parent.backgroundColor = .bg
        
        /// adds sublayer to make blur effect visible
        let layer = CALayer()
        layer.frame = CGRect(x: 150, y: 150, width: 150, height: 150)
        layer.backgroundColor = UIColor.purple.cgColor
        parent.layer.addSublayer(layer)
        
        parent.addAndConstrain(sut)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.addSubview(parent)
        window.makeKeyAndVisible()
    }
    
    override func tearDown() {
        executeRunLoop()
        sut = nil
        parent = nil
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
        
        wait(for: [exp], timeout: 0.15)
        
        FBSnapshotVerifyView(parent, perPixelTolerance: 0.05)
    }
    
    func test_show_dark() {
        executeWithDarkMode(test_show)
    }
    
    private func executeWithDarkMode(_ testCase: () -> Void) {
        parent.overrideUserInterfaceStyle = .dark
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
