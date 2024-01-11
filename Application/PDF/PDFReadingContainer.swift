//
//  PdfContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 14.03.2023.
//

import UIKit

final class PDFReadingContainer: ControllerFactoring {
    let provider: URLProviding

    init(provider: URLProviding) { self.provider = provider }

    func make() -> UIViewController {
        PDFReadingViewController(provider)
    }
}
