//
//  DayViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

import UIKit

protocol DayViewModelDelegate: AnyObject {
    func remove(happening: Happening)
}

class DayViewModel: NSObject {
    typealias View = DayView
    typealias Model = Event

    // MARK: - Properties
    weak var delegate: DayViewModelDelegate?

    private let model: Model
    private let day: DateComponents
    private weak var view: View?

    private var shownHappenings = [Happening]()

    // MARK: - Init
    init(model: Model, day: DateComponents) {
        self.model = model
        self.day = day

        shownHappenings = model.happenings(forDay: Calendar.current.date(from: day)!).reversed()
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

        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none

        let happeningDate = shownHappenings[indexPath.row].dateCreated
        let displayedText = dateFormatter.string(from: happeningDate)

        cell.label.text = displayedText

        return cell
    }

    // Cells deletion
    func tableView(_: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath)
    {
        if
            editingStyle == .delete,
            let happening = happening(at: indexPath)
        {
            delegate?.remove(happening: happening)
        }
    }
}

// MARK: - Private
extension DayViewModel {
    private func happening(at index: IndexPath) -> Happening? {
        guard
            index.row <= shownHappenings.count,
            index.row >= 0
        else { return nil }

        return shownHappenings[index.row]
    }
}
