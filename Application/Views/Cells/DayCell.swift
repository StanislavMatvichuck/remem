//
//  DayHappeningCell.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

import UIKit

final class DayCell: UITableViewCell {
    static let reuseIdentifier = "DayHappeningCell"

    // MARK: - Properties
    var label: UILabel = {
        let label = UILabel(al: true)
        label.numberOfLines = 1
        label.font = .font
        label.textAlignment = .center
        return label
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configureLayout() {
        contentView.addAndConstrain(label, constant: DayDetailsView.margin)
    }

    private func configureAppearance() {
        selectionStyle = .none
        backgroundColor = .clear
        label.textColor = UIColor.text
    }
}
