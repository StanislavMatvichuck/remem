//
//  FooterItem.swift
//  Application
//
//  Created by Stanislav Matvichuck on 04.01.2023.
//

import UIKit

class FooterItem: UITableViewCell {
    let button: UIButton = {
        let title = NSAttributedString(
            string: "",
            attributes: [
                NSAttributedString.Key.font: UIHelper.fontSmallBold,
            ]
        )

        let button = UIButton(al: true)
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = UIHelper.brand
        button.layer.cornerRadius = UIHelper.r2
        button.layer.borderWidth = 3
        button.isHighlighted = true
        return button
    }()

    var viewModel: FooterItemViewModel? {
        didSet {
            guard let viewModel else { return }

            let attributes: [NSAttributedString.Key: Any] = {
                viewModel.isHighlighted ?
                    [NSAttributedString.Key.font: UIHelper.fontSmallBold] :
                    [NSAttributedString.Key.font: UIHelper.fontSmall]
            }()

            button.setAttributedTitle(
                NSAttributedString(
                    string: viewModel.title,
                    attributes: attributes
                ),
                for: .normal
            )
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
        contentView.addAndConstrain(button)
        button.heightAnchor.constraint(equalToConstant: UIHelper.d2).isActive = true
    }

    private func configureAppearance() {
        selectionStyle = .none
        backgroundColor = .clear
    }

    private func configureEventHandlers() {
        button.addTarget(self, action: #selector(handleButton(sender:)), for: .touchUpInside)
    }

    @objc private func handleButton(sender _: UIButton) {
        viewModel?.select()
    }
}
