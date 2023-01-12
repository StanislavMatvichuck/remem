//
//  ViewMain.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import UIKit

class EventsListView: UIView {
    // MARK: - Properties
    let input = EventInput()

    let table: UITableView = {
        let table = UITableView(al: true)
        table.backgroundColor = .clear
        table.separatorStyle = .none
        return table
    }()

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        backgroundColor = UIHelper.background
        addSubview(table)
        NSLayoutConstraint.activate([
            table.centerXAnchor.constraint(equalTo: centerXAnchor),
            table.centerYAnchor.constraint(equalTo: centerYAnchor),
            table.widthAnchor.constraint(equalTo: widthAnchor, constant: -2 * UIHelper.spacingListHorizontal),
            table.heightAnchor.constraint(equalTo: heightAnchor)
        ])
        addAndConstrain(input)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
