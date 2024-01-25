//
//  HourDistributionView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2024.
//

import UIKit

final class HourDistributionView: UIView {
    init() {
        super.init(frame: .zero)
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Private
    private func configureLayout() {}
    private func configureAppearance() {}
}
