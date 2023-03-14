//
//  PdfMakingViewController.swift
//  Application
//
//  Created by Stanislav Matvichuck on 13.03.2023.
//

import UIKit

final class PdfMakingViewController: UIViewController {
    private let provider: URLProviding
    private let pdfMaker: PDFMaking
    private let saver: FileSaving
    private let completion: () -> ()
    let viewRoot: PdfMakingView

    init(
        provider: URLProviding,
        pdfMaker: PDFMaking,
        saver: FileSaving,
        completion: @escaping () -> ()
    ) {
        self.provider = provider
        self.pdfMaker = pdfMaker
        self.saver = saver
        self.completion = completion
        self.viewRoot = PdfMakingView()
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
        saver.save(pdfMaker.make(), to: provider.url)
        completion()
    }
}
