//
//  StatsViewController.swift
//  Application
//
//  Created by Stanislav Matvichuck on 29.01.2023.
//

import UIKit

final class SummaryViewController: UIViewController {
    var viewModel: SummaryViewModel
    var viewRoot: SummaryView

    init(viewModel: SummaryViewModel) {
        self.viewModel = viewModel
        self.viewRoot = SummaryView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func loadView() { view = viewRoot }
}
