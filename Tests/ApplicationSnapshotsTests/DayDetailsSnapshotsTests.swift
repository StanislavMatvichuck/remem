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
        recordMode = true
        
        let useCase = EventEditUseCasingFake()
        let event = Event(name: "Event")
        let date = Date.now
        
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
    
    func test_empty_dark() {
        configureDarkMode()
        FBSnapshotVerifyViewController(sut.navigationController!)
    }
    
    func test_singleHappening() {
        sut.event.addHappening(date: .now)
        sut.update(event: sut.event)
        
        FBSnapshotVerifyViewController(sut.navigationController!)
    }
    
    func test_singleHappening_dark() {
        configureDarkMode()
        
        sut.event.addHappening(date: .now)
        sut.update(event: sut.event)
        
        FBSnapshotVerifyViewController(sut.navigationController!)
    }
    
    private func configureDarkMode() {
        sut.navigationController!.view.window?.overrideUserInterfaceStyle = .dark
    }
}
