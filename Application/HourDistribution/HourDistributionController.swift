//
//  HourDistributionController.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2024.
//

import UIKit

final class HourDistributionController: UIViewController {
    // MARK: - Properties
    let viewRoot = HourDistributionView()
    let factory: any LoadableHourDistributionViewModelFactoring
    let loadingHandler: LoadableViewModelHandling
    var viewModel: Loadable<HourDistributionViewModel>? = Loadable<HourDistributionViewModel>() { didSet {
        viewRoot.viewModel = viewModel
    }}

    // MARK: - Init
    init(
        viewModelFactory: any LoadableHourDistributionViewModelFactoring,
        loadingHandler: LoadableViewModelHandling
    ) {
        self.factory = viewModelFactory
        self.loadingHandler = loadingHandler
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError(errorUIKitInit) }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingHandler.load(for: viewRoot, factory: factory)
    }

    deinit { loadingHandler.cancel(for: viewRoot) }
}
