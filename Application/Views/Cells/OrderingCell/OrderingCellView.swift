//
//  OrderingItemView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.04.2023.
//

import UIKit

final class OrderingCellView: UIView {
    let stack: UIStackView = {
        let margin = .layoutSquare * 3.5 - OrderingCellViewItem.width / 2

        let stack = UIStackView(al: true)
        stack.axis = .horizontal
        stack.spacing = .buttonMargin
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(
            top: 0, left: margin,
            bottom: 0, right: margin
        )
        return stack
    }()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ viewModel: OrderingCellViewModel) {
        clearContent()

        for item in viewModel.items {
            stack.addArrangedSubview(OrderingCellViewItem(item))
        }
    }

    // MARK: - Private
    private func configureLayout() {
        let scroll = UIScrollView(al: true)
        scroll.addAndConstrain(stack)
        scroll.isPagingEnabled = true
        scroll.showsHorizontalScrollIndicator = false

        addAndConstrain(scroll)
    }

    private func clearContent() {
        for view in stack.arrangedSubviews { view.removeFromSuperview() }
    }
}
