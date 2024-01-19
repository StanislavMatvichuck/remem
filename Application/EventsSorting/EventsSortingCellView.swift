//
//  EventsSortingCellView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 18.01.2024.
//

import UIKit

final class EventsSortingCellView: UIView {
    let title: UILabel = {
        let label = UILabel(al: true)
        label.font = .font
        return label
    }()

    var viewModel: EventsSortingCellViewModel? { didSet {
        guard let viewModel else { return }
        configureContent(viewModel)
    }}

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Private
    private func configureLayout() {
        heightAnchor.constraint(equalToConstant: .buttonHeight).isActive = true
        let horizontalMargin = CGFloat.buttonMargin + EventsSortingView.borderWidth
        addAndConstrain(title, left: horizontalMargin, right: horizontalMargin)
    }

    private func configureAppearance() {
        backgroundColor = .clear
        title.textColor = .text
    }

    private func configureContent(_ vm: EventsSortingCellViewModel) {
        title.text = vm.title
        backgroundColor = vm.isActive ? .primary : .clear
        title.textColor = vm.isActive ? .bg_item : .text
    }
}
