//
//  ClockViewController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.05.2022.
//

import Domain
import UIKit

protocol ClockViewModelFactoring { func makeClockViewModel() -> ClockViewModel }

final class ClockViewController: UIViewController {
    let factory: ClockViewModelFactoring
    let viewRoot: ClockView
    var viewModel: ClockViewModel {
        didSet {
            viewRoot.clockFace.viewModel = viewModel
        }
    }

    init(_ factory: ClockViewModelFactoring) {
        self.factory = factory
        self.viewModel = factory.makeClockViewModel()
        self.viewRoot = ClockView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {}
}
