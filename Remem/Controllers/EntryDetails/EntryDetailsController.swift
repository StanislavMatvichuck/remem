//
//  ControllerList.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 25.01.2022.
//
import CoreData.NSFetchedResultsController
import UIKit

class EntryDetailsController: UIViewController {
    // MARK: I18n
    static let dayAverage = NSLocalizedString("label.stats.average.day", comment: "EntryDetailsScreen")
    static let weekAverage = NSLocalizedString("label.stats.average.week", comment: "EntryDetailsScreen")
    static let lastWeekTotal = NSLocalizedString("label.stats.weekLast.total", comment: "EntryDetailsScreen")
    static let thisWeekTotal = NSLocalizedString("label.stats.weekThis.total", comment: "EntryDetailsScreen")

    // MARK: - Properties
    var entry: Entry!
    var pointsListService: EntryPointsListService!
    var weekDistributionService: EntryWeekDistributionService!
    var clockService: ClockService!

    private var scrollHappened = false
    // MARK: - View lifecycle
    private let viewRoot = EntryDetailsView()
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        title = entry.name

        setupClocks()
        setupViewStats()
        setupDisplays()

        viewRoot.clockDay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleClockPress)))
        viewRoot.clockNight.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleClockPress)))
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setInitialScrolls()
        entry.markAsVisited()
    }

    private var isDayClockVisible = true
}

// MARK: - User input
extension EntryDetailsController {
    @objc func handleClockPress() {
        flipClock()
    }
}

// MARK: - Private
extension EntryDetailsController {
    private func setInitialScrolls() {
        guard !scrollHappened else { return }
        setInitialScrollPositionForDisplay()
        setInitialScrollPositionForStats()
        scrollHappened = true
    }

    private func setInitialScrollPositionForDisplay() {
        let lastCellIndex = IndexPath(row: weekDistributionService.daysAmount - 1, section: 0)
        viewRoot.viewWeekDisplay.scrollToItem(at: lastCellIndex, at: .right, animated: false)
    }

    private func setInitialScrollPositionForStats() {
        let point = CGPoint(x: 2 * .wScreen, y: 0)
        viewRoot.viewStatsDisplay.setContentOffset(point, animated: false)
    }

    private func setupClocks() {
        let stitches = clockService.fetch()
        viewRoot.clockDay.update(stitches: stitches.day)
        viewRoot.clockNight.update(stitches: stitches.night)
    }

    private func setupDisplays() {
        viewRoot.viewPointsDisplay.dataSource = self
        pointsListService.fetch()

        viewRoot.viewWeekDisplay.dataSource = self
        viewRoot.viewWeekDisplay.delegate = self
    }

    private func setupViewStats() {
        let viewDayAverage = ViewStatDisplay(value: entry.dayAverage as NSNumber, description: Self.dayAverage)
        let viewWeekAverage = ViewStatDisplay(value: entry.weekAverage as NSNumber, description: Self.weekAverage)
        let viewLastWeekTotal = ViewStatDisplay(value: entry.lastWeekTotal as NSNumber, description: Self.lastWeekTotal)
        let viewThisWeekTotal = ViewStatDisplay(value: entry.thisWeekTotal as NSNumber, description: Self.thisWeekTotal)

        viewRoot.viewStatsDisplay.contain(views:
            viewDayAverage,
            viewWeekAverage,
            viewThisWeekTotal,
            viewLastWeekTotal)
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

    private func flipClock() {
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
        let firstView = isDayClockVisible ? viewRoot.clockDay : viewRoot.clockNight
        let secondView = isDayClockVisible ? viewRoot.clockNight : viewRoot.clockDay

        UIView.transition(from: firstView, to: secondView, duration: 0.6, options: transitionOptions) { finished in
            guard finished else { return }
            self.isDayClockVisible.toggle()
        }
    }
}

// MARK: - UITableViewDataSource
extension EntryDetailsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pointsListService.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let pointCell = tableView.dequeueReusableCell(withIdentifier: PointTimeCell.reuseIdentifier) as? PointTimeCell,
            let point = pointsListService.point(at: indexPath)
        else { return UITableViewCell() }
        pointCell.update(time: point.time, day: point.timeSince)
        return pointCell
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension EntryDetailsController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        viewRoot.viewPointsDisplay.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?)
    {
        switch type {
        case .insert:
            guard let insertIndex = newIndexPath else { return }
            viewRoot.viewPointsDisplay.insertRows(at: [insertIndex], with: .automatic)
        case .delete:
            guard let deleteIndex = indexPath else { return }
            viewRoot.viewPointsDisplay.deleteRows(at: [deleteIndex], with: .automatic)
        case .move:
            guard let fromIndex = indexPath, let toIndex = newIndexPath
            else { return }
            viewRoot.viewPointsDisplay.moveRow(at: fromIndex, to: toIndex)
        case .update:
            guard let updateIndex = indexPath else { return }
            viewRoot.viewPointsDisplay.reloadRows(at: [updateIndex], with: .none)
        @unknown default:
            fatalError("Unhandled case")
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        viewRoot.viewPointsDisplay.endUpdates()
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
