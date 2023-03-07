//
//  StatsViewController.swift
//  Application
//
//  Created by Stanislav Matvichuck on 29.01.2023.
//

import UIKit

protocol SummaryViewModelFactoring { func makeSummaryViewModel() -> SummaryViewModel }

final class SummaryViewController: UIViewController {
    var viewModel: SummaryViewModel { didSet {
        guard isViewLoaded else { return }
        viewRoot.configureContent(viewModel: viewModel)
    }}

    let factory: SummaryViewModelFactoring
    let viewRoot: SummaryView

    init(_ factory: SummaryViewModelFactoring) {
        self.factory = factory
        self.viewModel = factory.makeSummaryViewModel()
        self.viewRoot = SummaryView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func loadView() { view = viewRoot }
    override func viewDidLoad() {}
}
