//
//  DayHappeningCell.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

import UIKit

class DayItem: UITableViewCell {
    static let reuseIdentifier = "DayHappeningCell"

    // MARK: - Properties
    var label: UILabel = {
        let label = UILabel(al: true)

        label.numberOfLines = 1
        label.font = .fontBold
        label.textColor = UIColor.text_primary
        label.heightAnchor.constraint(equalToConstant: .layoutSquare).isActive = true

        return label
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addAndConstrain(label, left: .buttonMargin, right: .buttonMargin)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
