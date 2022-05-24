//
//  ControllerList.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 25.01.2022.
//
import CoreData.NSFetchedResultsController
import UIKit

class EntryDetailsController: UIViewController {
    // MARK: - Properties
    var entry: Entry!

    var weekDistributionService: EntryWeekDistributionService!
    let clockController = ClockController()
    let pointsListController = PointsListController()
    let beltController = BeltController()
    private var scrollHappened = false

    // MARK: - View lifecycle
    private let viewRoot = EntryDetailsView()
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        title = entry.name

        setupClock()
        setupPointsList()
        setupBelt()

        setupDisplays()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setInitialScrolls()
        entry.markAsVisited()
    }
}

// MARK: - Private
extension EntryDetailsController {
    private func setInitialScrolls() {
        guard !scrollHappened else { return }
        setInitialScrollPositionForDisplay()
        scrollHappened = true
    }

    private func setInitialScrollPositionForDisplay() {
        let lastCellIndex = IndexPath(row: weekDistributionService.daysAmount - 1, section: 0)
        viewRoot.viewWeekDisplay.scrollToItem(at: lastCellIndex, at: .right, animated: false)
    }

    private func setupDisplays() {
        viewRoot.viewWeekDisplay.dataSource = self
        viewRoot.viewWeekDisplay.delegate = self
    }

    private func setupClock() {
        addChild(clockController)
        viewRoot.clockContainer.addAndConstrain(clockController.view)
        clockController.didMove(toParent: self)
    }

    private func setupBelt() {
        beltController.entry = entry
        addChild(beltController)
        viewRoot.beltContainer.addAndConstrain(beltController.view)
        beltController.didMove(toParent: self)
    }

    private func setupPointsList() {
        addChild(pointsListController)
        viewRoot.pointsListContainer.addAndConstrain(pointsListController.view, constant: .sm)
        pointsListController.didMove(toParent: self)
    }

    private func createViewWeekDisplayDescriptor() -> UIView {
        let source = viewRoot.viewWeekDisplay.frame
        let weeksView = viewRoot.viewWeekdaysLine.frame
        let view = UIView(frame: CGRect(x: source.minX,
                                        y: source.minY,
                                        width: source.width,
                                        height: source.height + weeksView.height))
        return view
    }
}

// MARK: - UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
extension EntryDetailsController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: .wScreen / 7, height: collectionView.bounds.height)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weekDistributionService.daysAmount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DayOfTheWeekCell.reuseIdentifier,
            for: indexPath) as! DayOfTheWeekCell

        let numberInMonth = weekDistributionService.dayOfMonth(for: indexPath)
        let isToday = indexPath.row == weekDistributionService.todayIndexRow

        cell.update(day: "\(numberInMonth!)", isToday: isToday)
        cell.update(amount: weekDistributionService.pointsAmount(for: indexPath))
        return cell
    }
}
