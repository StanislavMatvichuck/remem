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

    var tapService: ShowCreateEventService?

    override init(frame: CGRect) {
        super.init(frame: frame)
        isAccessibilityElement = true
        accessibilityIdentifier = UITestAccessibilityIdentifier.buttonCreteEvent.rawValue
        configureLayout()
        configureAppearance()
        configureEventHandlers()
    }

    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func prepareForReuse() {
        viewModel = nil
        tapService = nil
        super.prepareForReuse()
    }

    // MARK: - Private
    private func configureLayout() {
        contentView.addAndConstrain(button, constant: .buttonMargin)
        let height = contentView.heightAnchor.constraint(equalToConstant: 2 * .layoutSquare)
        height.priority = .defaultHigh /// tableView constraints fix
        height.isActive = true
        addInvisibleDropAreaForUITesting()
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

    private func addInvisibleDropAreaForUITesting() {
        let uiTestingDropArea = UIView(al: true)
        uiTestingDropArea.isAccessibilityElement = true
        uiTestingDropArea.accessibilityIdentifier = UITestAccessibilityIdentifier.removeEventArea.rawValue
        uiTestingDropArea.backgroundColor = .clear
        contentView.addSubview(uiTestingDropArea)
        uiTestingDropArea.widthAnchor.constraint(equalToConstant: 1.0).isActive = true
        uiTestingDropArea.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        uiTestingDropArea.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .buttonMargin).isActive = true
        uiTestingDropArea.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    // MARK: - Events handling
    @objc private func handleTouchUp(_: UIButton) { tapService?.serve(ApplicationServiceEmptyArgument()) }
}
