//
//  EventsListViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 14.07.2022.
//

import UIKit

class EventsListViewModel: NSObject {
    typealias View = EventsListView
    typealias Model = [DomainEvent]

    enum HintState {
        case empty
        case placeFirstMark
        case pressMe
        case noHints
    }

    enum Section: Int {
        case hint
        case events
        case footer
    }

    // MARK: - Properties
    private var model: Model
    private weak var view: View?

    private var isEventsAddingHighlighted: Bool
    private var hintsState: HintState

    // MARK: - Init
    init(model: Model) {
        self.isEventsAddingHighlighted = model.count == 0
        self.hintsState = Self.getHintState(for: model)
        self.model = model
    }
}

// MARK: - Public
extension EventsListViewModel {
    func configure(_ view: View) {
        self.view = view

        configureHintText()
        configureEventsAddingButton()

        view.viewTable.dataSource = self
        view.viewTable.reloadData()
    }
}

// MARK: - Private
extension EventsListViewModel {
    private func configureEventsAddingButton() {
        if isEventsAddingHighlighted {
            view?.footer.buttonAdd.backgroundColor = .systemBlue
        } else {
            view?.footer.buttonAdd.backgroundColor = .systemGray
        }
    }

    private func configureHintText() {
        switch hintsState {
        case .empty:
            view?.hint.label.text = EventsListView.empty
        case .placeFirstMark:
            view?.hint.label.text = EventsListView.firstHappening
        case .pressMe:
            view?.hint.label.text = EventsListView.firstDetails
        case .noHints:
            view?.hint.label.text = nil
        }
    }

    private static func getHintState(for model: Model) -> HintState {
        if model.count == 0 { return .empty }
        if model.filter({ $0.happenings.count > 0 }).count == 0 { return .placeFirstMark }
        if model.filter({ $0.dateVisited != nil }).count == 0 { return .pressMe }
        return .noHints
    }

    private func setupSwipeHint(_ indexPath: IndexPath, _ row: EventCell) {
        guard
            indexPath.row == 0,
            indexPath.section == 1,
            hintsState == .placeFirstMark
        else {
            removeSwipeHint(from: row)
            return
        }
        let swipeView = SwipeGestureView(mode: .horizontal, edgeInset: .r2 + UIHelper.spacingListHorizontal)
        row.contentView.addAndConstrain(swipeView)
        swipeView.start()
    }

    private func removeSwipeHint(from row: EventCell) {
        for view in row.contentView.subviews where view is SwipeGestureView {
            view.removeFromSuperview()
        }
    }

    private func makeEventCellFor(_ index: IndexPath) -> UITableViewCell {
        guard
            let row = view?.viewTable.dequeueReusableCell(withIdentifier:
                EventCell.reuseIdentifier) as? EventCell
        else { return UITableViewCell() }

        let dataRow = model[index.row]
        row.configure(name: dataRow.name, value: dataRow.happenings.count)
        setupSwipeHint(index, row)
        return row
    }
}

// MARK: - UITableViewDataSource
extension EventsListViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        Section(rawValue: indexPath.section) == .events
    }

    func numberOfSections(in tableView: UITableView) -> Int { 3 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Section(rawValue: section) == .hint {
            return 1
        } else if Section(rawValue: section) == .events {
            return model.count
        } else if Section(rawValue: section) == .footer {
            return 1
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let footer = view?.footer,
            let hint = view?.hint
        else { return UITableViewCell() }

        if Section(rawValue: indexPath.section) == .hint {
            return hint
        } else if Section(rawValue: indexPath.section) == .events {
            return makeEventCellFor(indexPath)
        } else if Section(rawValue: indexPath.section) == .footer {
            return footer
        }

        return UITableViewCell()
    }
}
