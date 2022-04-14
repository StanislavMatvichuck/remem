//
//  ControllerList.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 25.01.2022.
//
import CoreData.NSFetchedResultsController
import UIKit

class EntryDetailsController: UIViewController, EntryDetailsModelDelegate, UITableViewDelegate {
    //

    // MARK: - Public props

    //
    
    var model: EntryDetailsModelInterface!
    
    //
    
    // MARK: - Private properties
    
    //
    
    fileprivate let viewRoot = EntryDetailsView()
    
    //
    
    // MARK: - Initialization
    
    //
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    
    // MARK: - View lifecycle
    
    //
    
    override func loadView() { view = viewRoot }
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        title = model.name
        model.fetch()
        setupViewStats()
        
        viewRoot.viewPointsDisplay.dataSource = self
        viewRoot.viewPointsDisplay.delegate = self
        viewRoot.viewWeekDisplay.dataSource = self
        viewRoot.viewWeekDisplay.delegate = self
        viewRoot.viewStatsDisplay.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setInitialScrolls()
    }
    
    var scrollHappened = false
    
    private func setInitialScrolls() {
        guard !scrollHappened else { return }
        
        setInitialScrollPositionForDisplay()
        
        setInitialScrollPositionForStats()
        
        scrollHappened = true
    }
    
    private func setInitialScrollPositionForDisplay() {
        let lastCellIndex = IndexPath(row: model.dayCellsAmount - 1, section: 0)
        
        viewRoot.viewWeekDisplay.scrollToItem(at: lastCellIndex, at: .right, animated: false)
    }
    
    private func setInitialScrollPositionForStats() {
        let point = CGPoint(x: 2 * .wScreen, y: 0)
        
        viewRoot.viewStatsDisplay.setContentOffset(point, animated: false)
    }
    
    private func setupViewStats() {
        let viewDayAverage = ViewStatDisplay(value: model.dayAverage, description: "Day average")
        let viewWeekAverage = ViewStatDisplay(value: model.weekAverage, description: "Week average")
        let viewLastWeekTotal = ViewStatDisplay(value: model.lastWeekTotal, description: "Last week total")
        let viewThisWeekTotal = ViewStatDisplay(value: model.thisWeekTotal, description: "This week total")
        
        viewRoot.viewStatsDisplay.contain(views:
            viewLastWeekTotal,
            viewThisWeekTotal,
            viewDayAverage,
            viewWeekAverage)
    }
    
    // TODO: create neat mechanism to observe scrolling
    var pointsDisplayScrollNotificationSent = false
    var statsDisplayScrollNotificationSent = false
    var weekDisplayScrollNotificationSent = false
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == viewRoot.viewPointsDisplay {
            if !pointsDisplayScrollNotificationSent, scrollView.contentOffset.y > scrollView.frame.height {
                NotificationCenter.default.post(name: .PointsDisplayDidScroll,
                                                object: viewRoot.viewStatsDisplay)
                pointsDisplayScrollNotificationSent = true
            }
        } else if scrollView == viewRoot.viewStatsDisplay {
            if !statsDisplayScrollNotificationSent, scrollView.contentOffset.x <= 0 {
                NotificationCenter.default.post(name: .StatsDisplayDidScroll,
                                                object: createViewWeekDisplayDescriptor())
                statsDisplayScrollNotificationSent = true
            }
        } else if scrollView == viewRoot.viewWeekDisplay {
            let scrollOffsetAcceptance = scrollView.contentSize.width - 2 * scrollView.frame.width
            if !weekDisplayScrollNotificationSent, scrollView.contentOffset.x <= scrollOffsetAcceptance {
                NotificationCenter.default.post(name: .WeekDisplayDidScroll, object: nil)
                weekDisplayScrollNotificationSent = true
            }
        }
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

//

// MARK: - UITableViewDataSource

//

extension EntryDetailsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataAmount = model.pointsAmount
        
        if dataAmount == 0 {
            viewRoot.showEmptyState()
        } else {
            viewRoot.hideEmptyState()
        }
        
        return dataAmount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let row = tableView.dequeueReusableCell(withIdentifier: PointTimeCell.reuseIdentifier) as? PointTimeCell,
            let dataRow = model.point(at: indexPath)
        else { return UITableViewCell() }

        row.update(time: dataRow.time, day: dataRow.timeSince)
        
        return row
    }
}

//

// MARK: - NSFetchedResultsControllerDelegate

//

extension EntryDetailsController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        viewRoot.viewPointsDisplay.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        viewRoot.viewPointsDisplay.endUpdates()
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
}

//

// MARK: - UICollectionViewDelegateFlowLayout, UICollectionViewDataSource

//

extension EntryDetailsController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: .wScreen / 7, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.dayCellsAmount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayOfTheWeekCell.reuseIdentifier, for: indexPath) as! DayOfTheWeekCell
        
        let numberInMonth = model.dayInMonth(at: indexPath)
        
        switch model.cellKind(at: indexPath) {
        case .past:
            cell.update(amount: nil)
        case .created:
            cell.update(amount: nil)
        case .data:
            cell.update(amount: model.cellAmount(at: indexPath))
            
            let isToday = model.isTodayCell(at: indexPath)
                        
            cell.update(day: "\(numberInMonth)", isToday: isToday)
            
        case .today:
            cell.update(day: "\(numberInMonth)")
            cell.update(amount: nil)
        case .future:
            cell.update(day: "\(numberInMonth)")
            cell.update(amount: nil)
        }
        
        return cell
    }
}

extension EntryDetailsController: OnboardingControllerDelegate {
    func startOnboarding() {
        let onboarding = EntryDetailsOnboardingController(withStep: .highlightPointsDisplay)
        onboarding.modalPresentationStyle = .overCurrentContext
        onboarding.modalTransitionStyle = .crossDissolve
        onboarding.viewToHighlight = viewRoot.viewPointsDisplay
        onboarding.isModalInPresentation = true
        present(onboarding, animated: true) {
            onboarding.start()
        }
    }
}

//

// MARK: - Notifications

//

extension Notification.Name {
    static let PointsDisplayDidScroll = Notification.Name(rawValue: "PointsDisplayDidScroll")
    static let StatsDisplayDidScroll = Notification.Name(rawValue: "StatsDisplayDidScroll")
    static let WeekDisplayDidScroll = Notification.Name(rawValue: "WeekDisplayDidScroll")
}
