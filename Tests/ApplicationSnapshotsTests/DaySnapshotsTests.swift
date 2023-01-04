//
//  DayDetailsSnapshotsTests.swift
//  ApplicationSnapshotsTests
//
//  Created by Stanislav Matvichuck on 24.11.2022.
//

@testable import Application
import Domain
import iOSSnapshotTestCase

class DaySnapshotsTest:
    FBSnapshotTestCase,
    DayViewControllerTesting
{
    var sut: DayViewController!
    var event: Event!
    
    override func setUp() {
        super.setUp()
        recordMode = false
        folderName = "Day"
        
        let day = DayComponents.referenceValue
        let root = CompositionRoot(testingInMemoryMode: true)
        
        event = Event(name: "Event")
        sut = root.makeDayViewController(event, day)
        
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
    
    func test_singleHappening() {
        arrangeSingleHappening()
        
        FBSnapshotVerifyViewController(sut, perPixelTolerance: 0.05)
    }
    
    func test_singleHappeningDark() {
        configureDarkMode()
        arrangeSingleHappening()
        
        FBSnapshotVerifyViewController(sut, perPixelTolerance: 0.05)
    }
    
    private func arrangeSingleHappening() {
        addHappening(at: DayComponents.referenceValue.date)
        sendEventUpdatesToController()
    }
    
    private func configureDarkMode() {
        sut.view.window?.overrideUserInterfaceStyle = .dark
    }
}
