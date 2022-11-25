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

class EventDetailsSnapshotsTest: FBSnapshotTestCase {
    var sut: EventDetailsController!
    var useCase: EventEditUseCasing!
    var event: Event!
    
    override func setUp() {
        super.setUp()
        recordMode = false
        folderName = "EventDetails"
        let useCase = EventEditUseCasingFake()
        let event = Event(name: "Event")
        let coordinator = ApplicationFactory().makeCoordinator()
        let weekController = WeekController(
            event: event,
            useCase: useCase,
            coordinator: coordinator
        )
        let clockController = ClockController(event: event, useCase: useCase)
        
        self.useCase = useCase
        self.event = event
        sut = EventDetailsController(
            event: event,
            useCase: useCase,
            controllers: [
                weekController,
                clockController,
            ]
        )
        
        let navigation = ApplicationFactory.makeStyledNavigationController()
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
        
        sut.view.bounds = UIScreen.main.bounds
        sut.view.layoutIfNeeded()
        let spacing = sut.viewRoot.scroll.viewContent.arrangedSubviews[0]
        let weekView = sut.viewRoot.scroll.viewContent.arrangedSubviews[1]
        let heightToScrollUp =
            spacing.bounds.height +
            weekView.bounds.height
        let point = CGPoint(x: 0, y: heightToScrollUp)
        sut.viewRoot.scroll.setContentOffset(point, animated: false)
        
        FBSnapshotVerifyViewController(sut.navigationController!, perPixelTolerance: 0.05)
    }
    
    private func configureDarkMode() {
        sut.navigationController!.view.window?.overrideUserInterfaceStyle = .dark
    }
}
