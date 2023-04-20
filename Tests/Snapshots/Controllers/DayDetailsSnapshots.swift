//
//  DayDetailsSnapshotsTests.swift
//  ApplicationSnapshotsTests
//
//  Created by Stanislav Matvichuck on 24.11.2022.
//

@testable import Application
import Domain
import iOSSnapshotTestCase

final class DayDetailsSnapshots:
    FBSnapshotTestCase,
    TestingViewController
{
    var sut: DayDetailsViewController!
    var event: Event!
    var commander: EventsCommanding!
    
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
        addHappening(at: DayIndex.referenceValue.date)
        sendEventUpdatesToController()
    }
    
    private func configureDarkMode() {
        sut.view.window?.overrideUserInterfaceStyle = .dark
        if let folderName { self.folderName = folderName.replacingOccurrences(of: "light", with: "dark") }
    }
}
