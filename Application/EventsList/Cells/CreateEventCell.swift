//
//  CreateEventCell.swift
//  Application
//
//  Created by Stanislav Matvichuck on 04.01.2023.
//

import UIKit

final class CreateEventCell: UICollectionViewCell {
    static var reuseIdentifier = "CreateEventCell"

    let button = UIButton(al: true)

    var viewModel: CreateEventCellViewModel? {
        didSet {
            guard let viewModel else { return }

            let background: UIColor = {
                viewModel.isHighlighted ?
                    UIColor.primary :
                    UIColor.bg_item
            }()

            let foreground: UIColor = {
                viewModel.isHighlighted ?
                    UIColor.bg :
                    UIColor.primary
            }()

            let attributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font: UIFont.fontSmallBold,
                NSAttributedString.Key.foregroundColor: foreground,
            ]

            button.setAttributedTitle(
                NSAttributedString(
                    string: CreateEventCellViewModel.title,
                    attributes: attributes
                ),
                for: .normal
            )

            button.backgroundColor = background
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        accessibilityIdentifier = Self.reuseIdentifier
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

    @objc private func configureAppearance() {
        backgroundColor = .clear
        button.layer.cornerRadius = .buttonRadius
        button.layer.borderColor = UIColor.border.cgColor
        button.layer.borderWidth = .border
    }

    private func configureEventHandlers() {
        button.addTarget(self, action: #selector(handleTouchUp), for: .touchUpInside)
        if #available(iOS 17.0, *) {
            registerForTraitChanges([UITraitUserInterfaceStyle.self], target: self, action: #selector(configureAppearance))
        }
    }

    // MARK: - Events handling
    @objc private func handleTouchUp(_: UIButton) { viewModel?.handleTap() }
}
