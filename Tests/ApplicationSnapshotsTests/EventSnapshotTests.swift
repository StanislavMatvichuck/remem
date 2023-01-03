//
//  EventDetailsSnapshotTests.swift
//  ApplicationSnapshotsTests
//
//  Created by Stanislav Matvichuck on 24.11.2022.
//

@testable import Application
import Domain
import iOSSnapshotTestCase

class EventSnapshotsTest: FBSnapshotTestCase {
    var sut: EventViewController!
    var event: Event!
    
    override func setUp() {
        super.setUp()
        recordMode = true
        folderName = "Event"
        
        let day = DayComponents.referenceValue
        let root = CompositionRoot(testingInMemoryMode: true)
        
        event = Event(name: "Event", dateCreated: day.date)
        sut = root.makeEventViewController(event, day)

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
        arrangeOneHappening()
        
        FBSnapshotVerifyViewController(sut, perPixelTolerance: 0.05)
    }
    
    func test_singleHappeningDark() {
        configureDarkMode()
        arrangeOneHappening()
        
        FBSnapshotVerifyViewController(sut, perPixelTolerance: 0.05)
    }
    
    private func arrangeOneHappening() {
        addHappening()
        sendEventUpdatesToController()
    }
    
    private func addHappening() {
        event.addHappening(date: DayComponents.referenceValue.date)
    }
    
    private func sendEventUpdatesToController() {
        sut.viewModel = sut.viewModel.copy(newEvent: event)
    }
    
    private func configureDarkMode() {
        sut.view.window?.overrideUserInterfaceStyle = .dark
    }
}
