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
    var viewModel: ClockViewModel

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

extension ClockViewController: ClockViewModelUpdating {
    var currentViewModel: ClockViewModel { viewModel }
    func update(viewModel: ClockViewModel) {
        self.viewModel = viewModel

        guard
            let layers = viewRoot.clockFace.layer.sublayers as? [ClockItem]
        else { return }

        viewModel.items.enumerated().forEach { index, section in
            layers[index].viewModel = section
        }
    }
}
