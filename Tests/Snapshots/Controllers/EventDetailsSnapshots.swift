//
//  EventDetailsSnapshotTests.swift
//  ApplicationSnapshotsTests
//
//  Created by Stanislav Matvichuck on 24.11.2022.
//

@testable import Application
import Domain
import iOSSnapshotTestCase

final class EventDetailsSnapshots: FBSnapshotTestCase, TestingViewController {
    var sut: EventDetailsController!
    var event: Event!
    var commander: EventsWriting!
    
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
    
    func test_singleHappening() {
        arrangeOneHappening()
        
        FBSnapshotVerifyViewController(sut, perPixelTolerance: 0.05)
    }
    
    func test_empty_dark() { executeWithDarkMode(test_empty) }
    func test_singleHappening_dark() { executeWithDarkMode(test_singleHappening) }
    
    private func executeWithDarkMode(_ testCase: () -> Void) {
        sut.view.window?.overrideUserInterfaceStyle = .dark
        executeRunLoop()
        if let folderName { self.folderName = folderName.replacingOccurrences(of: "light", with: "dark") }
        testCase()
    }
    
    private func arrangeOneHappening() {
        addHappening()
        sendEventUpdatesToController()
    }
    
    private func addHappening() {
        event.addHappening(date: DayIndex.referenceValue.date)
    }
}
