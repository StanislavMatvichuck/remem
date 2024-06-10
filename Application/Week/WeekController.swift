//
//  WeekController.swift
//  Application
//
//  Created by Stanislav Matvichuck on 27.12.2023.
//

import UIKit

final class WeekController: UIViewController {
    let factory: any LoadableWeekViewModelFactoring
    let viewRoot: WeekView
    let loadingHandler: LoadableViewModelHandling

    var viewModel: Loadable<WeekViewModel> { didSet { viewRoot.viewModel = viewModel }}

    init(
        viewModelFactory: any LoadableWeekViewModelFactoring,
        view: WeekView,
        loadingHandler: LoadableViewModelHandling
    ) {
        let vm = Loadable<WeekViewModel>()
        self.factory = viewModelFactory
        self.viewModel = vm
        self.viewRoot = view
        self.loadingHandler = loadingHandler
        view.viewModel = vm
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError(errorUIKitInit) }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingHandler.load(for: viewRoot, factory: factory)
    }

    override func viewDidLayoutSubviews() { scrollToLastPage() }

    deinit { loadingHandler.cancel(for: viewRoot) }

    private func scrollToLastPage() {
        guard let viewModel = viewRoot.viewModel?.vm else { return }
        let lastPageIndex = IndexPath(row: viewModel.pagesCount - 1, section: 0)
        viewRoot.collection.scrollToItem(at: lastPageIndex, at: .right, animated: false)
    }
}
