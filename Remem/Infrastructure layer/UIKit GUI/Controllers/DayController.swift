//
//  DayController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

import UIKit

class DayController: UIViewController {
    // MARK: - Properties
    var event: Event!
    var day: DateComponents!

    private let viewRoot = DayView()
    private var viewModel: DayViewModel! {
        didSet { viewModel.configure(viewRoot) }
    }

    // MARK: - Init
    init() { super.init(nibName: nil, bundle: nil) }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        view.backgroundColor = UIHelper.background
        viewModel = DayViewModel(model: event, day: day)
        configureTitle()
    }
}

// MARK: - Private
extension DayController {
    private func configureTitle() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM"
        title = dateFormatter.string(for: Calendar.current.date(from: day))
    }
}
