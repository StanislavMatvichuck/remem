//
//  OrderingItem.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.04.2023.
//

import UIKit

final class OrderingItem: UITableViewCell, EventsListCell {
    static var reuseIdentifier = "OrderingItem"

    let view = OrderingItemView()
    var viewModel: OrderingItemViewModel? {
        didSet {
            guard let viewModel else { return }
            view.configure(viewModel)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
        configureAppearance()
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
}
