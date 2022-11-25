//
//  WeekSnapshotsTests.swift
//  ApplicationSnapshotsTests
//
//  Created by Stanislav Matvichuck on 24.11.2022.
//

@testable import Application
import Domain
import iOSSnapshotTestCase

class WeekSnapshotsTest: FBSnapshotTestCase {
    var sut: WeekController!
    
    override func setUp() {
        super.setUp()
        recordMode = false
        folderName = "Week"
        let coordinator = ApplicationFactory().makeCoordinator()
        let useCase = EventEditUseCasingFake()
        let event = Event(name: "Event")
        sut = WeekController(
            event: event,
            useCase: useCase,
            coordinator: coordinator
        )
        
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
}
