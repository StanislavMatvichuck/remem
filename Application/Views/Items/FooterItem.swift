//
//  FooterItem.swift
//  Application
//
//  Created by Stanislav Matvichuck on 04.01.2023.
//

import UIKit

class FooterItem: UITableViewCell, EventsListCell {
    static var reuseIdentifier = "FooterItem"

    let button: UIButton = {
        let button = UIButton(al: true)
        button.layer.cornerRadius = .buttonRadius
        return button
    }()

    var viewModel: FooterItemViewModel? {
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

    private func configureLayout() {
        contentView.addSubview(button)
        let height = contentView.heightAnchor.constraint(equalToConstant: 2 * .layoutSquare)
        height.priority = .defaultLow /// tableView constraints fix

        NSLayoutConstraint.activate([
            height,
            button.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -2 * .buttonMargin),
            button.heightAnchor.constraint(equalToConstant: .buttonHeight),
            button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    private func configureAppearance() {
        selectionStyle = .none
        backgroundColor = .clear
    }

    private func configureEventHandlers() {
        button.addTarget(self, action: #selector(handleButton(sender:)), for: .touchUpInside)
    }

    @objc private func handleButton(sender _: UIButton) {
        animateTapReceiving()
        viewModel?.select()
    }
}
