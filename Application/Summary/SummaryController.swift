//
//  StatsViewController.swift
//  Application
//
//  Created by Stanislav Matvichuck on 29.01.2023.
//

import UIKit

final class SummaryController: UIViewController, UsingLoadableViewModel {
    var viewModel: Loadable<SummaryViewModel>? = Loadable<SummaryViewModel>() { didSet {
        guard isViewLoaded, let viewModel else { return }
        dataSource.viewModel = viewModel
        viewRoot.viewModel = viewModel
    }}

    let factory: any LoadableSummaryViewModelFactoring
    let viewRoot: SummaryView
    let loadingHandler: LoadableViewModelHandling
    let dataSource: SummaryDataSource

    init(
        view: SummaryView,
        viewModelFactory: any LoadableSummaryViewModelFactoring,
        dataSource: SummaryDataSource,
        loadingHandler: LoadableViewModelHandling
    ) {
        self.viewRoot = view
        self.factory = viewModelFactory
        self.dataSource = dataSource
        self.loadingHandler = loadingHandler
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError(errorUIKitInit) }

    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewRoot.viewModel = viewModel
        loadingHandler.load(for: self, factory: factory)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        loadingHandler.cancel(for: self)
    }
}
