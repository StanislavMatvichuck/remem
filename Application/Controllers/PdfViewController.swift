//
//  PdfViewController.swift
//  Application
//
//  Created by Stanislav Matvichuck on 13.03.2023.
//

import PDFKit
import UIKit

final class PdfViewController: UIViewController {
    private let provider: URLProviding
    private let viewRoot: PdfView

    init(_ provider: URLProviding) {
        self.provider = provider
        self.viewRoot = PdfView(provider.url)
        super.init(nibName: nil, bundle: nil)
        navigationItem.largeTitleDisplayMode = .never
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() { view = viewRoot }
}
