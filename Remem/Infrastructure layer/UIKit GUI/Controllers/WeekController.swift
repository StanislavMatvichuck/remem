//
//  WeekController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.05.2022.
//

import UIKit

class WeekController: UIViewController {
    // MARK: - Properties
    var event: DomainEvent!

    private let viewRoot = WeekView()
    private var viewModel: WeekViewModel!

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        setupServiceAndViewModel()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.scrollToCurrentWeek()
    }
}

// MARK: - Private
extension WeekController {
    private func setupServiceAndViewModel() {
        guard
            let endOfCurrentWeek = Date.now.endOfWeek,
            let startOfCreationWeek = event.dateCreated.startOfWeek
        else { return }

        let weekList = WeekList(from: startOfCreationWeek,
                                to: endOfCurrentWeek,
                                happenings: event.happenings)

        viewModel = WeekViewModel(model: weekList)
        viewModel.configure(viewRoot)
    }
}
