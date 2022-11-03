//
//  EventsListFooterCell.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 26.07.2022.
//

import UIKit

class EventsListFooterCell: UITableViewCell {
    static let reuseIdentifier = "EventsListFooterCell"

    // MARK: - Properties
    var createEvent: UIButton = {
        let button = UIButton(al: true)
        let title = NSAttributedString(
            string: String(localizationId: "button.create"),
            attributes: [
                NSAttributedString.Key.font: UIHelper.fontSmallBold,
            ])

        button.setAttributedTitle(title, for: .normal)
        button.setAttributedTitle(title, for: .highlighted)

        button.isHighlighted = true

        button.backgroundColor = UIHelper.brand
        button.layer.cornerRadius = .r2
        button.layer.borderWidth = 3

        return button
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func resignHighlight() {
        createEvent.isHighlighted = false
        createEvent.backgroundColor = UIHelper.itemBackground
    }

    func highlight() {
        createEvent.isHighlighted = true
        createEvent.backgroundColor = UIHelper.brand
    }
}

// MARK: - Private
extension EventsListFooterCell {
    private func setupLayout() {
        backgroundColor = .clear

        contentView.addSubview(createEvent)

        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: EventCell.height),
            createEvent.heightAnchor.constraint(equalToConstant: .d2),
            createEvent.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                               constant: -2 * UIHelper.spacingListHorizontal),

            createEvent.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            createEvent.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
