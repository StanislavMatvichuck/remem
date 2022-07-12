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
    var entry: Entry!

    private var domain = DomainFacade()

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        viewRoot.table.dataSource = self
    }
}

// MARK: - UITableViewDataSource
extension PointsListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return domain.getPoints(for: entry).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let pointCell = tableView.dequeueReusableCell(withIdentifier: PointTimeCell.reuseIdentifier) as? PointTimeCell
        else { return UITableViewCell() }

        let point = domain.getPoints(for: entry)[indexPath.row]
        pointCell.update(time: point.time, day: point.timeSince)
        return pointCell
    }
}
