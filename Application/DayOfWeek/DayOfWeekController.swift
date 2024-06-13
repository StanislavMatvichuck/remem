//
//  DayOfWeekController.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2024.
//

import Foundation
import UIKit

final class DayOfWeekController: UIViewController {
    let viewRoot = DayOfWeekView()
    let factory: any LoadableDayOfWeekViewModelFactoring
    let loadingHandler: LoadableViewModelHandling

    var viewModel: Loadable<DayOfWeekViewModel>? = Loadable<DayOfWeekViewModel>() { didSet {
        guard let viewModel else { return }
        viewRoot.viewModel = viewModel
    }}

    // MARK: - Init
    init(
        viewModelFactory: any LoadableDayOfWeekViewModelFactoring,
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
