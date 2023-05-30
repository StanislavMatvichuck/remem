//
//  OrderingItemView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.04.2023.
//

import UIKit

final class OrderingCellView: UIView {
    let scroll: UIScrollView = {
        let scroll = UIScrollView(al: true)
        scroll.isPagingEnabled = true
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()

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

    private var scrollToIndex: Int?

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

        scrollToIndex = viewModel.selectedItemIndex
    }

    // MARK: - Private
    private func configureLayout() {
        scroll.addAndConstrain(stack)
        addAndConstrain(scroll)
    }

    private func clearContent() {
        for view in stack.arrangedSubviews { view.removeFromSuperview() }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        scroll.layoutIfNeeded()
        if let scrollToIndex {
            let offset = CGPoint(x: CGFloat(scrollToIndex) * OrderingCellViewItem.width + .buttonMargin, y: 0)
            scroll.setContentOffset(offset, animated: false)
        }
    }
}
