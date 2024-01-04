//
//  PDFWritingViewController.swift
//  Application
//
//  Created by Stanislav Matvichuck on 13.03.2023.
//

import UIKit



final class PDFWritingViewController: UIViewController {
    let viewRoot: PDFWritingView
    let factory: PDFWritingViewModelFactoring
    let viewModel: PDFWritingViewModel

    init(_ factory: PDFWritingViewModelFactoring) {
        self.factory = factory
        self.viewRoot = PDFWritingView()
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
