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
    DayDetailsViewControllerTesting
{
    var sut: DayDetailsViewController!
    var event: Event!
    var viewModelFactory: DayViewModelFactoring!
    
    override func setUp() {
        super.setUp()
        configureCommonOptions()
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
