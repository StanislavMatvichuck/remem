//
//  PdfMakingViewController.swift
//  Application
//
//  Created by Stanislav Matvichuck on 13.03.2023.
//

import UIKit

protocol PdfMakingViewModelFactoring {
    func makePdfMakingViewModel() -> PdfMakingViewModel
}

final class PdfMakingViewController: UIViewController {
    let viewRoot: PdfMakingView
    let factory: PdfMakingViewModelFactoring
    let viewModel: PdfMakingViewModel

    init(_ factory: PdfMakingViewModelFactoring) {
        self.factory = factory
        self.viewRoot = PdfMakingView()
        self.viewModel = factory.makePdfMakingViewModel()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEventHandlers()
    }

    private func setupEventHandlers() {
        viewRoot.button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }

    @objc func handleTap(_: UIButton) {
        viewRoot.button.animateTapReceiving()
        viewModel.tapHandler()
    }
}
