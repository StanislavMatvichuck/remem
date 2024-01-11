//
//  ViewHappeningsList.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 25.01.2022.
//

import UIKit

final class EventDetailsView: UIView {
    // MARK: - Properties
    let scroll: ViewScroll

    // MARK: - Init
    init() {
        self.scroll = ViewScroll(.vertical)
        self.scroll.accessibilityIdentifier = UITestAccessibilityIdentifier.eventDetailsScroll.rawValue
        super.init(frame: .zero)

        configureLayout()
        configureAppearance()
    }

    private func configureLayout() {
        addAndConstrain(scroll)
    }

    private func configureAppearance() {
        backgroundColor = .bg
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
