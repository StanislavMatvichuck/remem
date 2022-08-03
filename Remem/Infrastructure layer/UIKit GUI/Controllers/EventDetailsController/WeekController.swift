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
    var event: CDEvent!
    weak var delegate: WeekControllerDelegate?

    private var service: WeekService!
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
        service = WeekService(event)

        guard let weekList = service.weekList() else { fatalError("Unable to create week list") }
        viewModel = WeekViewModel(model: weekList)
        viewModel.configure(viewRoot)
    }
}
