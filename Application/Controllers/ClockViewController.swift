//
//  ClockViewController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.05.2022.
//

import Domain
import UIKit

class ClockViewController: UIViewController {
    let viewRoot: ClockView
    var viewModel: ClockViewModel {
        didSet {
            viewRoot.clockFace.viewModel = viewModel
        }
    }

    init(viewModel: ClockViewModel) {
        self.viewModel = viewModel
        self.viewRoot = ClockView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {}
}
