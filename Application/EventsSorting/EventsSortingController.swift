//
//  EventsSortingController.swift
//  Application
//
//  Created by Stanislav Matvichuck on 19.01.2024.
//

import Foundation
import UIKit

final class EventsSortingController: UIViewController {
    // MARK: - Properties
    private let viewRoot = EventsSortingView()
    private let factory: EventsSortingViewModelFactoring

    var viewModel: EventsSortingViewModel? { didSet {
        guard let viewModel else { return }
        viewRoot.viewModel = viewModel
    }}

    // MARK: - Init
    init(_ factory: EventsSortingViewModelFactoring) {
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = factory.makeEventsSortingViewModel()
    }
}
