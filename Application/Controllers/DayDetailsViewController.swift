//
//  DayController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

import Domain
import UIKit

protocol DayDetailsViewModelFactoring { func makeDayDetailsViewModel() -> DayDetailsViewModel }

final class DayDetailsViewController: UIViewController {
    let factory: DayDetailsViewModelFactoring
    let viewRoot: DayDetailsView
    var viewModel: DayDetailsViewModel { didSet {
        viewModel.pickerDate = viewRoot.picker.date
        viewRoot.configure(viewModel: viewModel)
    } }

    init(_ factory: DayDetailsViewModelFactoring) {
        self.factory = factory
        self.viewModel = factory.makeDayDetailsViewModel()
        self.viewRoot = DayDetailsView(viewModel: viewModel)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        configureTableView()
        configureEventHandlers()
    }

    private func configureTableView() {
        viewRoot.happenings.dataSource = self
        viewRoot.happenings.delegate = self
    }

    private func configureEventHandlers() {
        viewRoot.button.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
    }

    @objc private func handleButton() {
        viewModel.addHappening(date: viewRoot.picker.date)
    }

    @objc private func handleClose() {
        presentingViewController?.dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension DayDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewModel.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DayItem.reuseIdentifier,
            for: indexPath
        ) as? DayItem else { fatalError("unable to dequeue cell") }
        cell.label.text = viewModel.items[indexPath.row].text
        return cell
    }

    func tableView(_: UITableView, trailingSwipeActionsConfigurationForRowAt index: IndexPath) -> UISwipeActionsConfiguration? {
        UISwipeActionsConfiguration(actions: [
            UIContextualAction(
                style: .destructive,
                title: viewModel.delete
            ) { _, _, completion in
                self.viewModel.items[index.row].remove()
                completion(true)
            },
        ])
    }
}
