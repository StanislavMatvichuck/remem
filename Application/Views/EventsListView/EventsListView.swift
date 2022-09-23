//
//  ViewMain.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import UIKit

class EventsListView: UIView {
    // MARK: I18n
    static let delete = NSLocalizedString("button.contextual.delete", comment: "EventsList swipe gesture actions")
    static let rename = NSLocalizedString("button.contextual.rename", comment: "EventsList swipe gesture actions")

    // MARK: - Properties
    let input: UIMovableTextViewInterface = {
        UIMovableTextView()
    }()

    let table: UITableView = {
        let table = UITableView(al: true)
        table.register(EventCell.self,
                       forCellReuseIdentifier: EventCell.reuseIdentifier)
        table.register(EventsListHintCell.self,
                       forCellReuseIdentifier: EventsListHintCell.reuseIdentifier)
        table.register(EventsListFooterCell.self,
                       forCellReuseIdentifier: EventsListFooterCell.reuseIdentifier)
        table.backgroundColor = .clear
        table.separatorStyle = .none
        return table
    }()

    let swipeHint: SwipeGestureView = {
        SwipeGestureView(mode: .horizontal,
                         edgeInset: .r2 + UIHelper.spacingListHorizontal)
    }()

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        backgroundColor = UIHelper.itemBackground
        addAndConstrain(table)
        addAndConstrain(input)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
