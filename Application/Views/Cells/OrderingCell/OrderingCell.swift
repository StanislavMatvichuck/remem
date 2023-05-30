//
//  OrderingItem.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.04.2023.
//

import UIKit

final class OrderingCell: UITableViewCell, EventsListCell {
    static var reuseIdentifier = "OrderingItem"

    let view = OrderingCellView()
    var viewModel: OrderingCellViewModel? {
        didSet {
            guard let viewModel else { return }
            view.configure(viewModel)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
        configureAppearance()
        configureEventHandlers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private
    private func configureLayout() {
        contentView.addAndConstrain(view)
        let heightConstraint = contentView.heightAnchor.constraint(equalToConstant: .layoutSquare)
        heightConstraint.priority = .defaultHigh
        heightConstraint.isActive = true
    }

    private func configureAppearance() {
        selectionStyle = .none
        backgroundColor = .clear
    }

    private func configureEventHandlers() {
        view.scroll.delegate = self
    }
}

extension OrderingCell: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let itemOffset = OrderingCellViewItem.width + .buttonMargin
        let selectedIndex = Int(scrollView.contentOffset.x / itemOffset)
        viewModel?.items[selectedIndex].select()
    }
}
