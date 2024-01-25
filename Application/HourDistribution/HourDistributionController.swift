//
//  HourDistributionController.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2024.
//

import UIKit

final class HourDistributionController: UIViewController {
    // MARK: - Properties
    private let viewRoot = HourDistributionView()
    private let factory: HourDistributionViewModelFactoring
    var viewModel: HourDistributionViewModel? { didSet {
        viewRoot.viewModel = viewModel
    }}

    // MARK: - Init
    init(_ factory: HourDistributionViewModelFactoring) {
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = factory.makeHourDistributionViewModel()
    }
}
