//
//  WeekController.swift
//  Application
//
//  Created by Stanislav Matvichuck on 27.12.2023.
//

import UIKit

final class WeekController: UIViewController, UsingLoadableViewModel {
    let factory: any LoadableWeekViewModelFactoring
    let viewRoot: WeekView
    let loadingHandler: LoadableViewModelHandling

    var viewModel: Loadable<WeekViewModel>? = Loadable<WeekViewModel>() { didSet {
        guard let viewModel else { return }
        dataSource.viewModel = viewModel
        viewRoot.viewModel = viewModel
    }}

    private let dataSource: WeekDataSource

    init(
        viewModelFactory: any LoadableWeekViewModelFactoring,
        view: WeekView,
        dataSource: WeekDataSource,
        loadingHandler: LoadableViewModelHandling
    ) {
        self.factory = viewModelFactory
        self.viewRoot = view
        self.loadingHandler = loadingHandler
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError(errorUIKitInit) }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingHandler.load(for: self, factory: factory)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        loadingHandler.cancel(for: self)
    }
}
