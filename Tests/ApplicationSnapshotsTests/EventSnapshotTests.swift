//
//  EventDetailsSnapshotTests.swift
//  ApplicationSnapshotsTests
//
//  Created by Stanislav Matvichuck on 24.11.2022.
//

@testable import Application
import Domain
import iOSSnapshotTestCase
import IosUseCases

class EventSnapshotsTest: FBSnapshotTestCase {
    var sut: EventViewController!
    var useCase: EventEditUseCasing!
    var event: Event!
    
    override func setUp() {
        super.setUp()
        recordMode = false
        folderName = "Event"
        let useCase = EventEditUseCasingFake()
        let event = Event(name: "Event", dateCreated: DayComponents.referenceValue.date)
        let coordinator = CompositionRoot().makeCoordinator()
        let weekController = WeekViewController(
            today: DayComponents.referenceValue,
            event: event,
            useCase: useCase,
            coordinator: coordinator
        )
        
        let clockController = ClockViewController(
            event: event,
            useCase: useCase,
            sorter: DefaultClockSorter(size: 144)
        )
        
        self.useCase = useCase
        self.event = event
        sut = EventViewController(
            event: event,
            useCase: useCase,
            controllers: [
                weekController,
                clockController,
            ]
        )
        
        let navigation = CompositionRoot.makeStyledNavigationController()
        navigation.pushViewController(sut, animated: false)
        navigation.navigationBar.prefersLargeTitles = true
        
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
        sut.event.addHappening(date: .now)
        sut.update(event: sut.event)
        
        FBSnapshotVerifyViewController(sut.navigationController!, perPixelTolerance: 0.05)
    }
    
    func test_singleHappeningDark() {
        configureDarkMode()
        
        useCase.addHappening(to: event, date: .now)
        
        FBSnapshotVerifyViewController(sut.navigationController!, perPixelTolerance: 0.05)
    }
    
    private func configureDarkMode() {
        sut.navigationController!.view.window?.overrideUserInterfaceStyle = .dark
    }
}
