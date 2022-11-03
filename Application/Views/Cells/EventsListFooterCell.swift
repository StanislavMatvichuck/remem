//
//  EventsListFooterCell.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 26.07.2022.
//

import UIKit

// enabled/disabled state must be expressed in code
// variant: UIButton
// variant: custom UIView subclass
// variant: getter of UIKit properties of view

class EventsListFooterCell: UITableViewCell {
    static let reuseIdentifier = "EventsListFooterCell"

    // MARK: - Properties
    var buttonAdd: UIView = {
        let view = UIView(al: true)
        view.layer.cornerRadius = .r2
        view.layer.borderWidth = 3

        let label = UILabel(al: true)
        label.text = "+"
        label.textAlignment = .center
        label.font = UIHelper.fontBold

        view.addAndConstrain(label)

        return view
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Private
extension EventsListFooterCell {
    private func setupLayout() {
        backgroundColor = .clear

        contentView.addSubview(buttonAdd)

        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: EventCell.height),
            buttonAdd.heightAnchor.constraint(equalToConstant: .d2),
            buttonAdd.widthAnchor.constraint(equalTo: widthAnchor,
                                             constant: -2 * UIHelper.spacingListHorizontal),

            buttonAdd.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonAdd.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
