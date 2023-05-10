//
//  PdfMaking.swift
//  Application
//
//  Created by Stanislav Matvichuck on 10.05.2023.
//

import Foundation

protocol PDFMaking {
    func make() -> Data
}

extension WeekViewController {
    func scrollTo(_ int: Int) {
        viewRoot.collection.layoutIfNeeded()
        viewRoot.collection.scrollToItem(
            at: IndexPath(row: int, section: 0),
            at: .left,
            animated: false)
        viewRoot.collection.setNeedsLayout()
        viewRoot.collection.layoutIfNeeded()
        viewRoot.configureSummary(viewModel)
    }
}
