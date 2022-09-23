//
//  DayView.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

import UIKit

class DayView: UIView {
    // MARK: - Properties
    var happenings: UITableView = {
        let table = UITableView(al: true)

        table.register(DayHappeningCell.self, forCellReuseIdentifier: DayHappeningCell.reuseIdentifier)
        table.separatorStyle = .none
        table.tableFooterView = UIView(al: true)
        table.allowsSelection = false

        return table
    }()

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configureLayout() {
        addAndConstrain(happenings)
    }

    private func configureAppearance() {
        backgroundColor = UIHelper.background
    }
}
