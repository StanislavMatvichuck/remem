//
//  PdfContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 14.03.2023.
//

import Foundation

final class PDFReadingContainer: PDFReadingControllerFactoring {
    func makePDFReadingController(url: URL) -> PDFReadingViewController {
        PDFReadingViewController(url: url)
    }
}
