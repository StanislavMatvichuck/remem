//
//  WeekController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.05.2022.
//

import UIKit

protocol WeekControllerDelegate: UIViewController {
    func weekControllerNewWeek(from: Date, to: Date)
}

class WeekController: UIViewController {
    // MARK: - Properties
    var event: DomainEvent!
    weak var delegate: WeekControllerDelegate?

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

// MARK: - Public
extension WeekController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let weekNumber = Int(scrollView.contentOffset.x / .wScreen)
        let weekOffset = event.weeksSince - 1 - weekNumber
        let dateStart = Date.now.days(ago: Int(weekOffset) * 7).startOfWeek!
        let dateEnd = dateStart.endOfWeek!
        delegate?.weekControllerNewWeek(from: dateStart, to: dateEnd)
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
