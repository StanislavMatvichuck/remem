//
//  HourDistributionView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2024.
//

import UIKit

final class HourDistributionView: UIView {
    var viewModel: HourDistributionViewModel? { didSet {
        guard let viewModel else { return }
        configureContent(viewModel)
    }}

    private let stack: UIStackView = {
        let view = UIStackView(al: true)
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 2.0
        return view
    }()

    init() {
        super.init(frame: .zero)
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Private
    private func configureLayout() {
        addAndConstrain(
            stack,
            top: 0, left: .buttonMargin,
            right: .buttonMargin, bottom: 0
        )

        heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1.2 / 3).isActive = true
    }

    private func configureAppearance() {}
    private func configureContent(_ vm: HourDistributionViewModel) {
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for index in 0 ..< vm.count {
            let cell = HourDistributionCellView()
            cell.viewModel = vm.cell(at: index)
            stack.addArrangedSubview(cell)
        }
    }
}
