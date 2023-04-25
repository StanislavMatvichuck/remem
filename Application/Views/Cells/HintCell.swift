//
//  HintItem.swift
//  Application
//
//  Created by Stanislav Matvichuck on 04.01.2023.
//

import UIKit

final class HintCell: UITableViewCell, EventsListCell {
    static var reuseIdentifier = "HintItem"

    var viewModel: HintCellViewModel? {
        didSet {
            guard let viewModel else { return }

            label.text = viewModel.title
            label.textColor = UIColor.secondary

            if viewModel.highlighted { label.font = .fontBold }
            else { label.font = .fontSmall }
        }
    }

    let label: UILabel = {
        let label = UILabel(al: true)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.numberOfLines = 1
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configureLayout() {
        contentView.addAndConstrain(label, left: .buttonMargin, right: .buttonMargin)
        let heightConstraint = contentView.heightAnchor.constraint(equalToConstant: .layoutSquare)
        heightConstraint.priority = .defaultHigh
        heightConstraint.isActive = true
    }

    private func configureAppearance() {
        backgroundColor = .clear
        selectionStyle = .none
    }

    override func prepareForReuse() {
        viewModel = nil
        super.prepareForReuse()
    }
}
