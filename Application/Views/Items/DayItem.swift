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
        label.font = UIHelper.fontBold
        label.textColor = UIColor.text_primary

        return label
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addAndConstrain(label, constant: UIHelper.spacing)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
