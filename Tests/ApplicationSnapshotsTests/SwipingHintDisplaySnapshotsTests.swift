//
//  SwipingHintDisplaySnapshotsTests.swift
//  ApplicationSnapshotsTests
//
//  Created by Stanislav Matvichuck on 11.01.2023.
//

@testable import Application
import iOSSnapshotTestCase

class SwipingHintDisplaySnapshotsTest: FBSnapshotTestCase {
    var sut: UsingSwipingHintDisplaying!
    
    override func setUp() {
        super.setUp()
        recordMode = false
        folderName = "SwipingHintDisplay"
        
        final class ParentView: UIView, UsingSwipingHintDisplaying {}
        
        sut = ParentView(frame: CGRect(
            x: 0, y: 0,
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.width / 3
        ))
        
        let window = UIWindow()
        window.addSubview(sut)
        
        sut.backgroundColor = .orange
        sut.addSwipingHint()
        sut.layoutIfNeeded()
    }
    
    override func tearDown() {
        executeRunLoop()
        sut = nil
        super.tearDown()
    }
 
    func test() {
        FBSnapshotVerifyView(sut)
    }
    
    func testDark() {
        configureDarkMode()
        FBSnapshotVerifyView(sut)
    }
    
    func test_startAnimation_animationCompletes() {
        sut.swipingHint?.startAnimation()

        FBSnapshotVerifyView(sut)
    }
    
    func test_startAnimation_reversesAfterCompletion() {
        let expectation = XCTestExpectation(description: "animation completes")
        sut.swipingHint?.animationCompletionHandler = {
            expectation.fulfill()
        }
        
        sut.swipingHint?.startAnimation()
        
        wait(for: [expectation], timeout: 0.1)
        FBSnapshotVerifyView(sut)
    }
    
    func test_removeSwipingHint() {
        sut.removeSwipingHint()
        
        FBSnapshotVerifyView(sut)
    }
    
    private func configureDarkMode() {
        sut.window?.overrideUserInterfaceStyle = .dark
    }
}
