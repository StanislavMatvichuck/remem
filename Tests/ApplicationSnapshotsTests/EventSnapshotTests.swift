//
//  EventDetailsSnapshotTests.swift
//  ApplicationSnapshotsTests
//
//  Created by Stanislav Matvichuck on 24.11.2022.
//

@testable import Application
import Domain
import iOSSnapshotTestCase

class EventSnapshotsTest: FBSnapshotTestCase, EventDetailsViewControllerTesting {
    var viewModelFactory: Application.EventViewModelFactoring!
    var sut: EventViewController!
    var event: Event!
    
    override func setUp() {
        super.setUp()
        recordMode = false
        folderName = "Event"
        makeSutWithViewModelFactory()
        putInViewHierarchy(sut)
    }
    
    override func tearDown() {
        clearSutAndViewModelFactory()
        executeRunLoop()
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
    
    private func arrangeOneHappening() {
        addHappening()
        sendEventUpdatesToController()
    }
    
    private func addHappening() {
        event.addHappening(date: DayComponents.referenceValue.date)
    }
    
    private func sendEventUpdatesToController() {
        sut.viewModel = viewModelFactory.makeViewModel()
    }
}
