//
//  CountableEventsListViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 14.07.2022.
//

import UIKit

class CountableEventsListViewModel: NSObject {
    typealias View = CountableEventsListView
    typealias Model = [CountableEvent]

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
extension CountableEventsListViewModel {
    func configure(_ view: View) {
        self.view = view

        view.viewTable.dataSource = self
        view.viewTable.reloadData()

        configureEventsAddingButton()
        configureHints()
    }
}

// MARK: - Private
extension CountableEventsListViewModel {
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
            showFirstCountableEventHappeningDescriptionState()
        case .pressMe:
            showFirstDetails()
        case .noHints:
            hideAllHints()
        }
    }

    private func getHintState() -> HintState {
        if model.count == 0 { return .empty }
        if model.filter({ $0.lastHappening != nil }).count == 0 { return .placeFirstMark }
        if model.filter({ $0.dateVisited != nil }).count == 0 { return .pressMe }
        return .noHints
    }

    private func showEmptyState() {
        view?.emptyLabel.isHidden = false
    }

    private func showFirstCountableEventHappeningDescriptionState() {
        view?.firstCountableEventHappeningDescriptionLabel.isHidden = false
        view?.cellGestureView.isHidden = false
    }

    private func showFirstDetails() {
        view?.inspectCountableEventLabel.isHidden = false
    }

    private func hideAllHints() {
        view?.inspectCountableEventLabel.isHidden = true
        view?.firstCountableEventHappeningDescriptionLabel.isHidden = true
        view?.cellGestureView.isHidden = true
        view?.emptyLabel.isHidden = true
    }
}

// MARK: - UITableViewDataSource
extension CountableEventsListViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { true }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { model.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let row = tableView.dequeueReusableCell(withIdentifier:
                CountableEventCell.reuseIdentifier) as? CountableEventCell
        else { return UITableViewCell() }

        let dataRow = model[indexPath.row]

        row.configure(name: dataRow.name!, value: dataRow.totalAmount)

        return row
    }
}
