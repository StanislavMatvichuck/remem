//
//  CountableEventHappeningDescriptionsListController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.05.2022.
//

import CoreData
import UIKit

class CountableEventHappeningDescriptionsListController: UIViewController {
    // MARK: - Properties
    let viewRoot = CountableEventHappeningDescriptionsListView()
    var countableEvent: CountableEvent!

    private var domain = DomainFacade()

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        viewRoot.table.dataSource = self
    }
}

// MARK: - UITableViewDataSource
extension CountableEventHappeningDescriptionsListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return domain.getCountableEventHappeningDescriptions(for: countableEvent).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let pointCell = tableView.dequeueReusableCell(withIdentifier: CountableEventHappeningDescriptionCell.reuseIdentifier) as? CountableEventHappeningDescriptionCell
        else { return UITableViewCell() }

        let point = domain.getCountableEventHappeningDescriptions(for: countableEvent)[indexPath.row]
        pointCell.update(time: point.time, day: point.timeSince)
        return pointCell
    }
}
