//
//  HappeningsListView.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.05.2022.
//

import UIKit

class HappeningsListView: UIView {
    // MARK: - Properties
    let table: UITableView = {
        let view = UITableView(al: true)
        view.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: .sm, height: .sm / 2))
        view.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: .sm, height: .sm / 2))
        view.register(HappeningCell.self, forCellReuseIdentifier: HappeningCell.reuseIdentifier)
        view.scrollIndicatorInsets = UIEdgeInsets(top: .sm, left: 0, bottom: .sm, right: .sm / 2)
        view.allowsSelection = false
        view.separatorStyle = .none

        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = .sm
        return view
    }()

    // MARK: Private

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        addAndConstrain(table, constant: UIHelper.spacing)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
