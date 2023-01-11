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

    let swipeHint: SwipeGestureView = {
        SwipeGestureView(
            mode: .horizontal,
            edgeInset: UIHelper.r2 + UIHelper.spacingListHorizontal
        )
    }()

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        backgroundColor = UIHelper.background
        addAndConstrain(table)
        addAndConstrain(input)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
