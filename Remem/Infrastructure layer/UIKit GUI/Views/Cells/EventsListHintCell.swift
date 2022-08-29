//
//  EventsListHintCell.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 26.07.2022.
//

import UIKit

class EventsListHintCell: UITableViewCell {
    static let reuseIdentifier = "EventsListHintCell"

    // MARK: - Properties
    lazy var label: UILabel = {
        let label = UILabel(al: true)
        label.textAlignment = .center
        label.textColor = UIHelper.itemFont
        label.font = UIHelper.fontBold
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setup()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Private
extension EventsListHintCell {
    private func setup() {
        backgroundColor = .clear

        contentView.addAndConstrain(label, constant: UIHelper.spacing)
    }
}
