//
//  EventsListViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 14.07.2022.
//

import UIKit

class EventsListViewModel: NSObject {
    typealias View = EventsListView
    typealias Model = [Event]

    enum HintState {
        case empty
        case placeFirstMark
        case pressMe
        case noHints
    }

    // MARK: - Properties
    private var model: Model
    private weak var view: View?

    private var isEventsAddingHighlighted = true

    // MARK: - Init
    init(model: Model) {
        self.model = model

        isEventsAddingHighlighted = model.count == 0
    }
}

// MARK: - Public
extension EventsListViewModel {
    func configure(_ view: View) {
        self.view = view

        view.viewTable.dataSource = self
        view.viewTable.reloadData()

        configureEventsAddingButton()
        configureHints()
    }
}

// MARK: - Private
extension EventsListViewModel {
    private func configureEventsAddingButton() {
        if isEventsAddingHighlighted {
            view?.buttonAdd.backgroundColor = .systemBlue
        } else {
            view?.buttonAdd.backgroundColor = .systemGray
        }
    }

    // Hints configuration
    private func configureHints() {
        hideAllHints()
        switch getHintState() {
        case .empty:
            showEmptyState()
        case .placeFirstMark:
            showFirstHappeningState()
        case .pressMe:
            showFirstDetails()
        case .noHints:
            hideAllHints()
        }
    }

    private func getHintState() -> HintState {
        if model.count == 0 { return .empty }
        if model.filter({ $0.freshPoint != nil }).count == 0 { return .placeFirstMark }
        if model.filter({ $0.dateVisited != nil }).count == 0 { return .pressMe }
        return .noHints
    }

    private func showEmptyState() {
        view?.emptyLabel.isHidden = false
    }

    private func showFirstHappeningState() {
        view?.firstHappeningLabel.isHidden = false
        view?.cellGestureView.isHidden = false
    }

    private func showFirstDetails() {
        view?.inspectEventLabel.isHidden = false
    }

    private func hideAllHints() {
        view?.inspectEventLabel.isHidden = true
        view?.firstHappeningLabel.isHidden = true
        view?.cellGestureView.isHidden = true
        view?.emptyLabel.isHidden = true
    }
}

// MARK: - UITableViewDataSource
extension EventsListViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { true }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { model.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let row = tableView.dequeueReusableCell(withIdentifier:
                EventCell.reuseIdentifier) as? EventCell
        else { return UITableViewCell() }

        let dataRow = model[indexPath.row]

        row.configure(name: dataRow.name!, value: dataRow.totalAmount)

        return row
    }
}
