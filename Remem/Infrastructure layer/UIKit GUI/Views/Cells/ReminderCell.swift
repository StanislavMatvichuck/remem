//
//  ReminderCell.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 22.04.2022.
//

import UIKit

class ReminderCell: UITableViewCell {
    static let reuseIdentifier = "ReminderCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
