//
//  FooterItem.swift
//  Application
//
//  Created by Stanislav Matvichuck on 04.01.2023.
//

import UIKit

final class FooterCell: UITableViewCell, EventsListCell {
    static var reuseIdentifier = "FooterItem"

    let button: UIButton = {
        let button = UIButton(al: true)
        button.layer.cornerRadius = .buttonRadius
        return button
    }()

    var viewModel: FooterCellViewModel? {
        didSet {
            guard let viewModel else { return }

            let background: UIColor = {
                viewModel.isHighlighted ?
                    UIColor.primary :
                    UIColor.background_secondary
            }()

            let foreground: UIColor = {
                viewModel.isHighlighted ?
                    UIColor.text_secondary :
                    UIColor.primary
            }()

            let attributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font: UIFont.fontSmallBold,
                NSAttributedString.Key.foregroundColor: foreground,
            ]

            button.setAttributedTitle(
                NSAttributedString(
                    string: viewModel.title,
                    attributes: attributes
                ),
                for: .normal
            )

            button.backgroundColor = background
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
        configureAppearance()
        configureEventHandlers()
    }

    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func prepareForReuse() {
        viewModel = nil
        super.prepareForReuse()
    }

    // MARK: - Private
    private func configureLayout() {
        contentView.addAndConstrain(button, constant: .buttonMargin)
        let height = contentView.heightAnchor.constraint(equalToConstant: 2 * .layoutSquare)
        height.priority = .defaultHigh /// tableView constraints fix
        height.isActive = true
    }

    private func configureAppearance() {
        selectionStyle = .none
        backgroundColor = .clear
    }

    private func configureEventHandlers() {
        button.addTarget(self, action: #selector(handleTouchUp), for: .touchUpInside)
    }

    // MARK: - Events handling
    @objc private func handleTouchUp(_: UIButton) {
        viewModel?.select()
    }
}
