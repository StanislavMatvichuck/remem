//
//  ClockController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.05.2022.
//

import UIKit

class ClockController: UIViewController {
    // MARK: - Properties
    var event: CDEvent!
    private let viewRoot = ClockView()
    private let service = ClockService(HappeningsRepository())
    private var viewModel: ClockViewModel! {
        didSet { viewModel.configure(viewRoot) }
    }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {}

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLists()
    }
}

// MARK: - Private
extension ClockController {
    private func setupLists() {
        guard
            let start = Date.now.startOfWeek,
            let end = Date.now.endOfWeek
        else { return }

        updateLists(from: start, to: end)
    }

    private func updateLists(from: Date, to: Date) {
        let happenings = service.getList(for: event, between: from, and: to)
        var newList = ClockSectionsList()
        newList.fill(with: happenings)

        viewModel = ClockViewModel(model: newList)
    }
}
