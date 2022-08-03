//
//  ViewMain.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import UIKit

class EventsListView: UIView {
    // MARK: I18n
    static let empty = NSLocalizedString("empty.EventsList", comment: "entries list empty")
    static let firstHappening = NSLocalizedString("empty.EventsList.firstHappening", comment: "entries list first point")
    static let firstDetails = NSLocalizedString("empty.EventsList.firstDetailsInspection", comment: "entries list first details opening")

    // MARK: - Properties
    let input: UIMovableTextViewInterface = UIMovableTextView()

    lazy var viewTable: UITableView = {
        let view = UITableView(al: true)
        view.register(EventCell.self, forCellReuseIdentifier: EventCell.reuseIdentifier)
        view.backgroundColor = .clear
        view.allowsSelection = false
        view.separatorStyle = .none
        return view
    }()

    lazy var hint: EventsListHintCell = {
        let cell = EventsListHintCell(
            style: .default,
            reuseIdentifier: EventsListHintCell.reuseIdentifier)
        return cell
    }()

    lazy var footer: EventsListFooterCell = {
        let cell = EventsListFooterCell(
            style: .default,
            reuseIdentifier: EventsListFooterCell.reuseIdentifier)
        return cell
    }()

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        backgroundColor = UIHelper.itemBackground
        setupLayout()
        addAndConstrain(input)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Private
extension EventsListView {
    private func setupLayout() {
        addSubview(viewTable)

        NSLayoutConstraint.activate([
            viewTable.topAnchor.constraint(equalTo: topAnchor),
            viewTable.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewTable.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewTable.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
