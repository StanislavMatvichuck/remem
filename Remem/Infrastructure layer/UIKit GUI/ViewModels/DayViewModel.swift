//
//  DayViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

import UIKit

class DayViewModel: NSObject {
    typealias View = DayView
    typealias Model = Event

    // MARK: - Properties
    private let model: Model
    private let day: DateComponents
    private weak var view: View?

    private var shownHappenings = [Happening]()

    // MARK: - Init
    init(model: Model, day: DateComponents) {
        self.model = model
        self.day = day

        shownHappenings = model.happenings.filter { happening in
            guard let dayDate = Calendar.current.date(from: day) else { return false }
            return happening.dateCreated.isInSameDay(as: dayDate)
        }
    }
}

// MARK: - Public
extension DayViewModel {
    func configure(_ view: View) {
        self.view = view
        view.happenings.dataSource = self
        view.happenings.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension DayViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { shownHappenings.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DayHappeningCell.reuseIdentifier, for: indexPath)
            as? DayHappeningCell else { return UITableViewCell() }

        cell.label.text = "\(shownHappenings[indexPath.row].dateCreated)"

        return cell
    }
}
