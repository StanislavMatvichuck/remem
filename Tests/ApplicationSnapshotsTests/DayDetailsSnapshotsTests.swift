//
//  DayDetailsSnapshotsTests.swift
//  ApplicationSnapshotsTests
//
//  Created by Stanislav Matvichuck on 24.11.2022.
//

@testable import Application
import Domain
import iOSSnapshotTestCase

class DayDetailsSnapshotsTest: FBSnapshotTestCase {
    var sut: DayDetailsViewController!
    
    override func setUp() {
        super.setUp()
        recordMode = false
        folderName = "DayDetails"
        let useCase = EventEditUseCasingFake()
        let event = Event(name: "Event")
        let date = Date(timeIntervalSinceReferenceDate: 0)
        
        sut = DayDetailsViewController(
            date: date,
            event: event,
            useCase: useCase
        )
        
        let navigation = ApplicationFactory.makeStyledNavigationController()
        navigation.pushViewController(sut, animated: false)
        
        putInViewHierarchy(navigation)
    }
    
    override func tearDown() {
        executeRunLoop()
        sut = nil
        super.tearDown()
    }
 
    func test_empty() {
        FBSnapshotVerifyViewController(sut.navigationController!)
    }
    
    func test_emptyDark() {
        configureDarkMode()
        FBSnapshotVerifyViewController(sut.navigationController!)
    }
    
    func test_singleHappening() {
        sut.event.addHappening(date: Date(timeIntervalSinceReferenceDate: 5 * 60))
        sut.update(event: sut.event)
        
        FBSnapshotVerifyViewController(sut.navigationController!, perPixelTolerance: 0.05)
    }
    
    func test_singleHappeningDark() {
        configureDarkMode()
        
        sut.event.addHappening(date: Date(timeIntervalSinceReferenceDate: 5 * 60))
        sut.update(event: sut.event)
        
        FBSnapshotVerifyViewController(sut.navigationController!, perPixelTolerance: 0.05)
    }
    
    private func configureDarkMode() {
        sut.navigationController!.view.window?.overrideUserInterfaceStyle = .dark
    }
}
