//
//  PdfViewController.swift
//  Application
//
//  Created by Stanislav Matvichuck on 13.03.2023.
//

import PDFKit
import UIKit

final class PDFReadingController: UIViewController {
    private let url: URL
    let viewRoot: PDFReadingView

    init(url: URL) {
        self.url = url
        self.viewRoot = PDFReadingView(url)
        super.init(nibName: nil, bundle: nil)
        configureNavigationItem()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() { view = viewRoot }

    private func configureNavigationItem() {
        navigationItem.largeTitleDisplayMode = .never
        setupShareButton()
    }

    private func setupShareButton() {
        let shareButton = UIBarButtonItem(
            title: String(localizationId: "pdf.share"),
            style: .plain,
            target: self,
            action: #selector(showShare)
        )

        shareButton.accessibilityIdentifier = UITestID.buttonPdfShare.rawValue

        navigationItem.rightBarButtonItem = shareButton
    }

    @objc private func showShare() {
        let share = makeShare()

        navigationController?.present(share, animated: true)
    }

    private func makeShare() -> UIViewController {
        let data = NSData(contentsOf: url)

        let vc = UIActivityViewController(
            activityItems: [data],
            applicationActivities: nil
        )

        return vc
    }
}
