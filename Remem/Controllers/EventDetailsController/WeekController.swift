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
    var event: Event!
    weak var delegate: WeekControllerDelegate?

    private var service = WeekService(HappeningsRepository())
    private let viewRoot = WeekView()
    private var viewModel: WeekViewModel!

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        let model = service.weekList(for: event)
        viewModel = WeekViewModel(model: model)
        viewModel.configure(viewRoot)
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
