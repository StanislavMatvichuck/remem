//
//  StatsViewController.swift
//  Application
//
//  Created by Stanislav Matvichuck on 29.01.2023.
//

import UIKit

final class SummaryController: UIViewController, SummaryDataProviding {
    var viewModel: Loadable<SummaryViewModel>? { didSet {
        guard isViewLoaded, let viewModel else { return }
        viewRoot.viewModel = viewModel
    }}

    let factory: any LoadableSummaryViewModelFactoring
    let viewRoot: SummaryView
    let loadingHandler: LoadableViewModelHandling

    init(
        view: SummaryView,
        viewModelFactory: any LoadableSummaryViewModelFactoring,
        loadingHandler: LoadableViewModelHandling
    ) {
        self.factory = viewModelFactory
        self.viewRoot = view
        self.loadingHandler = loadingHandler
        view.viewModel = Loadable<SummaryViewModel>()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError(errorUIKitInit) }

    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureList()
        loadingHandler.load(for: viewRoot, factory: factory)
    }
    
    deinit { loadingHandler.cancel(for: viewRoot) }

    // MARK: - Private

    private func configureList() {
        viewRoot.dataSource.viewModelProvider = self
    }
}
