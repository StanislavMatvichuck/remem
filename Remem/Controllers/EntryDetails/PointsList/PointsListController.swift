//
//  PointsListController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.05.2022.
//

import CoreData
import UIKit

class PointsListController: UIViewController {
    // MARK: - Properties
    let viewRoot = PointsListView()

    var pointsListService: PointsListService!

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        viewRoot.table.dataSource = self
        pointsListService.fetch()
    }
}

// MARK: - UITableViewDataSource
extension PointsListController: UITableViewDataSource {
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
extension PointsListController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        viewRoot.table.beginUpdates()
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
            viewRoot.table.insertRows(at: [insertIndex], with: .automatic)
        case .delete:
            guard let deleteIndex = indexPath else { return }
            viewRoot.table.deleteRows(at: [deleteIndex], with: .automatic)
        case .move:
            guard let fromIndex = indexPath, let toIndex = newIndexPath
            else { return }
            viewRoot.table.moveRow(at: fromIndex, to: toIndex)
        case .update:
            guard let updateIndex = indexPath else { return }
            viewRoot.table.reloadRows(at: [updateIndex], with: .none)
        @unknown default:
            fatalError("Unhandled case")
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        viewRoot.table.endUpdates()
    }
}
