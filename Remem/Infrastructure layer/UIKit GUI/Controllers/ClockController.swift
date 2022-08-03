//
//  ClockController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.05.2022.
//

import UIKit

class ClockController: UIViewController {
    // MARK: - Properties
    var event: Event!

    private let viewRoot = ClockView()
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
        var newList = ClockSectionsList()
        newList.fill(with: event.happenings)
        viewModel = ClockViewModel(model: newList)
    }
}
