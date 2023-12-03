//
//  VisualisationMakingViewController.swift
//  Application
//
//  Created by Stanislav Matvichuck on 03.12.2023.
//

import UIKit

final class VisualisationMakingViewController: UIViewController {
    let viewRoot: VisualisationMakingView
    override func loadView() { view = viewRoot }

    init(_ viewRoot: VisualisationMakingView) {
        self.viewRoot = viewRoot
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
