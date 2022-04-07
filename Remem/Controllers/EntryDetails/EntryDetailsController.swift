//
//  ControllerList.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 25.01.2022.
//
import CoreData.NSFetchedResultsController
import UIKit

class EntryDetailsController: UIViewController, EntryDetailsModelDelegate {
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
        
        viewRoot.viewTable.dataSource = self
        
        viewRoot.viewDisplay.dataSource = self
        viewRoot.viewDisplay.delegate = self
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
        
        viewRoot.viewDisplay.scrollToItem(at: lastCellIndex, at: .right, animated: false)
    }
    
    private func setInitialScrollPositionForStats() {
        let point = CGPoint(x: 2 * .wScreen, y: 0)
        
        viewRoot.viewStats.setContentOffset(point, animated: false)
    }
    
    private func setupViewStats() {
        let viewDayAverage = ViewStatDisplay(value: model.dayAverage, description: "Day average")
        let viewWeekAverage = ViewStatDisplay(value: model.weekAverage, description: "Week average")
        let viewLastWeekTotal = ViewStatDisplay(value: model.lastWeekTotal, description: "Last week total")
        let viewThisWeekTotal = ViewStatDisplay(value: model.thisWeekTotal, description: "This week total")
        
        let viewPlaceholder = UIView(frame: .zero)
        viewPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        
        viewRoot.viewStats.contain(views:
            viewLastWeekTotal,
            viewThisWeekTotal,
            viewDayAverage,
            viewWeekAverage,
            viewPlaceholder)
        
        NSLayoutConstraint.activate([
            viewPlaceholder.widthAnchor.constraint(equalToConstant: 1),
            viewPlaceholder.heightAnchor.constraint(equalTo: viewThisWeekTotal.heightAnchor),
        ])
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
        viewRoot.viewTable.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        viewRoot.viewTable.endUpdates()
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
            viewRoot.viewTable.insertRows(at: [insertIndex], with: .automatic)
        case .delete:
            guard let deleteIndex = indexPath else { return }
            viewRoot.viewTable.deleteRows(at: [deleteIndex], with: .automatic)
        case .move:
            guard let fromIndex = indexPath, let toIndex = newIndexPath
            else { return }
            viewRoot.viewTable.moveRow(at: fromIndex, to: toIndex)
        case .update:
            guard let updateIndex = indexPath else { return }
            viewRoot.viewTable.reloadRows(at: [updateIndex], with: .none)
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
        let onboarding = EntryDetailsOnboardingController(withStep: .highlightViewList)
        onboarding.modalPresentationStyle = .overCurrentContext
        onboarding.modalTransitionStyle = .crossDissolve
        onboarding.viewToHighlight = viewRoot.viewTable
        onboarding.isModalInPresentation = true
        present(onboarding, animated: true) {
            onboarding.start()
        }
    }
}
