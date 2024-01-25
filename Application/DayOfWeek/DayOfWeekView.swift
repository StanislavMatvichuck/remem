//
//  DayOfWeekView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2024.
//

import UIKit

final class DayOfWeekView: UIStackView {
    var viewModel: DayOfWeekViewModel? { didSet {
        guard let viewModel else { return }
        configureContent(viewModel)
    } }

    init() {
        super.init(frame: .zero)
        axis = .horizontal
        distribution = .fillEqually
        alignment = .trailing
        configureLayout()
        configureAppearance()
    }

    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Private
    private func configureLayout() {}
    private func configureAppearance() {}
    private func configureContent(_ vm: DayOfWeekViewModel) {
        arrangedSubviews.forEach { $0.removeFromSuperview() }

        for index in 0 ..< vm.count {
            let cell = DayOfWeekCellView()
            cell.viewModel = vm.cell(at: index)
            addArrangedSubview(cell)
        }
    }
}
