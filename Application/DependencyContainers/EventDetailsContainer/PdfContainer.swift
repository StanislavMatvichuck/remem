//
//  PdfContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 14.03.2023.
//

import UIKit

final class PdfContainer: ControllerFactoring {
    let provider: URLProviding

    init(provider: URLProviding) { self.provider = provider }

    func make() -> UIViewController {
        PdfViewController(provider)
    }
}
