//
//  DayDetailsViewSnapshots.swift
//  Application
//
//  Created by Stanislav Matvichuck on 08.01.2024.
//

@testable import Application
import Domain
import iOSSnapshotTestCase

final class DayDetailsViewSnapshots: FBSnapshotTestCase {
    override func setUp() {
        super.setUp()
        configureSnapshotsOptions()
        recordMode = true
    }

    func test_empty() {
        let container = ApplicationContainer(mode: .unitTest)
        let event = Event(name: "", dateCreated: DayIndex.referenceValue.date)
        let vm = DayDetailsContainer(EventDetailsContainer(container, event: event), startOfDay: DayIndex.referenceValue.date).makeDayDetailsViewModel()
        let sut = DayDetailsView()
        sut.viewModel = vm
        sut.happeningsCollection.delegate = self
        sut.frame = .screenSquare

        FBSnapshotVerifyView(sut)
    }

    func test_oneHappening_atStart() {
        let container = ApplicationContainer(mode: .unitTest)
        let event = Event(name: "", dateCreated: DayIndex.referenceValue.date)
        event.addHappening(date: DayIndex.referenceValue.date)
        event.addHappening(date: DayIndex.referenceValue.date.addingTimeInterval(120))
        event.addHappening(date: DayIndex.referenceValue.date)
        event.addHappening(date: DayIndex.referenceValue.date)
        event.addHappening(date: DayIndex.referenceValue.date)
        event.addHappening(date: DayIndex.referenceValue.date)
        event.addHappening(date: DayIndex.referenceValue.date)
        event.addHappening(date: DayIndex.referenceValue.date)
        event.addHappening(date: DayIndex.referenceValue.date)
        event.addHappening(date: DayIndex.referenceValue.date)
        let vm = DayDetailsContainer(EventDetailsContainer(container, event: event), startOfDay: DayIndex.referenceValue.date).makeDayDetailsViewModel()
        let sut = DayDetailsView()
        sut.viewModel = vm
        sut.happeningsCollection.delegate = self
        sut.frame = UIScreen.main.bounds

        FBSnapshotVerifyView(sut)
    }
}

extension DayDetailsViewSnapshots:
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 4
        return CGSize(width: width, height: width)
    }
}
