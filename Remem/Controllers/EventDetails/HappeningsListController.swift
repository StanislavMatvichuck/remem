//
//  HappeningsListController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.05.2022.
//

import CoreData
import UIKit

class HappeningsListController: UIViewController {
    // MARK: - Properties
    let viewRoot = HappeningsListView()
    var event: Event!

    private var domain = DomainFacade()

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        viewRoot.table.dataSource = self
    }
}

// MARK: - UITableViewDataSource
extension HappeningsListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return domain.getHappenings(for: event).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let pointCell = tableView.dequeueReusableCell(withIdentifier: HappeningCell.reuseIdentifier) as? HappeningCell
        else { return UITableViewCell() }

        let point = domain.getHappenings(for: event)[indexPath.row]
        pointCell.update(time: point.time, day: point.timeSince)
        return pointCell
    }
}
