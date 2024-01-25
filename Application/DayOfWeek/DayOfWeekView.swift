//
//  DayOfWeekView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2024.
//

import UIKit

final class DayOfWeekView: UIView {
    var viewModel: DayOfWeekViewModel? { didSet {
        guard let viewModel else { return }
        configureContent(viewModel)
    } }

    init() {
        super.init(frame: .zero)
        configureLayout()
        configureAppearance()
    }

    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Private
    private let stack: UIStackView = {
        let stack = UIStackView(al: true)
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .trailing
        stack.spacing = WeekPageView.daySpacing
        return stack
    }()

    private func configureLayout() {
        addAndConstrain(
            stack,
            top: 0, left: WeekPageView.daySpacing,
            right: WeekPageView.daySpacing, bottom: 0
        )
    }

    private func configureAppearance() {}
    private func configureContent(_ vm: DayOfWeekViewModel) {
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for index in 0 ..< vm.count {
            let cell = DayOfWeekCellView()
            cell.viewModel = vm.cell(at: index)
            stack.addArrangedSubview(cell)
        }
    }
}
